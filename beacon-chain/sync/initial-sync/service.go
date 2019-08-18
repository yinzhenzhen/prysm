package initialsync

import (
	"context"
	"errors"
	"time"

	"github.com/prysmaticlabs/prysm/beacon-chain/blockchain"
	"github.com/prysmaticlabs/prysm/beacon-chain/core/helpers"
	"github.com/prysmaticlabs/prysm/beacon-chain/db"
	"github.com/prysmaticlabs/prysm/beacon-chain/p2p"
	"github.com/prysmaticlabs/prysm/beacon-chain/powchain"
	"github.com/prysmaticlabs/prysm/beacon-chain/sync"
	ethpb "github.com/prysmaticlabs/prysm/proto/eth/v1alpha1"
	"github.com/prysmaticlabs/prysm/shared"
	"github.com/prysmaticlabs/prysm/shared/params"
)

var _ = shared.Service(&InitialSync{})

const minHandshakes = 1

type InitialSync struct {
	synced bool

	ctx     context.Context
	db      db.Database
	p2p     p2p.P2P
	web3    *powchain.Web3Service
	regSync *sync.RegularSync
	chain   *blockchain.ChainService
}

func (s *InitialSync) Start() {
	ctx := s.ctx
	// Initial sync criteria:
	// - Has the chain started? Yes -> exit initial sync.
	// - Do we have enough peers / handshakes to start syncing? no -> wait for peers.
	if !s.web3.HasChainStarted() {
		return
	}

	// This should wait until some minimum amount of peers and/or hpeer handshakes
	// then start the sync from genesis.
	handshakes := s.p2p.Handshakes()
	for {
		if len(handshakes) >= minHandshakes {
			break
		}

		log.WithField("handshakes", len(handshakes)).Info("Waiting for more peer handshakes to sync")
		time.Sleep(3 * time.Second)
		handshakes = s.p2p.Handshakes()
	}

	// Do the sync from genesis!
	// Algorithm:
	// - Main loop to sync batches of epochs across peers
	// - Inner loop to spawn goroutines to initiate round robin sync
	// - At the end of the inner loop, wait for each request to resolve within a short timeout
	// - Retry any failed request to resolve the epoch
	// - Process the epoch worth of blocks
	// - Continue to the next epoch until we have reached the highest known finalized epoch.

	// TODO: Determine the best finalized epoch to start from.

	hs, err := s.db.HeadState(ctx)
	if err != nil {
		// TODO: Set fatal sync error and/or exit
		log.WithError(err).Error("Failed to get head state")
	}

	lastAttemptedSlot := hs.Slot

	// Sync to the last finalized slot.
	for {
		fe, fr := s.regSync.HighestFinalizedEpoch()
		hs, err = s.db.HeadState(ctx)
		if err != nil {
			// TODO: Set fatal sync error and/or exit
			log.WithError(err).Error("Failed to get head state")
		}

		// Synced to the last finalize slot
		if hs.Slot >= helpers.StartSlot(fe) {
			break
		}

		_ = fr

		to := helpers.StartSlot(helpers.SlotToEpoch(lastAttemptedSlot + params.BeaconConfig().SlotsPerEpoch))
		blks, err := s.requestBlocks(ctx, lastAttemptedSlot+1, to)

		if err != nil {
			// TODO: What to do?
			log.WithError(err).Error("Failed to request blocks")
		}

		for _, b := range blks {
			_, err := s.chain.ReceiveBlock(ctx, b)
			if err != nil {
				log.WithError(err).Error("hmm invalid block?")
			}
		}

		lastAttemptedSlot = to
	}

	// Sync to head, or close enough to it...

}

func (s *InitialSync) requestBlocks(ctx context.Context, from uint64, to uint64) ([]*ethpb.BeaconBlock, error) {
	// Round robin sync around all peers
	return nil, nil
}

func (s *InitialSync) Stop() error {
	return nil
}

func (s *InitialSync) Status() error {
	if !s.synced {
		return errors.New("syncing")
	}
	return nil
}
