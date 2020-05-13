#include "gtest/gtest.h"
#include <cstring>

#include "differential.h"
#include "runnable.h"

namespace {

class TestModule : public fuzzing::Runnable {
public:
  TestModule(std::string name, std::vector<uint8_t> result) {
    name_ = name;
    result_ = result;
  }

  std::optional<std::vector<uint8_t>>
  Run(const std::vector<uint8_t> &data) override {
    return result_;
  }

  const std::string &name() override { return name_; }

private:
  std::vector<uint8_t> result_;
  std::string name_;
};

TEST(Differential, PassesSameResults) {
  auto differential = new fuzzing::Differential();

  auto a = std::vector<uint8_t>{0, 1, 2};
  differential->AddModule(std::make_shared<TestModule>("A", a));
  differential->AddModule(std::make_shared<TestModule>("B", a));

  ASSERT_NO_THROW(differential->Run(std::vector<uint8_t>(0)));
}

TEST(Differential, FailsDifferentResults) {
  auto differential = new fuzzing::Differential();

  auto a = std::vector<uint8_t>{0, 1, 2};
  auto b = std::vector<uint8_t>{3, 4, 5};
  differential->AddModule(std::make_shared<TestModule>("A", a));
  differential->AddModule(std::make_shared<TestModule>("B", b));

  ASSERT_ANY_THROW(differential->Run(std::vector<uint8_t>(0)));
}

} // namespace
