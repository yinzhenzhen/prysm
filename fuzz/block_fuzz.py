from eth2spec.debug import decode
from eth2spec.phase0 import spec
from eth2spec.utils import bls
from eth2spec.utils.ssz.ssz_impl import serialize

# Disable cache
spec.hash = spec._hash

VALIDATE_STATE_ROOT = True

class BlockTestCase(spec.Container):
    pre: spec.BeaconState
    block: spec.SignedBeaconBlock

def FuzzerInit(bls_disabled: bool) -> None:
    if bls_disabled:
        bls.bls_active = False

def FuzzerRunOne(fuzzer_input):
    try:
        state_block = decode.decode(fuzzer_input, BlockTestCase)
        poststate = spec.state_transition(
            state=state_block.pre,
            signed_block=state_block.block,
            validate_result=VALIDATE_STATE_ROOT,
        )
        return serialize(poststate)
    except (AssertionError, IndexError):
        return None