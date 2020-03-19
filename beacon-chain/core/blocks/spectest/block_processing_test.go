package spectest

import (
	"context"
	"fmt"
	"io/ioutil"
	"path"
	"strings"
	"testing"

	"github.com/bazelbuild/rules_go/go/tools/bazel"
	"github.com/gogo/protobuf/proto"
	"github.com/protolambda/zssz/merkle"
	ethpb "github.com/prysmaticlabs/ethereumapis/eth/v1alpha1"
	"github.com/prysmaticlabs/go-ssz"
	"github.com/prysmaticlabs/prysm/beacon-chain/core/helpers"
	"github.com/prysmaticlabs/prysm/beacon-chain/core/state"
	beaconstate "github.com/prysmaticlabs/prysm/beacon-chain/state"
	"github.com/prysmaticlabs/prysm/beacon-chain/state/stateutil"
	pb "github.com/prysmaticlabs/prysm/proto/beacon/p2p/v1"
	"github.com/prysmaticlabs/prysm/shared/hashutil"
	"github.com/prysmaticlabs/prysm/shared/params/spectest"
	"github.com/prysmaticlabs/prysm/shared/testutil"
	messagediff "gopkg.in/d4l3k/messagediff.v1"
)

func runBlockProcessingTest(t *testing.T, config string) {
	if err := spectest.SetConfig(config); err != nil {
		t.Fatal(err)
	}

	testFolders, testsFolderPath := testutil.TestFolders(t, config, "sanity/blocks/pyspec_tests")
	for _, folder := range testFolders {
		t.Run(folder.Name(), func(t *testing.T) {
			helpers.ClearCache()
			preBeaconStateFile, err := testutil.BazelFileBytes(testsFolderPath, folder.Name(), "pre.ssz")
			if err != nil {
				t.Fatal(err)
			}
			beaconStateBase := &pb.BeaconState{}
			if err := ssz.Unmarshal(preBeaconStateFile, beaconStateBase); err != nil {
				t.Fatalf("Failed to unmarshal: %v", err)
			}
			beaconState, err := beaconstate.InitializeFromProto(beaconStateBase)
			if err != nil {
				t.Fatal(err)
			}

			file, err := testutil.BazelFileBytes(testsFolderPath, folder.Name(), "meta.yaml")
			if err != nil {
				t.Fatal(err)
			}

			metaYaml := &SanityConfig{}
			if err := testutil.UnmarshalYaml(file, metaYaml); err != nil {
				t.Fatalf("Failed to Unmarshal: %v", err)
			}

			var transitionError error
			for i := 0; i < metaYaml.BlocksCount; i++ {
				filename := fmt.Sprintf("blocks_%d.ssz", i)
				blockFile, err := testutil.BazelFileBytes(testsFolderPath, folder.Name(), filename)
				if err != nil {
					t.Fatal(err)
				}
				block := &ethpb.SignedBeaconBlock{}
				if err := ssz.Unmarshal(blockFile, block); err != nil {
					t.Fatalf("Failed to unmarshal: %v", err)
				}
				fmt.Printf("Block state root %#x\n", block.Block.StateRoot)
				beaconState, transitionError = state.ExecuteStateTransition(context.Background(), beaconState, block)
				if transitionError != nil {
					break
				}
				fieldRoots, err := stateutil.ComputeFieldRoots(beaconState.InnerStateUnsafe())
				if err != nil {
					t.Fatal(err)
				}
				fmt.Println("Our post state after applying block")
				for i := 0; i < len(fieldRoots); i++ {
					fmt.Printf("Field %d and root %#x\n", i, fieldRoots[i])
				}
				mtree := merkleize(fieldRoots)
				fmt.Printf("Our state roots merkleized: %#x\n", mtree[len(mtree)-1][0])
			}

			// If the post.ssz is not present, it means the test should fail on our end.
			postSSZFilepath, readError := bazel.Runfile(path.Join(testsFolderPath, folder.Name(), "post.ssz"))
			postSSZExists := true
			if readError != nil && strings.Contains(readError.Error(), "could not locate file") {
				postSSZExists = false
			} else if readError != nil {
				t.Fatal(readError)
			}

			if postSSZExists {
				if transitionError != nil {
					t.Errorf("Unexpected error: %v", transitionError)
				}

				postBeaconStateFile, err := ioutil.ReadFile(postSSZFilepath)
				if err != nil {
					t.Fatal(err)
				}

				postBeaconState := &pb.BeaconState{}
				if err := ssz.Unmarshal(postBeaconStateFile, postBeaconState); err != nil {
					t.Fatalf("Failed to unmarshal: %v", err)
				}
				fieldRoots, err := stateutil.ComputeFieldRoots(postBeaconState)
				if err != nil {
					t.Fatal(err)
				}
				fmt.Println("Expected post state after applying block")
				for i := 0; i < len(fieldRoots); i++ {
					fmt.Printf("Field %d and root %#x\n", i, fieldRoots[i])
				}
				mtree := merkleize(fieldRoots)
				fmt.Printf("Merkleized expected state roots: %#x\n", mtree[len(mtree)-1][0])

				if !proto.Equal(beaconState.InnerStateUnsafe(), postBeaconState) {
					diff, _ := messagediff.PrettyDiff(beaconState.InnerStateUnsafe(), postBeaconState)
					t.Log(diff)
					t.Fatal("Post state does not match expected")
				}
			} else {
				// Note: This doesn't test anything worthwhile. It essentially tests
				// that *any* error has occurred, not any specific error.
				if transitionError == nil {
					t.Fatal("Did not fail when expected")
				}
				t.Logf("Expected failure; failure reason = %v", transitionError)
				return
			}
		})
	}
}

func merkleize(leaves [][]byte) [][][]byte {
	hashFunc := hashutil.CustomSHA256Hasher()
	layers := make([][][]byte, merkle.GetDepth(uint64(len(leaves)))+1)
	for len(leaves) != 32 {
		leaves = append(leaves, make([]byte, 32))
	}
	currentLayer := leaves
	layers[0] = currentLayer

	// We keep track of the hash layers of a Merkle trie until we reach
	// the top layer of length 1, which contains the single root element.
	//        [Root]      -> Top layer has length 1.
	//    [E]       [F]   -> This layer has length 2.
	// [A]  [B]  [C]  [D] -> The bottom layer has length 4 (needs to be a power of two).
	i := 1
	for len(currentLayer) > 1 && i < len(layers) {
		layer := make([][]byte, 0)
		for i := 0; i < len(currentLayer); i += 2 {
			hashedChunk := hashFunc(append(currentLayer[i], currentLayer[i+1]...))
			layer = append(layer, hashedChunk[:])
		}
		currentLayer = layer
		layers[i] = currentLayer
		i++
	}
	return layers
}
