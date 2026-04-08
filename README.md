# Antigravity Terminal Fix

This repository provides a small utility script that resolves the issue where the Antigravity terminal gets stuck on **"Running command"** and never completes.

## Problem
When running commands (especially long‑running Python scripts) inside Antigravity, the terminal sometimes fails to capture the process exit, leaving the UI in a perpetual *Running command* state. This is typically caused by the child process not being properly terminated or its output streams not being flushed.

## Solution
The provided `fix_terminal.py` script launches a subprocess with:
- **`stdout`/`stderr`** captured and flushed in real‑time.
- **`preexec_fn=os.setsid`** (Unix) or **`creationflags=subprocess.CREATE_NEW_PROCESS_GROUP`** (Windows) to isolate the child process.
- A **graceful termination** handler that sends a termination signal on user interrupt (Ctrl‑C) and ensures the process is killed if it hangs.

By using this wrapper, Antigravity receives proper exit codes and output, allowing the UI to return to the idle state.

## Usage
```bash
python fix_terminal.py <your‑command> [args...]
```
Example:
```bash
python fix_terminal.py python my_script.py
```

The script will stream the command’s output to the console and guarantee that the process is cleaned up, preventing the *Running command* stall.

## License
MIT © 2026 Antigravity‑Terminal‑Fix contributors
