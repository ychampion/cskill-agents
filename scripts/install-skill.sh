#!/usr/bin/env bash
set -euo pipefail

agent="${1:-}"
slug="${2:-}"
destination="${3:-}"

if [[ -z "$agent" || -z "$slug" ]]; then
  echo "usage: scripts/install-skill.sh <codex|claude-code> <slug> [destination]" >&2
  exit 1
fi

if [[ ! "$slug" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "invalid skill slug: $slug" >&2
  exit 1
fi

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
case "$agent" in
  codex) default_dest="$HOME/.codex/skills" ;;
  claude-code) default_dest="$HOME/.claude/skills" ;;
  *) echo "unsupported agent: $agent" >&2; exit 1 ;;
esac

if [[ -z "$destination" ]]; then
  destination="$default_dest"
fi

source_dir="$repo_root/agents/$agent/skills/$slug"
if [[ ! -d "$source_dir" ]]; then
  echo "skill not found: $slug for $agent" >&2
  exit 1
fi

mkdir -p "$destination"
target_dir="$destination/$slug"
rm -rf "$target_dir"
cp -R "$source_dir" "$target_dir"
echo "installed $slug for $agent into $destination"
