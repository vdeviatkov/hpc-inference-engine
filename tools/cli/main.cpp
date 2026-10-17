#include <cstdio>
#include <span>
#include <string_view>

#include "hie/build_info.hpp"

namespace {

void print_usage() {
  std::puts(
      "usage: hie [options]\n"
      "\n"
      "options:\n"
      "  -h, --help       show this help and exit\n"
      "  -v, --version    show version and build information and exit");
}

void print_version() {
  const hie::BuildInfo info = hie::build_info();
  std::printf("hie %.*s\n", static_cast<int>(info.version.size()), info.version.data());
  std::printf("  compiler:   %.*s\n", static_cast<int>(info.compiler.size()), info.compiler.data());
  std::printf("  build type: %.*s\n", static_cast<int>(info.build_type.size()),
              info.build_type.data());
  std::printf("  arch:       %.*s\n", static_cast<int>(info.arch.size()), info.arch.data());
  std::printf("  simd:       %.*s\n", static_cast<int>(info.simd.size()), info.simd.data());
}

}  // namespace

int main(int argc, char** argv) {
  const std::span<char*> args(argv, static_cast<std::size_t>(argc));

  for (const std::string_view arg : args.subspan(1)) {
    if (arg == "-h" || arg == "--help") {
      print_usage();
      return 0;
    }
    if (arg == "-v" || arg == "--version") {
      print_version();
      return 0;
    }
    std::fprintf(stderr, "hie: unknown option '%.*s'\n\n", static_cast<int>(arg.size()),
                 arg.data());
    print_usage();
    return 2;
  }

  print_usage();
  return 0;
}
