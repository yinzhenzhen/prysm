package main

import (
	"context"
	"flag"
	"fmt"
	"github.com/prysmaticlabs/prysm/beacon-chain/cache"
	"github.com/prysmaticlabs/prysm/beacon-chain/db"
	"github.com/prysmaticlabs/prysm/shared/featureconfig"
	"github.com/prysmaticlabs/prysm/shared/params"
)

var (
	// Required fields
	datadir = flag.String("datadir", "", "Path to data directory.")

	state = flag.Uint("state", 0, "Extract state at this slot.")
)

func main() {
	resetCfg := featureconfig.InitWithReset(&featureconfig.Flags{WriteSSZStateTransitions: true})
	defer resetCfg()
	flag.Parse()
	fmt.Println("Starting process...")
	d, err := db.NewDB(*datadir, cache.NewStateSummaryCache())
	if err != nil {
		panic(err)
	}
	ctx := context.Background()
	st, err := d.HeadState(ctx)
	if err != nil {
		panic(err)
	}
	m := make(map[uint64]int)
	for _, ev := range st.Eth1DataVotes() {
		c := ev.DepositCount
		if _, ok := m[c]; ok {
			m[c]++
		} else {
			m[c] = 1
		}
	}

	max := 0
	sum := len(st.Eth1DataVotes())
	for k, v := range m {
		fmt.Printf("%d = %d\n", k, v)
		if v > max {
			max = v
		}
	}

	round := params.BeaconConfig().EpochsPerEth1VotingPeriod*params.BeaconConfig().SlotsPerEpoch
	fmt.Printf("Majority vote percentage %0.2f\n", float64(max)/float64(sum)*100)
	fmt.Printf("Required votes for majority = %d\n", round/2)
	fmt.Printf("Slots left in voting round %d of %d\n", round-st.Slot()%round, round)
	fmt.Printf("Round ends at slot %d\n", st.Slot()+round-st.Slot()%round)
	fmt.Printf("Current slot %d\n", st.Slot())

	//interop.WriteStateToDisk(st)
	fmt.Println("done")
}
