# Main.py
from SHODAN_QUERY import consulta_shodan as shodan
from API_AbuseIPDB import main as mainAbuse
from passwords_management import main as mainpass
from LocalNetFw_PS import menu_netfw as netfw
from verificar_urls import verificar_urls  
import logging

# Configuración del logger
logger = logging.getLogger('scriptp')
logger.setLevel(logging.INFO)

file_handler = logging.FileHandler('scriptp.log')
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
file_handler.setFormatter(formatter)
logger.addHandler(file_handler)

def menu():
    print("\nMenu Principal")
    print("1.- Consulta de servidor Shodan.")
    print("2.- API AbuseIPDB.")
    print("3.- Consulta y generación de contraseña segura.") 
    print("4.- Gestión de firewall de red.")
    print("5.- Verificar URLs en URLhaus.")
    print("6.- Salir ")
    

def opciones(opcion):
    if opcion == "1":
        logger.info("\nOpción seleccionada: Consulta del servidor Shodan.")
        shodan()
    elif opcion == "2":
        logger.info("\nOpción seleccionada: API AbuseIPDB.")
        mainAbuse()
    elif opcion == "3":
        logger.info("\nOpción seleccionada: Consulta y generación de contraseñas.")
        mainpass()
    elif opcion == "4":
        logger.info("\nOpción seleccionada: Gestión de firewall de red.")
        netfw()
    elif opcion == "5":
        logger.info("\nOpción seleccionada: Verificar URLs en URLhaus.")
        verificar_urls()  # Llama a la función de verificación de URLs
    elif opcion == "6":
        logger.info("Saliendo del programa...")
        print("Saliendo del programa...")
        return False
    else:
        logger.warning("Opción no válida seleccionada.")
        print("Opción no válida. Intente de nuevo.")
    return True

def main():
    logger.info("Inicio del programa.")
    continuar = True
    while continuar:
        try:
            menu()
            opcion = input("Seleccione una opción: ")
            continuar = opciones(opcion)
        except KeyboardInterrupt:
            logger.warning("El usuario interrumpió el programa.")
            print("\nPrograma interrumpido por el usuario.")
            break
        except Exception as e:
            logger.error(f"Ocurrió un error en el ciclo principal: {e}")
            print("Se produjo un error. Por favor, inténtalo de nuevo.")
    logger.info("Programa finalizado.")    

if __name__ == "__main__":
    main()
