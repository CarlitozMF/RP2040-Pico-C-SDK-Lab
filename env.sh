#!/usr/bin/env bash

# 1. Obtener la ruta raíz del workspace
WORKSPACE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 2. Detectar el Sistema Operativo
OS_TYPE="$(uname -s)"

case "${OS_TYPE}" in
    Linux*)     
        # Detectar si es Git Bash en Windows o Linux Nativo
        if grep -qE "(Microsoft|WSL)" /proc/version 2>/dev/null; then
            OS_SUFFIX="win"
        else
            OS_SUFFIX="linux"
        fi
        ;;
    MINGW*|MSYS*|CYGWIN*)
        # Entornos de Bash corriendo en Windows (Git Bash, MINGW, etc.)
        OS_SUFFIX="win"
        ;;
    Darwin*)
        OS_SUFFIX="mac"
        ;;
    *)
        OS_SUFFIX="linux"
        ;;
esac

# 3. Exportar variables del SDK
export PICO_SDK_PATH="$WORKSPACE_DIR/libs/pico-sdk"
export PICO_MISC_PATH="$WORKSPACE_DIR/misc"

# 4. Asignar las herramientas según el SO detectado
export PATH="$WORKSPACE_DIR/tools/gcc-arm-${OS_SUFFIX}/bin:$WORKSPACE_DIR/tools/cmake-${OS_SUFFIX}/bin:$WORKSPACE_DIR/tools/ninja-${OS_SUFFIX}:$PATH"

echo "=========================================================="
echo " [PICO TOOLCHAIN PORTABLE] Entorno configurado"
echo " Sistema detectado: ${OS_TYPE} (Usando binarios: -${OS_SUFFIX})"
echo " PICO_SDK_PATH = $PICO_SDK_PATH"
echo "=========================================================="