import shodan,sys
import pandas as pd
import logging

logging.basicConfig(
    filename="busqueda_shodan.log",
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

api_key =input("Ingrese su API key: ").strip()

if not api_key:
    logging.error("Ingrese un api key correcto")
    sys.exit("Error.No se ingreso un api key valido")

shodan_api = shodan.Shodan(api_key)

try:
    logging.info("Validando apikey...")
    shodan_api.info()
    logging.info("API Key valida")
except shodan.APIError as e:
    logging.error(f"API key inválida: {e}")
    sys.exit(f"Error: API key inválida. {e}")
    
#ejemplos de ejecucion apache,apache country:US,"OpenSSH 7.4" port:22, port:554 has_screenshot:true)
query=input("Ingrese la consulta de busqueda para Shodan: ").strip()
if not query:
    logging.error("No se ingreso una consulta valida")
    sys.exit("Error.Ingrese una consulta valida")
 
try:
    logging.info("Iniciando busqueda de la consulta {query}")
    results=shodan_api.search(query)
    logging.info(f"Resultados encontrados: {results["total"]}")
 
    data_list=[]
 
    for result in results["matches"]:
        ip = result.get('ip_str', 'No IP found')
        data=result.get("data", "No existe ningun dato")
        data_list.append({"IP": ip, "data": data})
   
    df= pd.DataFrame(data_list)
#De ser neceseario cambiar la ubicacion de los resultados,modifique la direccion de la carpeta Downloads
    output_path=r"C:\Users\Dell\Downloads\resultados.txt"
    df.to_csv(output_path, index=False, sep="\t")

    logging.info("Resultados guardados en '{output_path}'.")
    print(f"Resultados guardados en '{output_path}'.")
 
except shodan.APIError as e:
    logging.error("Error con la API Shodan: {e}")
    print("Error: {e}")
except Exeption as e:
    logging.error("Error inesperado: {e}")
    print("Error inesperado")
