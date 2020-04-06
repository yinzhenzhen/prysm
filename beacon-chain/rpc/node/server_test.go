package node

import (
	"context"
	"testing"

	ptypes "github.com/gogo/protobuf/types"
	ethpb "github.com/prysmaticlabs/ethereumapis/eth/v1alpha1"
	mockSync "github.com/prysmaticlabs/prysm/beacon-chain/sync/initial-sync/testing"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

func TestNodeServer_GetNodeInfo(t *testing.T) {
	mSync := &mockSync.Sync{IsSyncing: false}
	ns := &Server{
		SyncChecker: mSync,
	}
	if _, err := ns.GetNodeInfo(context.Background(), &ptypes.Empty{}); err == nil {
		t.Fatal("Expected unimplemented err, received nil")
	}
}

func TestNodeServer_GetImplementedServices(t *testing.T) {
	server := grpc.NewServer()
	ns := &Server{
		Server: server,
	}
	ethpb.RegisterNodeServer(server, ns)
	reflection.Register(server)

	res, err := ns.ListImplementedServices(context.Background(), &ptypes.Empty{})
	if err != nil {
		t.Fatal(err)
	}
	// We verify the services include the node service + the registered reflection service.
	if len(res.Services) != 2 {
		t.Errorf("Expected 2 services, received %d: %v", len(res.Services), res.Services)
	}
}
