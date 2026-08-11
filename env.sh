#!/usr/bin/env bash

# Directorio raíz de la plantilla
export WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PICO_SDK_PATH="$WORKSPACE_DIR/libs/pico-sdk"
export PICO_MISC_PATH="$WORKSPACE_DIR/misc"

# Detectar el Sistema Operativo
UNAME_OUT="$(uname -s)"
case "${UNAME_OUT}" in
    Linux*)     OS_TYPE=Linux;;
    MINGW*|MSYS*|CYGWIN*) OS_TYPE=Windows;;
    *)          OS_TYPE="UNKNOWN"
esac

echo "=========================================================="
echo " [PICO TOOLCHAIN] Entorno configurado"
echo " Sistema detectado: $OS_TYPE"

if [ "$OS_TYPE" = "Linux" ]; then
    echo " MODO LINUX: Usando herramientas nativas del sistema"
    # En Linux no alteramos el PATH con herramientas locales de tools/
else
    echo " MODO WINDOWS: Usando herramientas portables desde tools/"
    export PATH="$WORKSPACE_DIR/tools/gcc-arm-win/bin:$WORKSPACE_DIR/tools/cmake-win/bin:$WORKSPACE_DIR/tools/ninja-win:$WORKSPACE_DIR/tools/elf2uf2-win:$PATH"
fi

echo " PICO_SDK_PATH = $PICO_SDK_PATH"
echo "=========================================================="