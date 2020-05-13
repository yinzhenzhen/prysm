#include <optional>
#include <string>
#include <vector>

#include "go.h"

namespace fuzzing {

class GoFuzzResultImpl : CxxGoFuzzResult {
public:
  void LoadResult(unsigned char *data, size_t size) override {
    result = std::make_optional<std::vector<uint8_t>>(size);

    for (int i = 0; i < (int)size; i++) {
      result.value()[i] = (uint8_t)data[i];
    }
  }
};

} // namespace fuzzing

void *LoadGoFuzzResult(unsigned char *data, size_t size) {
  auto *res = new fuzzing::GoFuzzResultImpl();
  res->LoadResult(data, size);
  return (void *)res;
}
