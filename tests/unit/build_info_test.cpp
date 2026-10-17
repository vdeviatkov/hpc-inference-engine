#include "hie/build_info.hpp"

#include <string>

#include <gtest/gtest.h>

#include "hie/version.hpp"

namespace hie {
namespace {

TEST(VersionTest, StringMatchesComponents) {
  const std::string expected = std::to_string(kVersionMajor) + "." + std::to_string(kVersionMinor) +
                               "." + std::to_string(kVersionPatch);
  EXPECT_EQ(kVersionString, expected);
}

TEST(BuildInfoTest, FieldsArePopulated) {
  const BuildInfo info = build_info();
  EXPECT_EQ(info.version, kVersionString);
  EXPECT_FALSE(info.compiler.empty());
  EXPECT_FALSE(info.build_type.empty());
  EXPECT_FALSE(info.arch.empty());
}

TEST(BuildInfoTest, ReportsNeonOnArm64) {
  const BuildInfo info = build_info();
  if (info.arch != "arm64") {
    GTEST_SKIP() << "not an arm64 build";
  }
  // NEON is mandatory in AArch64, so every arm64 build must report it.
  EXPECT_NE(info.simd.find("neon"), std::string_view::npos);
}

}  // namespace
}  // namespace hie
