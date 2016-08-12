@echo off
rem 
rem Java7 Install Script for GDEx
rem 
rem   date: 2016/05/26 by IGSCH
rem

if exist "c:\temp" goto skipcdir
md "c:\temp"
:skipcdir
set logfile="C:\temp\jre7install.log"
set bpath=%~dp0

rem =============================================
:InstallCheck
if exist "C:\Program Files (x86)" goto 64bitOS
:32bitOS
java -version >nul 2>&1 && goto VerCheck || goto :choice
:64bitOS
java -d32 -version >nul 2>&1 && goto VerCheck || goto :choice

rem =============================================
:VerCheck
echo Java の導入状況をチェックしています．．．
echo   (１分ほどお待ちください)

rem Check and List installed Java version
powershell -Command "& Get-WMIObject -Class win32_product -filter """(name like 'Java%%' or name like 'J2SE%%') and not name like '%%(64-bit)%%'""" | Sort-Object Version | Select Name,Version "
rem echo powershell -Command "& Get-WMIObject -Class win32_product -filter """name like 'Java%%' or name like 'J2SE%%'""" | Sort-Object Version | Select Name,Version " >> %logfile%

echo 上記のバージョンがインストールされています
echo  * "7.0.xxx" または "8.0.xxx" が表示された場合、インストールは不要です
echo.
goto choice

rem =============================================
:choice
set /P c=JRE7(Update10) のインストールを続行しますか？[Y/N]
if /I "%c%" EQU "Y" goto :install
if /I "%c%" EQU "N" goto :cancel
goto :choice

rem =============================================
:install
echo.
echo JRE7(Update10) Install start: %date% %time% >> %logfile%
echo インストールを実行しています
%bpath%jre-7u10-windows-i586.exe /s IEXPLORER=1 MOZILLA=1 ADDLOCAL=ALL JAVAUPDATE=0 JU=0 AUTOUPDATECHECK=0 JQS=0 SYSTRAY=0 EULA=0 REBOOT=Suppress /L C:\Temp\java7u10.txt
echo errorlevel: %errorlevel% >> %logfile%
if errorlevel 1 goto errend

rem =============================================
rem 32bit/64bit OS Check
if exist "C:\Program Files (x86)" goto 64BITOS
set _KEY="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
set _KEY2="HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Update\Policy"
goto setval
:64BITOS
set _KEY="HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run"
set _KEY2="HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\JavaSoft\Java Update\Policy"

:setval
set _VALUE="SunJavaUpdateSched"
reg delete %_KEY% /v %_VALUE% /f >> %logfile% 2>&1

set _VALUE2="EnableJavaUpdate"
reg add %_KEY2% /v %_VALUE2% /t REG_DWORD /d 0 /f >> %logfile% 2>&1

set _VALUE3="NotifyDownload"
reg add %_KEY2% /v %_VALUE3% /t REG_DWORD /d 0 /f >> %logfile% 2>&1

rem "%PROGRAMFILES%\Java\jre6\bin\jqs.exe" -unregister
rem echo jqs.exe uninstall status=%ERRORLEVEL% >> %logfile% 2>&1

echo JRE7(Update10) のインストールが正常に完了しました
echo JRE7(Update10) Install Normal End:  %date% %time% >> %logfile%
pause
exit 0

rem =============================================
:errend
if %errorlevel%==1603 goto errend2  
echo. 
echo JRE7(Update10) のインストールに失敗しました（ステータス=%ERRORLEVEL%）
echo JRE7(Update10) Install Abnormal End errlevel==%ERRORLEVEL% %date% %time% >> %logfile%
echo. 
pause
exit %errorlevel%

:errend2
echo. 
echo JRE7(Update10) のインストールに失敗しました（ステータス=%ERRORLEVEL%） 
echo すでにJREがインストールされている可能性があります。
echo 再インストールが必要な場合は、JREをアンインストール後、再実行してください。
echo.  >> %logfile%
wmic /OUTPUT:%logfile% product where( name like 'J2SE%%' or name like 'Java%%' ) get name,version
echo. 
pause
exit %errorlevel%

:cancel
echo. 
echo JRE7(Update10) のインストールを中止します
pause
exit %errorlevel%
