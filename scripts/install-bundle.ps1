param(
  [Parameter(Mandatory = $true)][string]$Agent,
  [Parameter(Mandatory = $true)][string]$Bundle,
  [string]$Destination
)

$repoRoot = Split-Path -Parent $PSScriptRoot
$listPath = Join-Path $repoRoot "bundles\$Bundle\$Agent.txt"
if (-not (Test-Path $listPath)) {
  throw "Bundle manifest not found: $Bundle for $Agent"
}

Get-Content $listPath | ForEach-Object {
  $relative = $_.Trim()
  if (-not $relative) { return }
  $slug = Split-Path $relative -Leaf
  & (Join-Path $PSScriptRoot 'install-skill.ps1') -Agent $Agent -Slug $slug -Destination $Destination
}
