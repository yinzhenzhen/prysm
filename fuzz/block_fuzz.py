import os
import sys

from eth2spec.debug import decode
from eth2spec.phase0 import spec
from eth2spec.utils import bls
from eth2spec.utils.ssz.ssz_impl import serialize
from eth2spec.utils.ssz.ssz_typing import uint8, uint32
# from preset_loader import loader
#
# # TODO fix up so not hard-coded
# configs_path = "/eth2/eth2.0-specs/configs"
# # Apply 'mainnet' template
# presets = loader.load_presets(configs_path, "mainnet")
# spec.apply_constants_preset(presets)

VALIDATE_STATE_ROOT = True

class BlockTestCase(spec.Container):
    pre: spec.BeaconState
    block: spec.SignedBeaconBlock


def FuzzerInit(bls_disabled: bool) -> None:
    if bls_disabled:
        bls.bls_active = False


def FuzzerRunOne(fuzzer_input):
    state_block = decode(fuzzer_input, BlockTestCase)

    try:
        poststate = spec.state_transition(
            state=state_block.pre,
            signed_block=state_block.block,
            validate_result=VALIDATE_STATE_ROOT,
        )
        return serialize(poststate)
    except (AssertionError, IndexError):
        return None