import requests
import os
import logging
from dotenv import load_dotenv

logging.basicConfig(
    level=logging.INFO,
    filename = 'registro_AbuseIPDB.log',
    format = '%(asctime)s - %(levelname)s - %(message)s'
)

#Se cargan las variables de entorno del archivo .env
load_dotenv()

API_URL = "https://api.abuseipdb.com/api/v2/check"
API_KEY = os.getenv('API_KEY') #La API_KEY se carga desde un archivo externo (.env)


def check_ip (ip_address):
    """
    Consulta la API de AbuseIPDB para revisar si una API ha sido reportada.

    Args:
        ip_address (str): La dirección IP a consultar.

    Returns:
        diccionario o None: La respuesta en formato JSON si la consulta es exitosa, None en caso de algún error.
    """

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
        logging.info(f"Consulta exitosa para la IP: {ip_address}")
        return response.json()

    except requests.exceptions.RequestException as e:
        logging.error(f"Error al consultar la IP {ip_address}: {e}")
        return None

def main():
    """
    Función principal, es quien realiza la verificación de la IP.
    """

    ip_address = input("Ingresa una dirección IP para verificar: ").strip()
        
    
    if ip_address:
        result = check_ip(ip_address)
        if result:
            print(f"Resultados para la IP {ip_address}:\n")
            data = result.get('data', {})
            print(f"Dirección IP: {data.get('ipAddress')}")
            print(f"¿Es pública? {'Si' if data.get('isPublic') else 'No'}")
            print(f"Versión IP: {data.get('ipVersion')}")
            print(f"¿Está en la lista blanca?: {'Si' if data.get('isWhitelisted') else 'No'}")
            print(f"Código de país: {data.get('countryCode')}")
            print(f"Tipo de uso: {data.get('usageType')}")
            print(f"Proveedor de servicios: {data.get('isp')}")
            print(f"Total de reportes: {data.get('totalReports')}")
            print(f"Número de usuarios distintos: {data.get('numDistinctUsers')}")
            print(f"Último reporte: {data.get('lastReportedAdt')}\n")
   
            logging.info(f"Resultados obtenidos para la IP {ip_address}: {result}")

        else:
            print(f"No se pudo obtener información para la IP {ip_address}.")
            logging.warning("Consulta fallida para la IP {ip_address}.")

    else:
        print ("Por favor, ingresa una dirección IP válida.")
        logging.warning("No se ingresó ninguna dirección IP válida.")


if __name__ == "__main__":
    main()
        
