package precompute

import (
	"context"
	"testing"

	ethpb "github.com/prysmaticlabs/ethereumapis/eth/v1alpha1"
	"github.com/prysmaticlabs/go-bitfield"
	"github.com/prysmaticlabs/prysm/beacon-chain/state"
	pb "github.com/prysmaticlabs/prysm/proto/beacon/p2p/v1"
	"github.com/prysmaticlabs/prysm/shared/params"
)

func BenchmarkProcessRewardsAndPenaltiesPrecompute(b *testing.B) {
	e := params.BeaconConfig().SlotsPerEpoch
	validatorCount := uint64(20480)
	base := buildState(e+3, validatorCount)
	atts := make([]*pb.PendingAttestation, 3)
	for i := 0; i < len(atts); i++ {
		atts[i] = &pb.PendingAttestation{
			Data: &ethpb.AttestationData{
				Target: &ethpb.Checkpoint{},
				Source: &ethpb.Checkpoint{},
			},
			AggregationBits: bitfield.Bitlist{0xC0, 0xC0, 0xC0, 0xC0, 0x01},
			InclusionDelay:  1,
		}
	}
	base.PreviousEpochAttestations = atts

	st, err := state.InitializeFromProto(base)
	if err != nil {
		b.Fatal(err)
	}

	vp, bp, err := New(context.Background(), st)
	if err != nil {
		b.Error(err)
	}
	vp, bp, err = ProcessAttestations(context.Background(), st, vp, bp)
	if err != nil {
		b.Fatal(err)
	}

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_, err = ProcessRewardsAndPenaltiesPrecompute(st, bp, vp)
		if err != nil {
			b.Fatal(err)
		}
	}
}
