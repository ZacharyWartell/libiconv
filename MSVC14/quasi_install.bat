REM \author Zachary Wartell <zwartell@uncc.edu>
REM
REM \todo make this script more generlizable
REM
REM quasi_install.bat %PLATFORM% %CONFIGURAION% %TARGET_NAME%
REM 
REM arguements are required and are the correspondingly named MSVS macros


set PLATFORM=%1
set CONFIGURATION=%2
set TARGET_NAME=%3

echo --------------------------
echo Running "quasi_install.bat"
REM cd
REM exit

set INSTALL_DIR=..\..\..\install\MSVS_2015\%PLATFORM%\
set INSTALL_BIN_DIR=%INSTALL_DIR%bin
set INSTALL_LIB_DIR=%INSTALL_DIR%lib
set INSTALL_INC_DIR=%INSTALL_DIR%include

IF NOT EXIST "%INSTALL_INC_DIR%\iconv" mkdir "%INSTALL_INC_DIR%\iconv"

REM echo INSTALL_BIN_DIR %INSTALL_BIN_DIR%
REM dir %INSTALL_BIN_DIR%

if %PLATFORM% == Win32 (
	set OUTPUT_SUFFIX_DIR=%CONFIGURATION%
) else (
	set OUTPUT_SUFFIX_DIR=%PLATFORM%\%CONFIGURATION%
)

set DEBUG=0
if %DEBUG% == 1 (
	cd
	echo OUTPUT_SUFFIX_DIR: %OUTPUT_SUFFIX_DIR%

	echo HERE
	dir "%OUTPUT_SUFFIX_DIR%"
	dir "Debug"

	echo UP
	dir "..\%OUTPUT_SUFFIX_DIR%"
)

if %TARGET_NAME% == libiconv_dll (
	xcopy /Y "%OUTPUT_SUFFIX_DIR%\*.dll" "%INSTALL_BIN_DIR%\"
	xcopy /Y "..\%OUTPUT_SUFFIX_DIR%\*.pdb" "%INSTALL_LIB_DIR%\"
)

xcopy /Y "%OUTPUT_SUFFIX_DIR%\*.lib" "%INSTALL_LIB_DIR%\"
xcopy /Y "..\..\source\include\iconv.h" "%INSTALL_INC_DIR%\iconv\" 



REM
REM rename based on the expectations of the libxml2 MSVS compilation scripts
REM

pushd "%INSTALL_LIB_DIR%"

if %CONFIGURATION% == Debug (
    set LIB_FILE=iconvd.lib
    set PDB_FILE=iconvd.pdb
    set DLL_FILE=iconvd.dll
) else (
    set LIB_FILE=iconv.lib
    set PDB_FILE=iconv.pdb
    set DLL_FILE=iconv.dll
)
if EXIST %LIB_FILE% del /q %LIB_FILE%
if EXIST %PDB_FILE% del /q %PDB_FILE%

if %TARGET_NAME% == libiconv_dll (
    echo Script not programmed to handling install of .dll files yet!
    echo    Did you mean to compile the static "libiconv_static" project instead?
      
    REM rename libiconv_dll.lib %LIB_FILE% 
    REM rename libiconv_dll.pdb %PDB_FILE%
) else (
    if %CONFIGURATION% == Debug (
	rename libiconv_a_debug.lib %LIB_FILE% 
    ) else (
	rename libiconv_a.lib %LIB_FILE% 
    )
)

popd

echo off
REM pushd ""%INSTALL_BIN_DIR%"
REM rename libiconv_debug.dll iconv.dll
REM popd
