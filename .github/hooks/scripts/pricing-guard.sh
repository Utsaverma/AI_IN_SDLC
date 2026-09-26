#!/bin/bash
set -euo pipefail

INPUT="$(cat)"

TOOL_NAME="$(echo "$INPUT" | jq -r '.toolName // empty')"
TOOL_ARGS_RAW="$(echo "$INPUT" | jq -r '.toolArgs // empty')"

# We only care about write-related operations.
case "$TOOL_NAME" in
  create|edit|apply_patch)
    ;;
  *)
    exit 0
    ;;
esac

# toolArgs is a JSON string in Copilot CLI hook input.
if ! echo "$TOOL_ARGS_RAW" | jq -e . >/dev/null 2>&1; then
  exit 0
fi

# Try to extract a file path from common tool argument names.
FILE_PATH="$(
  echo "$TOOL_ARGS_RAW" |
  jq -r '
    .path //
    .file_path //
    .filePath //
    .filename //
    empty
  '
)"

# ------------------------------------------------------------
# RULE 1: Never allow the agent to directly modify production config
# ------------------------------------------------------------

if echo "$FILE_PATH" | grep -qiE '(^|/)(prod|production)(/|\.|$)'; then
  jq -n \
    --arg reason \
    "Pricing Guard: direct modification of production configuration is blocked during this workshop." \
    '{
      permissionDecision: "deny",
      permissionDecisionReason: $reason
    }'

  exit 0
fi

# ------------------------------------------------------------
# RULE 2: Pricing code requires the approved specification
# ------------------------------------------------------------

if echo "$FILE_PATH" | grep -qiE 'src/.*/pricing|src/pricing|pricing_engine|pricing_rules'; then

  if [ ! -f "../../../specs/smart-pricing/spec.md" ]; then
    jq -n \
      --arg reason \
      "Pricing Guard: pricing implementation cannot be modified because the approved specification is missing. Create/approve specs/smart-pricing/spec.md first." \
      '{
        permissionDecision: "deny",
        permissionDecisionReason: $reason
      }'

    exit 0
  fi
fi

# ------------------------------------------------------------
# ALLOW
# ------------------------------------------------------------

exit 0