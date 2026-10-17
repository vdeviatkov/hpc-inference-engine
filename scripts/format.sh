#!/usr/bin/env bash
# Format all first-party C++ sources in place, or verify formatting with --check.
#
#   scripts/format.sh          # rewrite files
#   scripts/format.sh --check  # exit non-zero if any file needs formatting
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${repo_root}"

# Prefer the pinned version from the project venv (see requirements-dev.txt).
clang_format="${CLANG_FORMAT:-}"
if [[ -z "${clang_format}" ]]; then
  if [[ -x .venv/bin/clang-format ]]; then
    clang_format=.venv/bin/clang-format
  else
    clang_format=clang-format
  fi
fi

expected_major=18
actual_major="$("${clang_format}" --version | sed -E 's/.*version ([0-9]+).*/\1/')"
if [[ "${actual_major}" != "${expected_major}" ]]; then
  echo "warning: ${clang_format} is version ${actual_major}, CI uses ${expected_major};" \
    "results may differ (pip install -r requirements-dev.txt)" >&2
fi

files=()
while IFS= read -r -d '' file; do
  files+=("${file}")
done < <(git ls-files -z --cached --others --exclude-standard \
  -- '*.cpp' '*.hpp' '*.h' '*.cc')

if [[ ${#files[@]} -eq 0 ]]; then
  exit 0
fi

if [[ "${1:-}" == "--check" ]]; then
  "${clang_format}" --dry-run --Werror "${files[@]}"
  echo "formatting OK (${#files[@]} files)"
else
  "${clang_format}" -i "${files[@]}"
fi
