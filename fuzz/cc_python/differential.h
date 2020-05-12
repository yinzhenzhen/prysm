// Adapted from https://github.com/sigp/beacon-fuzz (MIT License).

#pragma once

#include <cstdint>
#include <memory>
#include <vector>

#include "runnable.h"

namespace fuzzing {

class Differential {
private:
  std::vector<std::shared_ptr<Runnable>> modules;

public:
  Differential(void);
  ~Differential();

  /**
   * AddModule to compare in differential fuzzing.
   *
   * @param module A runnable fuzzer module.
   */
  void AddModule(std::shared_ptr<Runnable> module);

  /**
   * Run all registered modules and diff the results.
   *
   * @param data SSZ encoded input data.
   */
  void Run(const std::vector<uint8_t> &data);

  /**
   * Run all registered modules and diff the results.
   *
   * @param data Input data array.
   * @param size Size of input data array.
   */
  void Run(uint8_t *data, size_t size);
};

} // namespace fuzzing