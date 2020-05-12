#include "gtest/gtest.h"
#include <cstring>

#include "go.h"

namespace {

TEST(GoFuzzResult, LoadsArray) {
  const auto *s = "test string";
  auto *t = new unsigned char[44];
  std::memcpy(t, s, 44);

  auto *result = (fuzzing::CxxGoFuzzResult *)LoadGoFuzzResult(t, 44);

  EXPECT_TRUE(result);
  auto inner = result->result;
  EXPECT_TRUE(inner.has_value());
  EXPECT_EQ(inner.value().size(), 44);
  for (int i = 0; i < (int)strlen(s); i++) {
    EXPECT_EQ(s[i], inner.value()[i]);
  }
}

} // namespace
