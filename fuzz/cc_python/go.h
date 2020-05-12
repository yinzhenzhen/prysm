// Adapted from https://github.com/sigp/beacon-fuzz (MIT License).
#pragma once

#include <cstddef>
#include <cstdint>
#include <optional>
#include <string>
#include <vector>

#include "runnable.h"

#ifdef __cplusplus
extern "C" {
#endif
typedef void *GoFuzzResult;
GoFuzzResult LoadGoFuzzResult(unsigned char *data, size_t size);

GoFuzzResult GO_LLVMFuzzerTestOneInput(unsigned char *data, size_t size);
#ifdef __cplusplus
}
#endif

namespace fuzzing {

class CxxGoFuzzResult {
public:
  std::optional<std::vector<uint8_t>> result;

  /**
   * Loads result from go fuzz implementation. This is necessary due to go's
   * garbage collector where references to allocated memory cannot be held after
   * the go method returns. Loading the result effectively copies the result
   * data to avoid GC erasure.
   *
   * @param data Input array.
   * @param size Size of input array.
   */
  virtual void LoadResult(unsigned char *data, size_t size) = 0;

};

class Go : public Runnable {
  std::string name_;

public:
  explicit Go(const std::string &name) : Runnable() { name_ = name; }

  std::optional<std::vector<uint8_t>>
  Run(const std::vector<uint8_t> &data) override {
    auto *result = (CxxGoFuzzResult *)GO_LLVMFuzzerTestOneInput(
        const_cast<unsigned char *>(data.data()), data.size());

    if (!result) {
        return std::nullopt;
    }
    return result->result;
  };
  const std::string &name() override { return name_; }
};

} // namespace fuzzing
