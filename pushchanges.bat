@echo off
SETLOCAL enabledelayedexpansion

REM --- 1. Pull ---
git pull --ff-only || GOTO :fail

REM --- 2. Stage everything ---
git add -A        || GOTO :fail

REM --- 3. Commit (prompt if empty) ---
IF "%~1"=="" (
    SET /P MSG=Enter commit message: 
) ELSE (
    SET MSG=%*
)
git commit -m "!MSG!" || GOTO :fail

REM --- 4. Push ---
git push || GOTO :fail

ECHO.
ECHO ✅  Done!
PAUSE
GOTO :eof

:fail
ECHO.
ECHO ❌  Something went wrong.  Check the messages above.
PAUSE
EXIT /B 1
