// Adapted from https://github.com/sigp/beacon-fuzz (MIT License).

#pragma once

#include <cstdint>
#include <optional>
#include <string>
#include <vector>

namespace fuzzing {

class Runnable {
public:
  Runnable(void);
  virtual ~Runnable();

  /**
   * Run fuzzer and return resulting SSZ encoded BeaconState.
   *
   * @param data SSZ encoded input data.
   * @return Resulting SSZ encoded BeaconState.
   */
  virtual std::optional<std::vector<uint8_t>>
  Run(const std::vector<uint8_t> &data) = 0;

  /**
   * Name of this runnable fuzzer.
   *
   * @return Name of the runnable fuzzer.
   */
  virtual const std::string &name() = 0;
};

} // namespace fuzzing