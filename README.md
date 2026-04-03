# cskill-agents

Curated, public-safe agent skills for building and improving coding CLIs, terminal tools, context engines, remote bridges, and multi-agent runtimes.

This repo contains original, method-level skill files distilled from reviewed implementations. It does not ship upstream source code, copied comments, tests, prompts, logos, or proprietary assets.

## Quick Start

Install one skill with the helper scripts. These installers validate the slug and replace any existing installed copy, so they are safe for upgrades and reinstalls.

### Codex-compatible
```powershell
.\scripts\install-skill.ps1 -Agent codex -Slug concurrency-safe-tool-batching
```

```bash
./scripts/install-skill.sh codex concurrency-safe-tool-batching
```

### Claude Code-compatible
```powershell
.\scripts\install-skill.ps1 -Agent claude-code -Slug concurrency-safe-tool-batching
```

```bash
./scripts/install-skill.sh claude-code concurrency-safe-tool-batching
```

Install a curated bundle with the helper script:

```powershell
.\scripts\install-bundle.ps1 -Agent codex -Bundle starter
.\scripts\install-bundle.ps1 -Agent claude-code -Bundle starter
```

```bash
./scripts/install-bundle.sh codex starter
./scripts/install-bundle.sh claude-code starter
```

## What This Repo Is

- A curated distribution repo built from a larger authoring corpus.
- A set of reusable skill files that tell agents how to reproduce strong patterns without copying implementation code.
- A practical install target for Codex-compatible and Claude Code-compatible skill directories.
- A bundle-based catalog of high-value agent-runtime patterns.

## What This Repo Is Not

- Not a source mirror.
- Not a vendor-affiliated SDK, extension pack, or official template set.
- Not a redistribution of third-party code, copied comments, tests, prompts, or internal assets.
- Not the full authoring corpus; this repo only ships a curated public-safe subset.

## Included Skills

- 67 curated skills
- 29 starter skills
- 9 curated bundles

Start with:
- [Starter bundle](catalog/INDEX.md#starter-bundle)
- [Full curated index](catalog/INDEX.md)
- [Machine-readable catalog](catalog/skills.json)

## Supported Agents

- Codex-compatible folder layout in [agents/codex](agents/codex/README.md)
- Claude Code-compatible folder layout in [agents/claude-code](agents/claude-code/README.md)

Compatibility here means the repo uses a skill-folder layout that these agents can consume. It does not imply endorsement, certification, or affiliation.

## Curated Bundles

- `starter`: best first install for most coding agents
- `command-surfaces`: command registries, skill loaders, and capability surfaces
- `tool-orchestration`: batching, streaming, persistence, and output shaping
- `context-management`: compaction, memory, and session control
- `multi-agent`: child-agent isolation, cleanup, and fork control
- `extensions-mcp`: extension lifecycle and parity patterns
- `safety-worktrees`: shell safety, path guards, and worktree handling
- `remote-bridge`: remote-safe command and bridge transport patterns
- `terminal-ui`: terminal presentation and feedback patterns

## Repo Layout

```text
cskill-agents/
  README.md
  LICENSE
  NOTICE
  LEGAL.md
  PROVENANCE.md
  CONTRIBUTING.md
  catalog/
  bundles/
  skills/
  agents/
  scripts/
```

- `skills/`: canonical public universal skills
- `agents/`: direct-install compatible skill folders
- `bundles/`: curated install groups
- `catalog/`: machine-readable and human-readable indexes
- `scripts/`: install helpers and safety checks

## Skill Format

Each public skill contains:
- `SKILL.md`: the reusable method instructions
- `skill.yaml`: sanitized public metadata for catalogs and agents

Public metadata is intentionally coarse. This repo does not publish raw source repo paths or internal mirror paths.

## Public Provenance Model

Public artifacts in this repo use coarse provenance only:
- pattern family
- category
- review status
- bundle membership

Private maintainer evidence can exist outside this repo, but public files should remain abstraction-first and path-safe.

## Legal And Non-Affiliation

Read:
- [LEGAL.md](LEGAL.md)
- [NOTICE](NOTICE)
- [PROVENANCE.md](PROVENANCE.md)

Short version:
- this repo licenses only its original authored materials
- third-party product names are used only for nominative compatibility references
- this repo is not affiliated with, endorsed by, sponsored by, or certified by Anthropic or OpenAI

## Contributing

Before contributing, read [CONTRIBUTING.md](CONTRIBUTING.md).

Public contributions must stay method-level. Do not add:
- source code snippets
- copied comments or tests
- raw internal file paths
- repo mirrors
- proprietary assets

## Removal Requests

If you believe a public artifact in this repo is too close to upstream protected material, open an issue or contact the maintainer. See [LEGAL.md](LEGAL.md) for the review and correction process.
