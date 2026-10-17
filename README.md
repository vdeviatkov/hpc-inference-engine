# hpc-inference-engine

A from-scratch, architecture-agnostic LLM inference engine in modern C++ — in the spirit of
[llama.cpp](https://github.com/ggml-org/llama.cpp), built to be read, measured, and understood.

> **Status: Phase 0 (foundation).** Nothing runs a model yet. See the [roadmap](docs/ROADMAP.md).

## Goals

- **Correct:** every op and layer is validated against a PyTorch reference.
- **Fast:** hand-written SIMD (NEON, AVX2) and Metal kernels, quantized inference, measured
  against the memory-bandwidth roofline and benchmarked against llama.cpp.
- **General:** models are computation graphs built from a shared op library; adding an
  architecture is one builder file plus a golden test.
- **Dependency-free core:** no BLAS, no ggml — everything from scratch.

## Building

Requirements: CMake ≥ 3.25, Ninja, a C++20 compiler (AppleClang 15+, Clang 17+, GCC 13+).

```sh
cmake --workflow --preset release      # configure, build, test
./build/release/tools/cli/hie --version
```

Other presets: `debug`, `relwithdebinfo`, `native`, `asan`, `tsan`, `tidy` (see
[CMakePresets.json](CMakePresets.json)).

## Development

```sh
python3 -m venv .venv && .venv/bin/pip install -r requirements-dev.txt  # pinned clang-format/tidy
scripts/format.sh                                                        # format sources
cmake --workflow --preset asan                                           # sanitizer build + tests
export PATH="$PWD/.venv/bin:$PATH"
cmake --preset tidy && cmake --build --preset tidy                       # clang-tidy
```

Design decisions are recorded in [docs/adr](docs/adr).

## Model coverage

| Architecture | CPU | Metal | Quantizations | Golden test |
|---|---|---|---|---|
| _coming in phase 4_ | | | | |

## Benchmarks

_Coming in phase 6._

## License

[MIT](LICENSE)
