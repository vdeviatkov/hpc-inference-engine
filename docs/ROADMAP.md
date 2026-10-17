# Roadmap

Each phase has explicit exit criteria. A phase is done only when its criteria pass in CI.

| Phase | Deliverable | Exit criteria |
|---|---|---|
| **0. Foundation** | CMake presets, strict warnings, sanitizers, GoogleTest, clang-format/tidy, CI (macOS arm64 + Linux x86_64), ADRs | CI green on all jobs, including `asan` and lint |
| **1. Reference harness** | Python script (PyTorch/HF) that dumps per-layer activations + logits for fixed prompts | Golden files for a tiny model checked in (or fetched reproducibly) |
| **2. Tensor core** | Tensor views (shape/strides/dtype), aligned arena allocator, mmap loading | Unit tests; zero-copy weight load verified |
| **3. Loading** | GGUF parser (from spec), configurable tokenizer (byte-level BPE + SentencePiece-style, per-model pre-tokenizer regex), Jinja-subset chat template engine | Token IDs match HF `tokenizers` exactly on a test corpus; templates match reference renders |
| **4. Naive FP32 Llama** | Hand-written scalar forward pass: RMSNorm, RoPE, GQA attention, SwiGLU | Per-layer diff vs reference < 1e-4; greedy decode matches token-for-token |
| **4.5. Graph + registry** | Op library, computation graph, static memory planner, architecture registry keyed on `general.architecture`; port Llama, then Tier 1 | All Tier 1 golden tests pass through the graph path |
| **5. Generation** | Model-memory interface (KV cache, sliding-window ring buffer), prefill vs decode, samplers, streaming CLI | Interactive chat; seeded sampling reproducible |
| **6. CPU performance** | Profiling, blocked GEMM/GEMV, NEON/AVX2, thread pool, op fusion, roofline analysis | Decode tok/s reported as % of memory-bandwidth roofline; before/after per optimization |
| **7. Quantization** | Q8_0, Q4_0, Q4_K; int8 dot kernels (`sdot`, VNNI) | WikiText-2 perplexity within tolerance of llama.cpp; speedups reported |
| **7.5. Mixture of experts** | Router, grouped expert GEMM, shared experts, MLA attention | Tier 2 golden tests pass |
| **8. GPU backend** | Backend interface + Metal kernels executing the same graphs | Golden tests pass on Metal; benchmark table |
| **9. Serving** | Batched prefill, paged KV cache, continuous batching, OpenAI-compatible server; speculative decoding (stretch) | Throughput/latency curves under concurrent load |
| **9.5. SSM / hybrid** | Selective-scan ops, recurrent state memory, hybrid layer stacks | Tier 3 golden tests pass |
| **10. Polish** | Benchmarks vs llama.cpp, coverage matrix, architecture diagram, "adding an architecture" guide, release | A stranger can clone, build, and run a model in < 5 minutes |

## Model coverage tiers

| Tier | Families | New machinery |
|---|---|---|
| 1 — dense | Llama 2/3.x, Mistral, Qwen2.5/3, SmolLM2, Phi-3/4, Granite, OLMo2, Gemma 2/3 | Norm/RoPE/attention/FFN variants, sliding window, soft-capping |
| 2 — MoE | Mixtral, OLMoE, Qwen3-MoE, DeepSeek-V2-Lite, gpt-oss | Routing, grouped GEMM, MLA, attention sinks, MXFP4 |
| 3 — SSM / hybrid | Mamba2, RWKV, Jamba / Granite-4-style hybrids | Scan ops, recurrent state memory |
| 4 — multimodal | Gemma 3, Qwen2.5-VL vision | Vision encoders, projector, image preprocessing |

Each family is validated on its smallest public checkpoint.
