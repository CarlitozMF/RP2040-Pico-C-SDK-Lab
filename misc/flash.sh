#!/usr/bin/env bash

UF2_FILE="$1"
ELF_FILE="${UF2_FILE%.uf2}.elf"

if [ -z "$UF2_FILE" ]; then
    echo "[FLASH ERROR] No se especificó archivo de firmware."
    exit 1
fi

echo "[PICO FLASH] Flasheando mediante picotool..."

# Seleccionar ejecutable (.elf preferido, sino .uf2)
TARGET_FILE="$UF2_FILE"
if [ -f "$ELF_FILE" ]; then
    TARGET_FILE="$ELF_FILE"
fi

# Invocación directa a picotool nativo
if picotool load -x "$TARGET_FILE"; then
    echo "=========================================================="
    echo " ¡Firmware ($TARGET_FILE) cargado y ejecutando con éxito!"
    echo "=========================================================="
    exit 0
else
    echo "=========================================================="
    echo " Error: No se pudo comunicar con la Raspberry Pi Pico."
    echo " Verificá que la placa esté conectada en modo BOOTSEL."
    echo "=========================================================="
    exit 1
fi