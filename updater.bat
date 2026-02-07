@echo off
setlocal EnableDelayedExpansion

set /a updated=0
set /a up_to_date=0
set /a non_git=0
set "tempfile=%temp%\vencord_git_temp.txt"

echo.
set /p "INPUT=Enter path (e.g. D:\Vencord): "

if not defined INPUT (
    echo.
    echo Cancelled: No path entered.
    echo.
    pause
    exit /b 1
)

set "INPUT=%INPUT:"=%"
set "INPUT=%INPUT:/=\%"
if "%INPUT:~-1%"=="\" set "INPUT=%INPUT:~0,-1%"

set "IS_DRIVE="
if "%INPUT:~1,1%"==":" (
    set "tmp=%INPUT:~2%"
    if "!tmp!"=="" set "IS_DRIVE=yes"
    if "!tmp!"=="\" set "IS_DRIVE=yes"
)

if defined IS_DRIVE (
    set "DRIVE=%INPUT%"
    if "!DRIVE:~-1!" neq "\" set "DRIVE=!DRIVE!\"
    echo Searching for Vencord folder on !DRIVE!...
    set "VENCORD_DIR="
    for /f "delims=" %%V in ('dir "!DRIVE!" /ad /s /b ^| findstr /i /e "\\Vencord" 2^>nul') do (
        if not defined VENCORD_DIR set "VENCORD_DIR=%%V"
    )
    if not defined VENCORD_DIR (
        echo.
        echo Error: No Vencord folder found on !DRIVE!
        echo.
        pause
        exit /b 1
    )
    echo Found Vencord at: !VENCORD_DIR!
    set "USERPLUGINS_DIR=!VENCORD_DIR!\src\userplugins"
) else (
    if not exist "%INPUT%\" (
        echo.
        echo Error: Path does not exist: %INPUT%
        echo.
        pause
        exit /b 1
    )
    set "PROVIDED=%INPUT%"
    set "USERPLUGINS_DIR="
    set "END12=!PROVIDED:~-12!"
    if /i "!END12!"=="\userplugins" set "USERPLUGINS_DIR=!PROVIDED!"
    set "END11=!PROVIDED:~-11!"
    if not defined USERPLUGINS_DIR if /i "!END11!"=="userplugins" set "USERPLUGINS_DIR=!PROVIDED!"
    set "END4=!PROVIDED:~-4!"
    if not defined USERPLUGINS_DIR if /i "!END4!"=="\src" set "USERPLUGINS_DIR=!PROVIDED!\userplugins"
    set "END3=!PROVIDED:~-3!"
    if not defined USERPLUGINS_DIR if /i "!END3!"=="src" set "USERPLUGINS_DIR=!PROVIDED!\userplugins"
    set "END8=!PROVIDED:~-8!"
    if not defined USERPLUGINS_DIR if /i "!END8!"=="\vencord" set "USERPLUGINS_DIR=!PROVIDED!\src\userplugins"
    set "END7=!PROVIDED:~-7!"
    if not defined USERPLUGINS_DIR if /i "!END7!"=="vencord" set "USERPLUGINS_DIR=!PROVIDED!\src\userplugins"
    if not defined USERPLUGINS_DIR (
        echo.
        echo Error: Path does not point to Vencord, src, or userplugins.
        echo Try a closer or exact path.
        echo.
        pause
        exit /b 1
    )
)

if not exist "%USERPLUGINS_DIR%\" (
    echo.
    echo Error: userplugins folder not found.
    echo Expected: %USERPLUGINS_DIR%
    echo.
    pause
    exit /b 1
)

echo.
echo Using userplugins folder: %USERPLUGINS_DIR%
echo.
echo Updating plugins...
echo.

pushd "%USERPLUGINS_DIR%" >nul

for /d %%F in (*) do (
    echo ------------------------------------------------------------------
    echo Checking: %%F
    if exist "%%F\.git" (
        git -C "%%F" pull > "%tempfile%" 2>&1
        type "%tempfile%"
        find /i "Already up to date" "%tempfile%" >nul
        if errorlevel 1 (
            set /a updated += 1
        ) else (
            set /a up_to_date += 1
        )
        del "%tempfile%"
    ) else (
        echo No update available
        set /a non_git += 1
    )
    echo.
)

popd >nul

set /a total_git=updated + up_to_date

echo.
echo Update summary:
echo   - %total_git% Git plugins checked
if %updated% gtr 0 (
    echo   - %updated% plugins updated with new changes
) else (
    echo   - All Git plugins already up to date
)
echo   - %non_git% folders skipped (not Git repositories)
echo.
echo All done!
pause
