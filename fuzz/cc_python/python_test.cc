#include "gtest/gtest.h"

#include "python.h"

namespace {

TEST(Python, CanCallSpecMethod) {
    auto p = new fuzzing::Python("prysm/fuzz/cc_python/python_example.py", true /*blsDisabled*/);

    auto input = std::vector<uint8_t>{0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
    auto res = p->Run(input);

    ASSERT_EQ(res->size(), 32); // hash returns a 32byte result.
}

} // namespace
