# Antigravity Terminal Fix

A tiny utility that stops Antigravity from hanging on **"Running command"** by force‑killing stray processes that can block the terminal.

## Why this exists
When a command (e.g. a long‑running Python script) crashes or is left orphaned, Antigravity sometimes fails to receive the process exit event. The UI stays in a perpetual *Running command* state, requiring a manual cancel.

## What the script does
The Windows batch file `fix.bat` simply kills any lingering interpreter processes that are known to cause the stall:
- `python.exe`
- `powershell.exe`
- `conhost.exe`

Running the script before starting a new Antigravity session ensures a clean environment.

## Usage
1. Open a Command Prompt (or PowerShell) with administrator rights.
2. Navigate to the repository root or the folder containing `fix.bat`.
3. Execute:
   ```bat
   fix.bat
   ```
   The script will report which processes were terminated and pause so you can review the output.

## License
MIT © 2026 Antigravity‑Terminal‑Fix contributors
