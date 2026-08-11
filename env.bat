@echo off
set "WORKSPACE_DIR=%~dp0"

:: Configurar rutas del SDK y Misc
set "PICO_SDK_PATH=%WORKSPACE_DIR%libs\pico-sdk"
set "PICO_MISC_PATH=%WORKSPACE_DIR%misc"

:: PATH apuntando a las herramientas de Windows
set "PATH=%WORKSPACE_DIR%tools\gcc-arm-win\bin;%WORKSPACE_DIR%tools\cmake-win\bin;%WORKSPACE_DIR%tools\ninja-win;%WORKSPACE_DIR%tools\openocd\bin;%PATH%"

echo ==========================================================
echo  [PICO TOOLCHAIN PORTABLE] Entorno configurado (Windows)
echo  PICO_SDK_PATH = %PICO_SDK_PATH%
echo ==========================================================
cmd /k