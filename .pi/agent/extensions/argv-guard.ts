// argv-guard — pipe every guarded tool call to agent-argv-guard (the same
// detector the claude PreToolUse hook uses) and block when it refuses.
// @ts-nocheck

import { spawnSync } from "node:child_process";

const GUARD = `${process.env.HOME}/.local/bin/agent-argv-guard`;

// pi has no declarative read-deny, and grep/find/ls reach a file without ever
// becoming a read, so every tool that takes a path routes through --read.
const PATH_TOOLS = ["read", "grep", "find", "ls"];

export default function (pi) {
  pi.on("tool_call", (event) => {
    try {
      const input = event.input ?? {};
      let argv: string[] | undefined;
      if (event.toolName === "bash") argv = [input.command ?? ""];
      else if (PATH_TOOLS.includes(event.toolName))
        argv = ["--read", input.path ?? ""];
      else if (event.toolName === "write")
        argv = ["--config", input.path ?? "", input.content ?? ""];
      else if (event.toolName === "edit")
        argv = [
          "--config",
          input.path ?? "",
          (input.edits ?? []).map((e: any) => e.newText).join("\n"),
        ];
      if (!argv) return;
      const r = spawnSync(GUARD, argv, { encoding: "utf8" });
      // Only exit 1 is a refusal; any other status is a broken guard, which
      // must not wedge the agent.
      if (r.status === 1) {
        const reason = (r.stdout || "blocked").toString().trim();
        return { block: true, reason: `argv-guard: ${reason}` };
      }
    } catch {
      /* a broken guard must not wedge the agent: fail open */
    }
  });
}
