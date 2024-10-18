import requests
import os
from dotenv import load_dotenv


#Se cargan las variables de entorno del archivo .env
load_dotenv()

API_URL = "https://api.abuseipdb.com/api/v2/check"
API_KEY = os.getenv('API_KEY') #La API_KEY se carga desde un archivo externo (.env)


def check_ip (ip_address):

    headers = {
        'Accept': 'application/json',
        'Key': API_KEY
    }

    params = {
        'ipAddress': ip_address,
        'maxAgeInDays': 90
    }


    try:
        response = requests.get(API_URL, headers = headers, params = params)
        response.raise_for_status() #Lanza un error si la respuesta del servidor no tiene un código de estado HTTP exitoso
        return response.json()

    except requests.exceptions.RequestException as e:
        print(f"Error al consultar la IP {ip_address}: {e}")
        return None

def save(output, file):
    print(output)
    file.write(output + "\n")

def results(ip_address, result):
    with open('resultados_ip.txt', 'a') as file:
        data = result.get('data', {})
        save(f"Dirección IP: {data.get('ipAddress')}", file)
        save(f"¿Es pública? {'Si' if data.get('isPublic') else 'No'}", file)
        save(f"Versión IP: {data.get('ipVersion')}", file)
        save(f"¿Está en la lista blanca?: {'Si' if data.get('isWhitelisted') else 'No'}", file)
        save(f"Código de país: {data.get('countryCode')}", file)
        save(f"Tipo de uso: {data.get('usageType')}", file)
        save(f"Proveedor de servicios: {data.get('isp')}", file)
        save(f"Total de reportes: {data.get('totalReports')}", file)
        save(f"Número de usuarios distintos: {data.get('numDistinctUsers')}", file)
        save(f"Último reporte: {data.get('lastReportedAdt')}\n", file)

        print(f"Los resultados de la IP se guardaron en el archivo 'resultados_ip.txt' en el directorio actual")

def main():
    while True:
        print("\n-- Menú --")
        print("1. Consultar una dirección IP")
        print("2. Salir")

        op = input("Elige una opción: ").strip()

        if op == "1":
            ip_address = input ("Ingresa una dirección IP a verificar: ")

            if ip_address:
                result = check_ip(ip_address)
                if result:
                    results(ip_address, result)
                else:
                    print(f"No se pudo obtener información para la IP {ip_address}. ")

            else:
                print("Por favor ingresa una direccción IP válida.")

        elif op == "2":
            print("Saliendo del programa...")
            break

        else:
            print("Opción no valida. Por favor elige una opción válida.")
        
