#include "gtest/gtest.h"
#include <cstring>

#include "convert.h"

namespace {

TEST(Convert, CArrayToVector) {
    const auto *s = "test string";
    auto *t = new char[44];
    std::memcpy(t, s, 44);

    auto result = fuzzing::Convert(t, 44);
    EXPECT_EQ(result.size(), 44);
    for (int i = 0; i < (int)strlen(s); i++) {
        EXPECT_EQ(s[i], result[i]);
    }
}


TEST(Convert, NullPtr) {
    ASSERT_NO_FATAL_FAILURE(fuzzing::Convert(nullptr, 1));
}


} // namespace
