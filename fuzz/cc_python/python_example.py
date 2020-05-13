from eth2spec.phase0 import spec
from eth2spec.utils import bls


def FuzzerInit(bls_disabled: bool) -> None:
    """
    Initialize fuzzer parameters. This method is called once at the start of a fuzz test and can be used to initialiaze
    eth2spec configuration as needed.
    :param bls_disabled: Whether or not to disable BLS signature verification.
    """
    if bls_disabled:
        bls.bls_active = False

def FuzzerRunOne(data):
    """
    A very simple example of calling a spec function.
    :param data: Input data as bytes.
    :return: A 32 byte array.
    """
    return spec.hash(data)