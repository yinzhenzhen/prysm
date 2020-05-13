from eth2spec.debug import decode
from eth2spec.phase0 import spec
from eth2spec.utils import bls
from eth2spec.utils.ssz.ssz_impl import serialize

# Disable cache
spec.hash = spec._hash

VALIDATE_STATE_ROOT = True

class BlockTestCase(spec.Container):
    state_id: spec.uint64
    block: spec.SignedBeaconBlock

def FuzzerInit(bls_disabled: bool) -> None:
    if bls_disabled:
        bls.bls_active = False

def load(state_id: int) -> spec.BeaconState:
    # TODO: Load state from disk.
    raise Exception("Loading state from disk is not implemented yet in python.")
    return None

def FuzzerRunOne(fuzzer_input):
    try:
        state_block = BlockTestCase.decode_bytes(fuzzer_input)
    except (Exception):
        return None # Failed to deserialize.

    try:
        prestate = load(state_block.state_id)
        poststate = spec.state_transition(
            state=prestate,
            signed_block=state_block.block,
            validate_result=VALIDATE_STATE_ROOT,
        )
        return serialize(poststate)
    except (AssertionError, IndexError):
        return None