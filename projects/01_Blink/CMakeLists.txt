cmake_minimum_required(VERSION 3.13)

# 1. Exportar base de datos de compilación
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# 2. Incluir el helper del SDK
include($ENV{PICO_MISC_PATH}/pico_sdk_import.cmake)

# 3. Desactivar picotool (evita fallos por espacios en la ruta de usuario)
set(PICO_NO_PICOTOOL 1 CACHE INTERNAL "")

# 4. Nombre del proyecto automático basado en la carpeta contenedora
get_filename_component(PROJECT_FOLDER_NAME "${CMAKE_CURRENT_SOURCE_DIR}" NAME)
project(${PROJECT_FOLDER_NAME} C CXX ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

# 5. Inicializar el SDK
pico_sdk_init()

# 6. Buscar fuentes .c y .cpp ignorando la carpeta build
file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS 
    "${CMAKE_CURRENT_SOURCE_DIR}/*.c" 
    "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp"
)
list(FILTER SOURCES EXCLUDE REGEX "${CMAKE_CURRENT_SOURCE_DIR}/build/.*")

# 7. Definir ejecutable
add_executable(${PROJECT_NAME} ${SOURCES})

# 8. Vincular librerías del SDK
target_link_libraries(${PROJECT_NAME} 
    pico_stdlib
)

# 9. Salidas adicionales
pico_add_extra_outputs(${PROJECT_NAME})

# 10. Generar .uf2 post-build
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND elf2uf2 ${PROJECT_NAME}.elf ${PROJECT_NAME}.uf2
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "Generando ${PROJECT_NAME}.uf2..."
)

# 11. Target para flashear automáticamente (Detecta el Host OS real)
if(CMAKE_HOST_WIN32)
    add_custom_target(flash
        COMMAND cmd /c "for %d in (D E F G H I J K) do if exist %d:\\INFO_UF2.TXT copy /Y ${PROJECT_NAME}.uf2 %d:\\"
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS ${PROJECT_NAME}
        COMMENT "Buscando Raspberry Pi Pico y copiando ${PROJECT_NAME}.uf2 en Windows..."
    )
else()
    add_custom_target(flash
        COMMAND bash -c "DEST=$$(ls -d /media/$$USER/RPI-RP2 /run/media/$$USER/RPI-RP2 2>/dev/null | head -n 1); if [ -n \"$$DEST\" ]; then cp ${PROJECT_NAME}.uf2 \"$$DEST/\"; echo 'Firmware copiado con exito!'; else echo 'Error: No se encontro la Pico en modo BOOTSEL'; exit 1; fi"
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS ${PROJECT_NAME}
        COMMENT "Buscando Raspberry Pi Pico y copiando ${PROJECT_NAME}.uf2 en Linux..."
    )
endif()