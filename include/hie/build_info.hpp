#pragma once

#include <string_view>

namespace hie {

/// Compile-time facts about how the library was built. Recorded alongside every
/// benchmark result so numbers are reproducible and comparable.
struct BuildInfo {
  std::string_view version;
  std::string_view compiler;
  std::string_view build_type;
  std::string_view arch;
  std::string_view simd;  ///< Space-separated SIMD extensions enabled at compile time.
};

[[nodiscard]] BuildInfo build_info() noexcept;

}  // namespace hie
