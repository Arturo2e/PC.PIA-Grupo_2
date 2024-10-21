import requests

def verificar_url(url):
    urlhaus_api = f'https://urlhaus-api.abuse.ch/v1/url/{url}'
    response = requests.get(urlhaus_api)
    
    if response.status_code == 200:
        data = response.json()
        if data['query_status'] == 'ok':
            return data['url_info']
        else:
            print(f'No se encontró información para la URL: {url}')
            return None
    else:
        print(f'Error al consultar la API: {response.status_code}')
        return None

def main():
    urls_a_verificar = [
        'http://example1.com',
        'http://example2.com',
        # Añade aquí más URLs para verificar
    ]
    
    for url in urls_a_verificar:
        resultado = verificar_url(url)
        if resultado:
            if resultado['url_status'] == 'malicious':
                print(f"La URL '{url}' ha sido reportada como maliciosa.")
            else:
                print(f"La URL '{url}' es segura.")
        else:
            print(f"No se pudo verificar la URL: {url}")

if __name__ == "__main__":
    main()
