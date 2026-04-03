#!/usr/bin/env bash
set -euo pipefail

root="${1:-$(cd "$(dirname "$0")/.." && pwd)}"

mapfile -t files < <(find "$root" -type f \( -name '*.md' -o -name '*.yaml' -o -name '*.yml' -o -name '*.json' \) \
  ! -path "$root/scripts/check-public-safety.ps1" \
  ! -path "$root/scripts/check-public-safety.sh")

patterns=('C:\\Users\\' 'source_repo:' 'source_paths:' 'official-upstream' 'src/')

failed=0
for file in "${files[@]}"; do
  for pattern in "${patterns[@]}"; do
    if grep -qE "$pattern" "$file"; then
      echo "$file: matched [$pattern]" >&2
      failed=1
    fi
  done
done

if [[ "$failed" -ne 0 ]]; then
  exit 1
fi

echo "public safety check passed"
