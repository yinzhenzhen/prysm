


#include <cstdint>
#include <cstddef>
#include <vector>

namespace fuzzing {
    /**
     * Convert a C style array to vector.
     *
     * @param data Input array.
     * @param size Size of input array.
     * @return A vector copy of the input array data.
     */
    std::vector<uint8_t> Convert(const char* data, size_t size);
}