#include "hie/build_info.hpp"

#include "hie/version.hpp"

namespace hie {
namespace {

constexpr std::string_view compiler_name() noexcept {
#if defined(__clang__)
  return "clang " __clang_version__;
#elif defined(__GNUC__)
  return "gcc " __VERSION__;
#elif defined(_MSC_VER)
  return "msvc";
#else
  return "unknown";
#endif
}

constexpr std::string_view arch_name() noexcept {
#if defined(__aarch64__) || defined(_M_ARM64)
  return "arm64";
#elif defined(__x86_64__) || defined(_M_X64)
  return "x86_64";
#else
  return "unknown";
#endif
}

constexpr std::string_view simd_features() noexcept {
  return ""
#if defined(__ARM_NEON)
         "neon "
#endif
#if defined(__ARM_FEATURE_DOTPROD)
         "dotprod "
#endif
#if defined(__ARM_FEATURE_MATMUL_INT8)
         "i8mm "
#endif
#if defined(__ARM_FEATURE_FP16_VECTOR_ARITHMETIC)
         "fp16 "
#endif
#if defined(__SSE4_2__)
         "sse4.2 "
#endif
#if defined(__AVX2__)
         "avx2 "
#endif
#if defined(__FMA__)
         "fma "
#endif
#if defined(__F16C__)
         "f16c "
#endif
#if defined(__AVX512F__)
         "avx512f "
#endif
#if defined(__AVXVNNI__)
         "avxvnni "
#endif
      ;
}

}  // namespace

BuildInfo build_info() noexcept {
  return BuildInfo{
      .version = kVersionString,
      .compiler = compiler_name(),
      .build_type = HIE_BUILD_TYPE,
      .arch = arch_name(),
      .simd = simd_features(),
  };
}

}  // namespace hie
