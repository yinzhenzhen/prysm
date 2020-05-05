package stategen

import (
	"context"
	"encoding/hex"
	"fmt"

	"github.com/pkg/errors"
	ethpb "github.com/prysmaticlabs/ethereumapis/eth/v1alpha1"
	"github.com/prysmaticlabs/prysm/beacon-chain/state"
	"github.com/prysmaticlabs/prysm/shared/bytesutil"
	"github.com/prysmaticlabs/prysm/shared/params"
	"github.com/sirupsen/logrus"
	"go.opencensus.io/trace"
)

// This saves a pre finalized beacon state in the cold section of the DB. The returns an error
// and not store anything if the state does not lie on an archive point boundary.
func (s *State) saveColdState(ctx context.Context, blockRoot [32]byte, state *state.BeaconState) error {
	ctx, span := trace.StartSpan(ctx, "stateGen.saveColdState")
	defer span.End()

	if state.Slot()%s.slotsPerArchivedPoint != 0 {
		return nil
	}

	if err := s.beaconDB.SaveState(ctx, state, blockRoot); err != nil {
		return err
	}
	archivedIndex := state.Slot() / s.slotsPerArchivedPoint
	if err := s.beaconDB.SaveArchivedPointRoot(ctx, blockRoot, archivedIndex); err != nil {
		return err
	}

	log.WithFields(logrus.Fields{
		"slot":      state.Slot(),
		"blockRoot": hex.EncodeToString(bytesutil.Trunc(blockRoot[:]))}).Info("Saved full state on archived point")

	return nil
}

// This loads the cold state by block root.
func (s *State) loadColdStateByRoot(ctx context.Context, blockRoot [32]byte) (*state.BeaconState, error) {
	ctx, span := trace.StartSpan(ctx, "stateGen.loadColdStateByRoot")
	defer span.End()

	summary, err := s.stateSummary(ctx, blockRoot)
	if err != nil {
		return nil, errors.Wrap(err, "could not get state summary")
	}

	return s.ComputeStateUpToSlot(ctx, summary.Slot)
}

// This loads a cold state by slot.
func (s *State) loadColdStateBySlot(ctx context.Context, slot uint64) (*state.BeaconState, error) {
	ctx, span := trace.StartSpan(ctx, "stateGen.loadColdStateBySlot")
	defer span.End()

	if slot == 0 {
		return s.beaconDB.GenesisState(ctx)
	}

	archivedIndex := slot/params.BeaconConfig().SlotsPerArchivedPoint - 1
	archivedRoot := s.beaconDB.ArchivedPointRoot(ctx, archivedIndex)
	fmt.Println(slot, archivedIndex, hex.EncodeToString(archivedRoot[:]))
	archivedState, err := s.beaconDB.State(ctx, archivedRoot)
	if err != nil {
		return nil, err
	}
	if archivedState == nil {
		lastAncestorState, err := s.lastAncestorState(ctx, archivedRoot)
		if err != nil {
			return nil, err
		}
		if lastAncestorState == nil {
			return nil, errUnknownState
		}
		fmt.Println("last ancestor state  ", lastAncestorState.Slot())
		b, err := s.beaconDB.Block(ctx, archivedRoot)
		if err != nil {
			return nil, err
		}
		fmt.Println("last ancestor block  ", b.Block.Slot)
		blks, err := s.LoadBlocks(ctx, lastAncestorState.Slot()+1, b.Block.Slot, archivedRoot)
		if err != nil {
			return nil, errors.Wrap(err, "could not load blocks for cold state using root")
		}
		fmt.Println("Processed ", len(blks))
		lastAncestorState, err = s.ReplayBlocks(ctx, lastAncestorState, blks, slot)
		if err != nil {
			return nil, errors.Wrap(err, "could not replay blocks for cold state using root")
		}
		fmt.Println("last ancestor state  ", lastAncestorState.Slot())
		return lastAncestorState, nil
	}
	if archivedState.Slot() == slot {
		return archivedState, nil
	}

	lastBlockRoot, lastBlockSlot, err := s.lastSavedBlock(ctx, slot)
	if err != nil {
		return nil, errors.Wrap(err, "could not get last saved block")
	}
	// Short circuit if no block was saved, replay using slots only.
	if lastBlockSlot == 0 {
		return s.ReplayBlocks(ctx, archivedState, []*ethpb.SignedBeaconBlock{}, slot)
	}
	if archivedState.Slot() >= slot {
		return archivedState, nil
	}
	blks, err := s.LoadBlocks(ctx, archivedState.Slot()+1, lastBlockSlot, lastBlockRoot)
	if err != nil {
		return nil, errors.Wrap(err, "could not load blocks")
	}
	archivedState, err = s.ReplayBlocks(ctx, archivedState, blks, slot)
	if err != nil {
		return nil, errors.Wrap(err, "could not replay blocks")
	}

	return archivedState, nil
}
