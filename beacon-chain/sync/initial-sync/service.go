package initialsync

import (
	"context"
	"errors"
	"time"

	"github.com/prysmaticlabs/prysm/beacon-chain/db"
	"github.com/prysmaticlabs/prysm/beacon-chain/p2p"
	"github.com/prysmaticlabs/prysm/shared"
)

var _ = shared.Service(&InitialSync{})

const minHandshakes = 1

type InitialSync struct {
	synced bool

	ctx context.Context
	db  db.Database
	p2p p2p.P2P
}

func (s *InitialSync) Start() {
	// Initial sync criteria:
	// - Has the chain started? Yes -> exit initial sync.
	// - Do we have enough peers / handshakes to start syncing? no -> wait for peers.

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
