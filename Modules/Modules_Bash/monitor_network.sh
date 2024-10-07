#!/bin/bash
 
# Función que muestra el menu principal
main_menu() {
  clear
  echo "Menú Monitoreo de Red"
  echo "1. Mostrar interfaces de red disponibles"
  echo "2. Monitoreo de tráfico de red"
  echo "3. Crear reporte de tráfico en la red"
  echo "4. Salir"
  echo -n "Ingrese una opción: "
}
 
# Función que muestra las interfaces de red disponibles
show_interfaces() {
  echo "Interfaces de red disponibles:"
  sudo ip link show | awk '{print $2}'
  echo ""
  echo "Presione una tecla para regresar al menú principal..."
  read -n 1
}
 
# Función que monitorea el tráfico de red
network_traffic() {
  local interface=$1
  local duration=$2
  echo "Monitoreo de tráfico de red en $interface durante $duration segundos en curso..."
  # Comando para monitorear tráfico de red por tiempo limitado
  echo ""
  sudo timeout "$duration" tcpdump -i "$interface"
  echo ""
  echo "Presione una tecla para regresar al menú principal..."
  read -n 1
}
 
# Función que genera el reporte de trafico en la red
create_report() {
  local interface=$1
  local duration=$2
  echo "Creando reporte de tráfico en la red en $interface durante $duration segundos..."
  # Comando para generar reporte de tráfico dirigido a un archivo .txt
  echo ""
  sudo echo "" > traffic.txt
  sudo timeout "$duration" sudo tcpdump -i "$interface" | sudo awk '{print $1, $2, $3}' >> traffic.txt
  echo "Reporte generado en traffic.txt"
  echo ""
  echo "Presione una tecla para regresar al menú principal..."
  read -n 1
}
 
# Función que verifica si la interfaz de red es válida
is_valid_interface() {
  local interface=$1
  if sudo ip link show | grep -q "$interface"; then
    return 0
  else
    return 1
  fi
}
 
# Script principal
while true; do
  main_menu
  read -r option
  case $option in
    1)
      show_interfaces
      ;;
    2)
      while true; do
        echo -n "Ingrese la interfaz de red: "
        read -r interface
        if is_valid_interface "$interface"; then
          break
        else
          echo "La interfaz no es correcta. Vuelva a intentarlo"
          sleep 1
        fi
      done
      echo -n "Ingrese la duración del monitoreo (En segundos): "
      read -r duration
      if [ -z "$duration" ]; then
        echo "Error: Parámetro no permitido"
        sleep 1
        continue
      fi
      network_traffic "$interface" "$duration"
      ;;
    3)
      while true; do
        echo -n "Ingrese la interfaz de red: "
        read -r interface
        if is_valid_interface "$interface"; then
          break
        else
          echo "La interfaz no es correcta. Vuelva a intentarlo"
          sleep 1
        fi
      done
      echo -n "Ingrese la duración del monitoreo (En segundos): "
      read -r duration
      if [ -z "$duration" ]; then
        echo "Error: Parámetro no permitido"
        sleep 1
        continue
      fi
      create_report "$interface" "$duration"
      ;;
    4)
      exit 0
      ;;
    *)
      echo "Opción inválida"
      sleep 1
      continue
      ;;
  esac
done
