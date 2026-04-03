#!/usr/bin/env bash
set -euo pipefail

agent="${1:-}"
bundle="${2:-}"
destination="${3:-}"

if [[ -z "$agent" || -z "$bundle" ]]; then
  echo "usage: scripts/install-bundle.sh <codex|claude-code> <bundle> [destination]" >&2
  exit 1
fi

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
list_path="$repo_root/bundles/$bundle/$agent.txt"

if [[ ! -f "$list_path" ]]; then
  echo "bundle manifest not found: $bundle for $agent" >&2
  exit 1
fi

while IFS= read -r relative; do
  [[ -z "$relative" ]] && continue
  slug="$(basename "$relative")"
  "$repo_root/scripts/install-skill.sh" "$agent" "$slug" "$destination"
done < "$list_path"
