# Antigravity Terminal Fix

---

## English

### Description
Workaround for Antigravity terminal hang bug where commands complete but remain listed as "running".

### Problem
There is a known Antigravity platform bug: `run_command` finishes successfully, but Antigravity does not register the completion. As a result:
1. `command_status` reports the command as "running" indefinitely.
2. The command stays in the background process list as a zombie.
3. Accumulated zombie processes may prevent new commands from starting.

This is **not** an issue with the user's environment; it is a platform‑side state synchronization problem.

### Workaround (Watchdog)
We provide a simple script that automatically detects when Antigravity is stuck (window title contains *Running command* for more than 30 seconds) and runs `fix.bat` to kill stray processes (`python.exe`, `powershell.exe`, `conhost.exe`).

#### How it works
1. **watchdog.ps1** – a PowerShell script that checks the Antigravity window title every 5 seconds. If the title remains *Running command* for over 30 seconds, the script automatically executes `fix.bat`.
2. **fix.bat** – a Windows batch file that force‑kills interpreter processes that may be left hanging.

#### Usage
```powershell
# Navigate to the repository root
cd <path_to_repository>

# Start the watchdog (you can keep this window open)
powershell -ExecutionPolicy Bypass -File .\watchdog.ps1
```
The watchdog runs in the background and will automatically clean up hangs.

### Alternative workaround via `read_terminal`
If `command_status` is stuck, you can bypass it by reading the terminal buffer directly.

#### Steps
1. Ask the user for the terminal PID (e.g., `echo $$` inside the terminal).
2. Run:
   ```
   read_terminal(Name="terminal-<PID>", ProcessID="<PID>")
   ```
   This returns the full scroll‑back buffer, including the completed command output.
3. Parse the output and continue without waiting for `command_status`.

### Recovery
After closing stuck background tasks (the ✕ button in the UI), subsequent commands work normally. Restart the watchdog if needed.

### License
MIT © 2026 Antigravity‑Terminal‑Fix contributors

---

## Русский

### Описание
Обходной путь для проблемы зависания терминала Antigravity, когда команды завершаются, но остаются в списке «running».

### Проблема
Существует известный баг платформы Antigravity: `run_command` успешно завершается, однако Antigravity не фиксирует завершение. В результате:
1. `command_status` бесконечно сообщает, что команда «running».
2. Команда остаётся в списке фоновых процессов как зомби.
3. При накоплении зомби‑процессов новые команды могут не запускаться.

Это **не** ошибка пользовательского окружения, а проблема синхронизации состояния на стороне платформы.

### Обходной путь (Watchdog)
Мы предоставляем простой скрипт, который автоматически обнаруживает, что Antigravity «застрял» (заголовок окна содержит *Running command* более 30 сек) и запускает `fix.bat`, убивая зависшие процессы (`python.exe`, `powershell.exe`, `conhost.exe`).

#### Как это работает
1. **watchdog.ps1** – PowerShell‑скрипт, проверяющий заголовок окна Antigravity каждые 5 сек. Если заголовок остаётся *Running command* более 30 сек, скрипт автоматически вызывает `fix.bat`.
2. **fix.bat** – Windows‑батник, принудительно завершающий процессы‑интерпретаторы, оставшиеся висящими после сбоя.

#### Запуск
```powershell
# Перейдите в корень репозитория
cd <путь_к_репозиторию>

# Запустите наблюдатель (можно оставить открытым в отдельном окне)
powershell -ExecutionPolicy Bypass -File .\watchdog.ps1
```
Скрипт будет работать в фоне и автоматически исправлять зависания.

### Обходной путь через `read_terminal`
Если `command_status` застревает, можно обойти его, читая буфер терминала напрямую.

#### Шаги
1. Попросите пользователя указать PID терминала (например, `echo $$` внутри терминала).
2. Выполните:
   ```
   read_terminal(Name="terminal-<PID>", ProcessID="<PID>")
   ```
   Это вернёт полный скролл‑бэк терминала, включая вывод завершившейся команды.
3. Обработайте полученный вывод и продолжайте работу, не ожидая `command_status`.

### Восстановление
После закрытия зависших фоновых задач (кнопка ✕ в UI) последующие команды работают нормально. При необходимости просто запустите `watchdog.ps1` снова.

### Лицензия
MIT © 2026 Antigravity‑Terminal‑Fix contributors

---
