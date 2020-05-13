// Adapted from https://github.com/sigp/beacon-fuzz (MIT License).
#include <experimental/propagate_const>
#include <filesystem>
#include <memory>
#include <optional>
#include <string>
#include <vector>

#include "runnable.h"

namespace fuzzing {
class Python : public Runnable {
public:
  /**
   * Python based runnable fuzzer.
   *
   * @param name Name of this runnable module.
   * @param argv0 Argv[0] of this program.
   * @param scriptPath Filepath to the python script with function FuzzerRunOne.
   * @param bls_disabled Whether or not to disable BLS verification.
   */
  Python(const std::string &name, const std::string &argv0,
           const std::filesystem::path &scriptPath,
           bool bls_disabled = true);

  /**
   * Run python method FuzzerRunOne in the provided script.
   *
   * @param data SSZ encoded input data.
   * @return resulting BeaconState in SSZ encoded bytes.
   */
  std::optional<std::vector<uint8_t>>
  Run(const std::vector<uint8_t> &data) override;

  // Name of this runnable module.
  const std::string &name() override;

  ~Python();

private:
  // Uses "pImpl" technique as described here to avoid including the whole
  // <Python.h>: https://en.cppreference.com/w/cpp/language/pimpl
  class Impl;
  std::experimental::propagate_const<std::unique_ptr<Impl>> pImpl_;
  std::string name_;
};
} // namespace fuzzing
