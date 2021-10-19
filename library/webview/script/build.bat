@echo off

echo Prepare directories...
set script_dir=%~dp0
set src_dir=%script_dir%..
set build_dir=%script_dir%..\build
mkdir "%build_dir%"

echo Webview directory: %src_dir%
echo Build directory: %build_dir%

echo Looking for vswhere.exe...
set "vswhere=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist "%vswhere%" set "vswhere=%ProgramFiles%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist "%vswhere%" (
	echo ERROR: Failed to find vswhere.exe
	exit 1
)
echo Found %vswhere%

echo Looking for VC...
for /f "usebackq tokens=*" %%i in (`"%vswhere%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
  set vc_dir=%%i
)
if not exist "%vc_dir%\Common7\Tools\vsdevcmd.bat" (
	echo ERROR: Failed to find VC tools x86/x64
	exit 1
)
echo Found %vc_dir%


@REM call "%vc_dir%\Common7\Tools\vsdevcmd.bat" -arch=x86 -host_arch=x64
@REM echo Building webview.dll (x86)
@REM mkdir "%src_dir%\..\dll\x86"
@REM cl /D "WEBVIEW_API=__declspec(dllexport)" ^
@REM 	/I "%src_dir%\script\microsoft.web.webview2.1.0.664.37\build\native\include" ^
@REM 	"%src_dir%\script\microsoft.web.webview2.1.0.664.37\build\native\x86\WebView2Loader.dll.lib" ^
@REM 	/std:c++17 /EHsc "/Fo%build_dir%"\ ^
@REM 	"%src_dir%\webview.cc" /link /DLL "/OUT:%build_dir%\webview.dll" || exit \b
@REM copy "%build_dir%\webview.dll" "%src_dir%\..\dll\x86"
@REM copy "%src_dir%\script\microsoft.web.webview2.1.0.664.37\build\native\x86\WebView2Loader.dll" "%src_dir%\..\dll\x86"

call "%vc_dir%\Common7\Tools\vsdevcmd.bat" -arch=x64 -host_arch=x64
echo Building webview.dll (x64)
mkdir "%src_dir%\..\..\out\windows\x64"
cl /D "WEBVIEW_API=__declspec(dllexport)" ^
	/I "%src_dir%\script\microsoft.web.webview2.1.0.664.37\build\native\include" ^
	"%src_dir%\script\microsoft.web.webview2.1.0.664.37\build\native\x64\WebView2Loader.dll.lib" ^
	/std:c++17 /EHsc "/Fo%build_dir%"\ ^
	"%src_dir%\webview.cc" /link /DLL "/OUT:%src_dir%\..\..\out\windows\x64\webview.dll" || exit \b

@REM Copy build files to out
@REM copy "%src_dir%\script\microsoft.web.webview2.1.0.664.37\build\native\x64\WebView2Loader.dll" "%build_dir%"
copy "%src_dir%\script\microsoft.web.webview2.1.0.664.37\build\native\x64\WebView2Loader.dll" "%src_dir%\..\..\out\windows\x64"
