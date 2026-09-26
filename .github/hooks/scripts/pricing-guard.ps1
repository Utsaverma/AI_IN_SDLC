$ErrorActionPreference = "Stop"

$inputObj = [Console]::In.ReadToEnd() | ConvertFrom-Json

$toolName = $inputObj.toolName
$toolArgsRaw = $inputObj.toolArgs

# We only care about write-related operations.
if ($toolName -notin @("create", "edit", "apply_patch")) {
    exit 0
}

# Parse tool arguments.
try {
    $toolArgs = $toolArgsRaw | ConvertFrom-Json
}
catch {
    exit 0
}

# Try common file-path argument names.
$filePath = $toolArgs.path

if (-not $filePath) {
    $filePath = $toolArgs.file_path
}

if (-not $filePath) {
    $filePath = $toolArgs.filePath
}

if (-not $filePath) {
    $filePath = $toolArgs.filename
}

# ------------------------------------------------------------
# RULE 1: Block production configuration changes
# ------------------------------------------------------------

if ($filePath -match '(^|[\\/])(prod|production)([\\/]|\.|$)') {

    @{
        permissionDecision = "deny"
        permissionDecisionReason =
            "Pricing Guard: direct modification of production configuration is blocked during this workshop."
    } | ConvertTo-Json -Compress

    exit 0
}

# ------------------------------------------------------------
# RULE 2: Pricing implementation requires approved specification
# ------------------------------------------------------------

if ($filePath -match 'src[\\/].*pricing|src[\\/]pricing|pricing_engine|pricing_rules') {

    $specPath = Join-Path (Get-Location) "..\..\..\specs\smart-pricing\spec.md"

    if (-not (Test-Path $specPath)) {

        @{
            permissionDecision = "deny"
            permissionDecisionReason =
                "Pricing Guard: pricing implementation cannot be modified because the approved specification is missing. Create/approve specs/smart-pricing/spec.md first."
        } | ConvertTo-Json -Compress

        exit 0
    }
}

# ------------------------------------------------------------
# ALLOW
# ------------------------------------------------------------

exit 0