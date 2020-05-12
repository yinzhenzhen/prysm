// Adapted from https://github.com/sigp/beacon-fuzz (MIT License).
#pragma once

#ifdef __cplusplus
extern "C" {
#endif
typedef void *GoFuzzResult;

/**
 * The method that the go code is expected to implement.
 * @param data Input data.
 * @param size Size of input data.
 * @return Returns a pointer to a (loaded) GoFuzzResult.
 */
GoFuzzResult GO_LLVMFuzzerTestOneInput(char *data, size_t size);

/**
 * Loads a GoFuzzResult with the result data.
 *
 * @param data Input data.
 * @param size Size of input data.
 * @return Returns a pointer to the newly created and loaded GoFuzzResult.
 */
GoFuzzResult LoadGoFuzzResult(unsigned char *data, size_t size);
#ifdef __cplusplus
}
#endif
