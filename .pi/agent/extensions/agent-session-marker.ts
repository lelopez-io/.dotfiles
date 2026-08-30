// agent-session-marker — stamp each pi session with its launch profile, so
// resumes replay it instead of the resuming shell's cwd (agent-session-mark).
// Beside herdr-agent-state.ts, not inside: herdr overwrites that file on
// every `herdr integration install`.
// @ts-nocheck

import { spawn } from "node:child_process";

const MARK = `${process.env.HOME}/.local/bin/agent-session-mark`;

// Key on the id embedded in the session filename, derived exactly as the pi
// shim derives it from `--session <path>`: the two must match for the lookup
// to hit.
function sessionKey(ctx: any): string | undefined {
  try {
    const file = ctx?.sessionManager?.getSessionFile?.();
    if (typeof file === "string" && file.length > 0) {
      const base = file.split("/").pop().replace(/\.jsonl$/, "");
      return base.split("_").pop() || undefined;
    }
  } catch {
    /* fall through to the id */
  }
  try {
    const id = ctx?.sessionManager?.getSessionId?.();
    return typeof id === "string" && id.length > 0 ? id : undefined;
  } catch {
    return undefined;
  }
}

export default function (pi) {
  pi.on("session_start", (_event, ctx) => {
    const key = sessionKey(ctx);
    if (!key) {
      return;
    }
    try {
      // Detached and ignored: a marker is bookkeeping, never a startup gate.
      spawn(MARK, [key], { stdio: "ignore", detached: true }).unref();
    } catch {
      /* a missing marker only costs cwd-based resolution on resume */
    }
  });
}
