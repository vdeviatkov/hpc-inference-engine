# 0002. Build system, toolchain, and quality gates

- **Status:** Accepted
- **Date:** 2026-10-17

## Context

The project targets macOS arm64 (primary dev machine, later Metal) and Linux x86_64 (AVX2, CI).
It must be easy to build for others, catch memory and UB bugs early, and keep a consistent style.

## Decision

- **C++20** — `std::span`, concepts, designated initializers, `<bit>`; widely supported by
  AppleClang, Clang and GCC.
- **CMake >= 3.25 + Ninja + `CMakePresets.json`** — the de facto standard for C++; presets give
  one-command reproducible builds (`cmake --workflow --preset debug`).
- **Presets:** `debug`, `release`, `relwithdebinfo` (profiling), `native` (benchmarks only, tuned
  for the host CPU), `asan` (ASan+UBSan), `tsan`, `tidy`.
- **Sanitizers are applied globally** (including GoogleTest) to avoid mixing instrumented and
  uninstrumented code.
- **Strict warnings with `-Werror`** applied per first-party target via `hie_configure_target()`,
  so third-party code is not affected.
- **GoogleTest via FetchContent**, pinned by version. Only test/bench/tooling dependencies are
  allowed; the engine library has none.
- **clang-format and clang-tidy pinned to 18.1.8 via pip** (`requirements-dev.txt`), so local and
  CI results are identical regardless of the system LLVM version.
- **Portable by default:** release builds do not use `-march=native`; host-specific code paths
  will be selected by runtime CPU dispatch (phase 6).

## Consequences

- Contributors need CMake, Ninja, a C++20 compiler and Python (for lint tools).
- CI covers AppleClang, Clang and GCC, with sanitizers on both OSes.
