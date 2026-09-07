# Rules for agent shells

## Move secrets by pipe, never by argv or env

- Never put a secret in a command argument, an environment variable, or
  shell history.
- Use stdin or process substitution with a reference:
  `tool --token-stdin <(op read "op://vault/item/field")`.
- `$(...)` in an argument expands the value into argv. Use `<(...)`.
- zsh `=(...)` writes a temp file under /tmp. Use `<(...)`, which is
  pipe-backed.
- Do not copy credential files (`cp`, `mv`, `scp`, `rsync`, `tee`).
  Reference them in place with `<(...)`.
- Do not dump process environments (`ps eww`). Query the one variable.

## Never print a credential to the transcript

Do not run bare `op read`, `op item get --reveal`, `gh auth token`,
`security find-generic-password -w`, or read credential files (`~/.netrc`,
`~/.config/op/`, `~/.aws/credentials`, `~/.ssh/id_*`,
`~/.claude/.credentials.json`, `~/.config/gh/hosts.yml`). Capture in a
variable, redirect to a file, or ask the user to run it.

## SSH between machines

- Do not set `ForwardAgent`.
- No port forwards or tunnels (`ssh -L`, `-R`, `-D`).

## When the guard blocks

agent-argv-guard (PreToolUse in claude, tool_call in pi) refuses the shapes
above. Rewrite with stdin or a `<(reference)`. If a block is wrong, say so
rather than routing around it silently.
