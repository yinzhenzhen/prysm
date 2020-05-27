package beaconclient

import (
	"context"

	"github.com/prysmaticlabs/prysm/shared/blockutil"

	"github.com/pkg/errors"
	ethpb "github.com/prysmaticlabs/ethereumapis/eth/v1alpha1"
	"github.com/prysmaticlabs/prysm/shared/params"
	"go.opencensus.io/trace"
)

// RequestHistoricalAttestations requests all indexed attestations for a
// given epoch from a beacon node via gRPC.
func (bs *Service) RequestHistoricalAttestations(
	ctx context.Context,
	epoch uint64,
) ([]*ethpb.IndexedAttestation, error) {
	ctx, span := trace.StartSpan(ctx, "beaconclient.RequestHistoricalAttestations")
	defer span.End()
	indexedAtts := make([]*ethpb.IndexedAttestation, 0)
	res := &ethpb.ListIndexedAttestationsResponse{}
	var err error
	for {
		if ctx.Err() != nil {
			return nil, ctx.Err()
		}
		if res == nil {
			res = &ethpb.ListIndexedAttestationsResponse{}
		}
		res, err = bs.beaconClient.ListIndexedAttestations(ctx, &ethpb.ListIndexedAttestationsRequest{
			QueryFilter: &ethpb.ListIndexedAttestationsRequest_Epoch{
				Epoch: epoch,
			},
			PageSize:  int32(params.BeaconConfig().DefaultPageSize),
			PageToken: res.NextPageToken,
		})
		if err != nil {
			log.WithError(err).Errorf("could not request indexed attestations for epoch: %d", epoch)
			continue
		}
		indexedAtts = append(indexedAtts, res.IndexedAttestations...)
		log.Infof(
			"Retrieved %d/%d indexed attestations for epoch %d",
			len(indexedAtts),
			res.TotalSize,
			epoch,
		)
		if res.NextPageToken == "" || res.TotalSize == 0 || len(indexedAtts) == int(res.TotalSize) {
			break
		}
	}
	if err := bs.slasherDB.SaveIndexedAttestations(ctx, indexedAtts); err != nil {
		return nil, errors.Wrap(err, "could not save indexed attestations")
	}
	return indexedAtts, nil
}

// RequestHistoricalBlockHeaders requests all historical blocks for a
// given epoch from a beacon node via gRPC.
func (bs *Service) RequestHistoricalBlockHeaders(
	ctx context.Context,
	epoch uint64,
) ([]*ethpb.SignedBeaconBlockHeader, error) {
	ctx, span := trace.StartSpan(ctx, "beaconclient.RequestHistoricalBlocks")
	defer span.End()
	blkHdrs := make([]*ethpb.SignedBeaconBlockHeader, 0)
	res := &ethpb.ListBlocksResponse{}
	var err error
	for {
		if ctx.Err() != nil {
			return nil, ctx.Err()
		}
		if res == nil {
			res = &ethpb.ListBlocksResponse{}
		}
		res, err = bs.beaconClient.ListBlocks(ctx, &ethpb.ListBlocksRequest{
			QueryFilter: &ethpb.ListBlocksRequest_Epoch{
				Epoch: epoch,
			},
			PageSize:  int32(params.BeaconConfig().DefaultPageSize),
			PageToken: res.NextPageToken,
		})
		if err != nil {
			log.WithError(err).Errorf("could not request blocks for epoch: %d", epoch)
			continue
		}
		for _, blockCntr := range res.BlockContainers {
			blkHdr, err := blockutil.SignedBeaconBlockHeaderFromBlock(blockCntr.Block)
			if err != nil {
				log.WithError(err).Error("could not convert block to block header")
				continue
			}
			blkHdrs = append(blkHdrs, blkHdr)
		}
		log.Infof(
			"Retrieved %d/%d blocks for epoch %d",
			len(blkHdrs),
			res.TotalSize,
			epoch,
		)
		if res.NextPageToken == "" || res.TotalSize == 0 || len(blkHdrs) == int(res.TotalSize) {
			break
		}
	}
	return blkHdrs, nil
}
