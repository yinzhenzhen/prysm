package sync

import (
	"github.com/libp2p/go-libp2p-core/peer"
	"github.com/prysmaticlabs/prysm/beacon-chain/p2p"
)

type initialSync struct {
	peers []peer.ID
	p2p   p2p.P2P
}
