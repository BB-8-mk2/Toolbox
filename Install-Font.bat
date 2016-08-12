@echo off

set logdir=c:\temp
set logfile=Install-Font.txt

if not exist %logdir% mkdir %logdir%
rem echo "%logdir%"
echo. >> %logdir%\%logfile%

REM How to use:
REM Place the batch file inside the folder of the font files OR:
REM Optional Add source folder as parameter with ending backslash and dont use quotes, spaces are allowed
REM example "ADD_fonts.cmd" C:\Folder 1\Folder 2\

rem Exec proc =========================================
echo. >> %logdir%\%logfile%
echo Start Install : %exepg1%	%date% %time% >> %logdir%\%logfile%

cd /d %~dp0

IF NOT "%*"=="" SET SRC=%*
FOR /F %%i in ('dir /b "%SRC%*.*tf"') DO CALL :FONT %%i
echo. >> %logdir%\%logfile%
GOTO :end

:FONT
echo. >> %logdir%\%logfile%
REM ECHO FILE=%~f1
SET FFILE=%~n1%~x1
SET FNAME=%~n1
SET FNAME=%FNAME:-= %
IF "%~x1"==".otf" SET FTYPE=(OpenType)
IF "%~x1"==".ttf" SET FTYPE=(TrueType)

REM ECHO FILE=%FFILE%
REM ECHO NAME=%FNAME%
REM ECHO TYPE=%FTYPE%

echo Start: %FFILE%	%date%	%time%>> %logdir%\%logfile%
COPY /Y "%~dp0%SRC%%~n1%~x1" "%SystemRoot%\Fonts"
echo errorlevel: %errorlevel% >> %logdir%\%logfile%
echo end: %FFILE%	%date%	%time%>> %logdir%\%logfile%
echo. >> %logdir%\%logfile%
IF %ERRORLEVEL% GTR 0 GOTO :errend

echo Start: Add Registry of %FFILE%	%date%	%time%>> %logdir%\%logfile%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "%FNAME% %FTYPE%" /t REG_SZ /d "%FFILE%" /f
echo errorlevel: %errorlevel% >> %logdir%\%logfile%
echo end: 	Add Registry of %FFILE%	%date%	%time%>> %logdir%\%logfile%
echo. >> %logdir%\%logfile%
IF %ERRORLEVEL% GTR 0 GOTO :errend

GOTO :EOF

rem End proc =========================================
:errend
echo end:abnormally end 	%date%	%time%>> %logdir%\%logfile%
echo. >> %logdir%\%logfile%
exit /B %EXIT_CODE%

:end
echo end:normally end 	%date%	%time%>> %logdir%\%logfile%
echo. >> %logdir%\%logfile%
exit /B %EXIT_CODE%
