@echo off
:: Universal touch script with directory creation
:: Check if arguments are provided
if "%~1"=="" (
    echo Usage: touch ^<file1^> ^<file2^> ... ^<fileN^>
    exit /b 1
)

:: Detect if the script is running in PowerShell or CMD
setlocal
for /f "delims=" %%i in ('PowerShell -Command "Write-Output $true" 2^>nul') do set PS_AVAILABLE=%%i

:: Loop through all arguments
:loop
if "%~1"=="" goto :end
    :: First, ensure the directory exists
    mkdir "%~dp1" 2>nul

    if defined PS_AVAILABLE (
        :: Use PowerShell for touch logic
        PowerShell -Command "if (-Not (Test-Path '%~1')) { New-Item -ItemType File -Path '%~1' | Out-Null } else { (Get-Item '%~1').LastWriteTime = Get-Date }"
    ) else (
        :: Fallback to CMD logic
        if not exist "%~1" (
            echo.>"%~1"
        ) else (
            copy /b "%~1" +,, > nul
        )
    )
    shift
goto :loop
:end
endlocal
exit /b 0
