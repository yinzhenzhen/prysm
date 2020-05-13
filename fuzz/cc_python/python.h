// Adapted from https://github.com/sigp/beacon-fuzz (MIT License).
#include <Python.h>
#include <filesystem>
#include <optional>
#include <vector>


namespace fuzzing {


class Python {
public:
    explicit Python(const std::filesystem::path &scriptPath, bool bls_disabled = true);

    std::optional<std::vector<uint8_t>> Run(const std::vector<uint8_t> &data);

private:
    PyObject *pFuzzRunOne;
};
} // namespace fuzzing
