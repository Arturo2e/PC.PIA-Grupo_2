import requests
import os
import logging
from dotenv import load_dotenv

logger = logging.getLogger('abuseipdb')
logger.setLevel(logging.INFO)

file_handler = logging.FileHandler('abuseipdb.log')

formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
file_handler.setFormatter(formatter)

logger.addHandler(file_handler)

load_dotenv()

API_URL = "https://api.abuseipdb.com/api/v2/check"
API_KEY = os.getenv('API_KEY')

if API_KEY is None:
    logger.error("No se cargo de manera correcta la API_KEY.")
else:
    logger.info("API_KEY fue cargada de manera correcta")

def check_ip(ip_address):

    headers = {
        'Accept': 'application/json',
        'key': API_KEY
    }

    params = {
        'ipAddress': ip_address,
        'maxAgeInDays': 90
    }

    try:
        response = requests.get(API_URL, headers = headers, params = params)
        response.raise_for_status()
        logger.info(f"Consulta exitosa de la IP: {ip_address}")
        return response.json()

    except requests.exceptions.RequestException as e:
        logger.error(f"Error al consultar la IP {ip_address}")
        return None

def menu():
    print("\nMenu de opciones")
    print("1.- Obtener información de una IP")
    print("2.- Salir")

def main():
    while True:
        menu()
        op = input("Seleccione una opción: ").strip()

        if op == "1":
            ip_address = input("Ingresa una dirección IP para verificar: ").strip()

            if ip_address:
                result = check_ip(ip_address)
                if result:
                    logging.info(f"Resultados obtenidos para la IP {ip_address}: {result}")
                    print(f"Resultados para la IP {ip_address}: ")
                    data = result['data']
                    print(f"IP: {data['ipAddress']}")
                    print(f"País: {data['countryCode']}")
                    print(f"Tipo de uso: {data['usageType']}")
                    print(f"ISP: {data['isp']}")
                    print(f"Dominio: {data['domain']}")
                    print(f"Score de abuso: {data['abuseConfidenceScore']}")
                    print(f"Total de reportes: {data['totalReports']}")
                    print(f"Ultimo reporte: {data['lastReportedAt']}")
                else:
                    print(f"No se pudo obtener información para la IP {ip_address}")
                    logger.warning("No se ingresó ninguna dirección IP válida")
        elif op == "2":
            print("Saliendo de Abuse IPDB...")
            logger.info("El usuario ha salido del programa.")
            break
        else:
            print("Opción no valida, por favor intente de nuevo.")
            logger.warning("Opción seleccionada no valida.")
