param(
  [Parameter(Mandatory = $true)][string]$Agent,
  [Parameter(Mandatory = $true)][string]$Slug,
  [string]$Destination
)

$repoRoot = Split-Path -Parent $PSScriptRoot
$defaults = @{
  'codex' = Join-Path $HOME '.codex\skills'
  'claude-code' = Join-Path $HOME '.claude\skills'
}

if (-not $defaults.ContainsKey($Agent)) {
  throw "Unsupported agent: $Agent"
}

if ($Slug -notmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') {
  throw "Invalid skill slug: $Slug"
}

if (-not $Destination) {
  $Destination = $defaults[$Agent]
}

$source = Join-Path $repoRoot "agents\$Agent\skills\$Slug"
if (-not (Test-Path $source -PathType Container)) {
  throw "Skill not found: $Slug for $Agent"
}

New-Item -ItemType Directory -Force $Destination | Out-Null
$target = Join-Path $Destination $Slug
if (Test-Path $target) {
  Remove-Item -Recurse -Force $target
}
Copy-Item -Recurse -Force $source $target
Write-Output "Installed $Slug for $Agent into $Destination"
