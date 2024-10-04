#!/bin/bash

# Función para realizar un escaneo de puertos
port_scan() {
    # Si se pasan argumentos, usarlos como target y port_range
    if [[ $# -ge 2 ]]; then
        target="$1"
        port_range="$2"
    else
        read -p "Ingrese la IP o dominio objetivo: " target
        read -p "Ingrese el rango de puertos (ej. 1-100): " port_range
    fi

    # Validar que target no esté vacío
    if [[ -z "$target" ]]; then
        echo "Error: El objetivo no puede estar vacío."
        return 1
    fi

    # Validar que el rango de puertos esté en el formato correcto
    if [[ ! "$port_range" =~ ^[0-9]+-[0-9]+$ ]]; then
        echo "Error: Formato de rango de puertos inválido. Use inicio-fin (ej. 1-100)."
        return 1
    fi

    echo "Iniciando escaneo de puertos para $target en los puertos $port_range..."
    
    # Realizar el escaneo usando nmap
    scan_result=$(nmap -p "$port_range" "$target" 2>/dev/null)
    
    if [[ $? -ne 0 ]]; then
        echo "Error: El escaneo de puertos falló."
        return 1
    fi

    echo "Escaneo de puertos completado exitosamente."
    echo "$scan_result"
    
    # Guardar los resultados para posibles reportes
    LAST_TARGET="$target"
    LAST_PORT_RANGE="$port_range"
    LAST_SCAN_RESULT="$scan_result"

    return 0
}

# Función para generar un reporte del escaneo
generate_report() {
    if [[ -z "$LAST_TARGET" || -z "$LAST_PORT_RANGE" || -z "$LAST_SCAN_RESULT" ]]; then
        echo "Error: Debes realizar un escaneo de puertos primero."
        return 1
    fi

    echo "Generando reporte..."

    timestamp=$(date +%Y%m%d_%H%M%S)
    report_file="port_scan_report_$timestamp.txt"

    {
        echo "Reporte de Escaneo de Puertos"
        echo "Fecha y Hora: $(date)"
        echo "Objetivo: $LAST_TARGET"
        echo "Rango de Puertos: $LAST_PORT_RANGE"
        echo "Resultados del Escaneo:"
        echo "$LAST_SCAN_RESULT"
    } > "$report_file"

    if [[ $? -ne 0 ]]; then
        echo "Error: No se pudo generar el reporte."
        return 1
    fi

    echo "Reporte guardado como $report_file."
    return 0
}

# Función para reiniciar el escaneo con nuevos datos
rerun_scan() {
    echo "Reiniciando el escaneo con nuevos datos."
    port_scan
}

# Función para mostrar el menú principal
main_menu() {
    while true; do
        echo "-----------------------------"
        echo "Port Scanner - Menú Principal"
        echo "1) Iniciar Escaneo de Puertos"
        echo "2) Generar Reporte"
        echo "3) Reejecutar Escaneo con Otros Datos"
        echo "4) Salir"
        echo "-----------------------------"
        read -p "Elige una opción: " choice

        case $choice in
            1)
                port_scan
                ;;
            2)
                generate_report
                ;;
            3)
                rerun_scan
                ;;
            4)
                echo "Saliendo del programa. ¡Hasta luego!"
                exit 0
                ;;
            *)
                echo "Opción inválida. Por favor, elige nuevamente."
                ;;
        esac
    done
}

# Verificar si nmap está instalado
if ! command -v nmap &> /dev/null; then
    echo "Error: nmap no está instalado. Por favor, instálalo para usar este script."
    exit 1
fi

# Iniciar el menú principal
main_menu
