import shodan,sys
import pandas as pd
 
api_key =input("Ingrese su API key")
shodan_api = shodan.Shodan(api_key)
#ejemplos de ejecucion apache,apache country:US,"OpenSSH 7.4" port:22, port:554 has_screenshot:true)
query=input("Ingrese la consulta de busqueda para Shodan: ").strip()
if not query:
    print("Ingrese una consulta valida")
    sys.exit(1)
 
try:
    results = shodan_api.search(query)
    print("Resultados encontrados: {}".format(results['total']))
 
    data_list=[]
 
    for result in results["matches"]:
        ip = result.get('ip_str', 'No IP found')
        data=result.get("data", "No existe ningun dato")
        data_list.append({"IP": ip, "data": data})
   
    df= pd.DataFrame(data_list)
#De ser neceseario cambiar la ubicacion de los resultados,modifique la direccion de la carpeta Downloads
    df.to_csv(r"C:\Users\Dell\Downloads\resultados.txt", index=False, sep="\t")
 
    print("Resultados guardados en 'resultados.txt'.")
 
except shodan.APIError as e:
    print("Error: {}".format(e))
