# Codex-Compatible Skills

Run these commands from the repo root.

Install a single skill:

```powershell
.\scripts\install-skill.ps1 -Agent codex -Slug concurrency-safe-tool-batching
```

```bash
./scripts/install-skill.sh codex concurrency-safe-tool-batching
```

Or install a bundle:

```powershell
.\scripts\install-bundle.ps1 -Agent codex -Bundle starter
```

```bash
./scripts/install-bundle.sh codex starter
```

These folders are a compatible install layout for Codex-style skill directories. They are not official OpenAI distributions.
