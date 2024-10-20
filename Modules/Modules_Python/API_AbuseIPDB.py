import requests
import os
import logging
from dotenv import load_dotenv

logging.basicConfig(
    filename = 'registro_AbuseIPDB.log',
    level = logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

load_dotenv()

API_URL = "https://api.abuseipdb.com/api/v2/check"
API_KEY = os.getenv('API_KEY')

if API_KEY is None:
    logging.error("No se cargo de manera correcta la API_KEY.")
else:
    logging.info("API_KEY fue cargada de manera correcta")

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
        logging.info(f"Consulta exitosa de la IP: {ip_address}")
        return response.json()

    except requests.exceptions.RequestException as e:
        logging.error(f"Error al consultar la IP {ip_address}")
        return None

def main():
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
            logging.warning("No se ingresó ninguna dirección IP válida")
            
if __name__ == "__main__":
    main()
    
