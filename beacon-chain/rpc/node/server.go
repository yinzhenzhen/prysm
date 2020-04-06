package node

import (
	"context"
	"sort"

	ptypes "github.com/gogo/protobuf/types"
	ethpb "github.com/prysmaticlabs/ethereumapis/eth/v1alpha1"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/prysmaticlabs/prysm/beacon-chain/blockchain"
	"github.com/prysmaticlabs/prysm/beacon-chain/db"
	"github.com/prysmaticlabs/prysm/beacon-chain/p2p"
	"github.com/prysmaticlabs/prysm/beacon-chain/sync"
)

// Server defines a server implementation of the gRPC Node service,
// providing RPC endpoints for verifying a beacon node's sync status, genesis and
// version information, and services the node implements and runs.
type Server struct {
	SyncChecker        sync.Checker
	Server             *grpc.Server
	BeaconDB           db.ReadOnlyDatabase
	PeersFetcher       p2p.PeersProvider
	GenesisTimeFetcher blockchain.TimeFetcher
}

// GetSyncStatus checks the current network sync status of the node.
func (ns *Server) GetNodeInfo(ctx context.Context, _ *ptypes.Empty) (*ethpb.NodeInfo, error) {
	return nil, status.Error(codes.Unimplemented, "unimplemented")
}

// ListImplementedServices lists the services implemented and enabled by this node.
//
// Any service not present in this list may return UNIMPLEMENTED or
// PERMISSION_DENIED. The server may also support fetching services by grpc
// reflection.
func (ns *Server) ListImplementedServices(ctx context.Context, _ *ptypes.Empty) (*ethpb.ImplementedServices, error) {
	serviceInfo := ns.Server.GetServiceInfo()
	serviceNames := make([]string, 0, len(serviceInfo))
	for svc := range serviceInfo {
		serviceNames = append(serviceNames, svc)
	}
	sort.Strings(serviceNames)
	return &ethpb.ImplementedServices{
		Services: serviceNames,
	}, nil
}
