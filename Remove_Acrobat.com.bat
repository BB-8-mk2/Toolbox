@echo off
rem https://forums.adobe.com/thread/457502

set logdir=c:\temp
set logfile=Remove_Acrobat.com.txt
set tgtdir1="C:\Program Files\Adobe\Acrobat.com"

if not exist %logdir% mkdir %logdir%
rem echo "%logdir%"

rem log outout
echo. >> %logdir%\%logfile%
rem echo. >> %logdir%\%logfile%

rem ====================
:Step1
echo Start: Remove Acrobat.com >> %logdir%\%logfile%
echo. >> %logdir%\%logfile%

echo Remove Acrobat.com
msiexec.exe /qn /x {77DCDCE3-2DED-62F3-8154-05E745472D07}
echo errorlevel: %errorlevel% >> %logdir%\%logfile%
echo. >> %logdir%\%logfile%

if errorlevel 1 goto Step2
if errorlevel 0 goto end

rem ====================
:Step2
echo Start: Delete Registry Keys	%exereg1%	%date%	%time%>> %logdir%\%logfile%
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{77DCDCE3-2DED-62F3-8154-05E745472D07}" /f %logdir%\%logfile%
echo end:  %date%	%time%>> %logdir%\%logfile%

echo Start: Delete directories	%tgtdir1%	%date%	%time%>> %logdir%\%logfile%
IF EXIST "C:\Program Files\Adobe\Acrobat.com" (
    rmdir "C:\Program Files\Adobe\Acrobat.com" /s /q
)
echo end:  %date%	%time%>> %logdir%\%logfile%

rem ====================
:end
exit /B %EXIT_CODE%
