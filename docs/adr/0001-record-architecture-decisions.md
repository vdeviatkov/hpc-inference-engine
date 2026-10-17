# 0001. Record architecture decisions

- **Status:** Accepted
- **Date:** 2026-10-17

## Context

An inference engine involves many non-obvious trade-offs (memory layout, quantization formats,
graph design, threading model). The reasoning behind them is as valuable as the code, and is
lost if it lives only in commit messages or chat history.

## Decision

Significant decisions are recorded as Architecture Decision Records in `docs/adr/`, numbered
sequentially, using `0000-template.md`. ADRs are immutable once accepted; a changed decision gets
a new ADR that supersedes the old one.

## Consequences

- Reviewers (and future me) can see why the code looks the way it does.
- Small overhead per decision; reserved for choices that are costly to reverse.
