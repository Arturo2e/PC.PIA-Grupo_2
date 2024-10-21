# Main.py
from SHODAN_QUERY import consulta_shodan as shodan
from API_AbuseIPDB import main as mainAbuse
from passwords_management import main as mainpass
from LocalNetFw_PS import menu_netfw as netfw
import logging
#import

logger = logging.getLogger('scriptp')
logger.setLevel(logging.INFO)

file_handler = logging.FileHandler('scriptp.log')

formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
file_handler.setFormatter(formatter)

logger.addHandler(file_handler)

def menu():
    print(f"\nMenu Principal")
    print("1.- Consulta de servidor Shodan.")
    print("2.- Api AbuseIPDB.")
    print("3.- Consulta y generacion de contraseña segura.") 
    print("4.- Gestión de firewall de red.")
    print("5.- Quinto modulo")
    print("6.- Salir")

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
        logger.info("\nOpción seleccionada: Quinto modulo.")
        pass
    elif opcion == "6":
        logger.info("Saliendo del programa...")
        print("Saliendo del programa...")
        return False
    else:
        logger.warning("Opción no valida seleccionada.")
        print("Opción no valida. Intente de nuevo.")
    return True

def main():
    logger.info("Inicio del programa.")
    continuar = True
    while continuar:
        try:
            menu()
            opcion = input("Seleccione una opcion: ")
            continuar = opciones(opcion)
        except KeyboardInterrupt:
            logger.warning("El usuario interrumpió el programa.")
            print("\nPrograma interrumpido por el usuario.")
            break
        except Exception as e:
            logger.error(f"Ocurrió un error en el ciclo principal: {e}")
            print("Se produjo un error. Por favor, intentálo de nuevo.")
    logger.info("Programa finalizado.")    

if __name__ == "__main__":
    main()
