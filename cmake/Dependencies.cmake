# Third-party dependencies. Policy (see docs/adr/0002-build-system-and-toolchain.md):
# only test/benchmark/tooling dependencies are allowed; the engine itself has none.
include(FetchContent)

FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/refs/tags/v1.15.2.tar.gz
  DOWNLOAD_EXTRACT_TIMESTAMP TRUE)

# Use the same CRT as the parent project on Windows and keep GoogleTest out of
# install rules.
set(gtest_force_shared_crt
    ON
    CACHE BOOL "" FORCE)
set(INSTALL_GTEST
    OFF
    CACHE BOOL "" FORCE)
set(BUILD_GMOCK
    OFF
    CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(googletest)
