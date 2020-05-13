
#include "convert.h"

namespace fuzzing {
    std::vector<uint8_t> Convert(const char *data, size_t size) {
        if (!data) {
            return std::vector<uint8_t>(0);
        }
        auto v = std::vector<uint8_t>(size);
        for (auto i = 0; i < (int)size; i ++) {
            v[i] = data[i];
        }
        return v;
    }
}