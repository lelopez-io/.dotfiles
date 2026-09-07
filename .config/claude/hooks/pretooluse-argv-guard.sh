#!/bin/sh
# PreToolUse adapter for agent-argv-guard. Claude Code pipes the tool call as
# JSON on stdin; exit 2 blocks and stderr reaches the model, exit 0 allows.
# Credential reads are permissions.deny entries, so this hook never sees them.

command -v jq >/dev/null 2>&1 || exit 0   # fail open if jq is absent
guard="$HOME/.local/bin/agent-argv-guard"
[ -x "$guard" ] || exit 0                  # fail open if the guard is not stowed

input=$(cat)
field() { printf '%s' "$input" | jq -r "$1 // empty"; }

# The payload reaches the guard on stdin so the command never lands in a
# child's argv, the channel the guard exists to keep clean.
case $(field .tool_name) in
    Bash)
        payload=$(field .tool_input.command)
        set -- ;;
    Write | Edit)
        # Write carries .content, Edit carries .new_string.
        payload=$(field '.tool_input.content // .tool_input.new_string')
        set -- --config "$(field .tool_input.file_path)" ;;
    *) exit 0 ;;
esac

reason=$(printf '%s' "$payload" | "$guard" "$@"); status=$?
# Only exit 1 is a refusal. Any other status means the guard itself broke, and
# a broken guard must not wedge every shell in the fleet.
[ "$status" -eq 1 ] || exit 0
printf 'argv-guard: %s\n' "$reason" >&2
exit 2
