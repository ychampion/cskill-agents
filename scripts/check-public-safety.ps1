param(
  [string]$Root = (Split-Path -Parent $PSScriptRoot)
)

$errors = @()
$include = @('*.md', '*.yaml', '*.yml', '*.json')
$exclude = @(
  (Join-Path $Root 'scripts\check-public-safety.ps1'),
  (Join-Path $Root 'scripts\check-public-safety.sh')
)

$files = Get-ChildItem -Path $Root -Recurse -File -Include $include | Where-Object {
  $exclude -notcontains $_.FullName
}

$patterns = @(
  'C:\\Users\\',
  'source_repo:',
  'source_paths:',
  'official-upstream',
  'src/'
)

foreach ($file in $files) {
  $text = Get-Content $file.FullName -Raw
  foreach ($pattern in $patterns) {
    if ($text -match $pattern) {
      $errors += "$($file.FullName): matched [$pattern]"
    }
  }
}

if ($errors.Count -gt 0) {
  $errors | ForEach-Object { Write-Error $_ }
  exit 1
}

Write-Output 'public safety check passed'
