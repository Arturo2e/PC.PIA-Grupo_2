import secrets
import string
import re
from datetime import datetime
import os  

def generar_contraseña(longitud):
    """
    Genera una contraseña aleatoria de una longitud específica.

    Parámetros:
    longitud (int): La longitud deseada de la contraseña (mínimo 8).

    Retorna:
    str: Una contraseña aleatoria compuesta de letras, números y símbolos especiales.
    """
    caracteres = string.ascii_letters + string.digits + string.punctuation
    contraseña = ''.join(secrets.choice(caracteres) for _ in range(longitud))
    return contraseña

def validar_contraseña(contraseña):
    """
    Valida una contraseña según ciertos criterios de seguridad.

    Parámetros:
    contraseña (str): La contraseña a validar.

    Retorna:
    str: Un mensaje que indica si la contraseña es segura o no, junto con los requisitos no cumplidos.
    """
    if len(contraseña) < 8:
        return "Insegura. La contraseña debe tener al menos 8 caracteres. Inténtelo de nuevo."
    if not re.search(r'[A-Z]', contraseña):
        return "Insegura. La contraseña debe contener al menos una letra mayúscula. Inténtelo de nuevo."
    if not re.search(r'[0-9]', contraseña):
        return "Insegura. La contraseña debe contener al menos un número. Inténtelo de nuevo."
    if not re.search(r'[!@#$%^&*()_+]', contraseña):
        return "Débil. Debe contener al menos un símbolo especial (Ej. !@#$%^&*()_+). Inténtelo de nuevo."
    return "La contraseña es segura."

def guardar_contraseñas(contraseñas):
    """
    Guarda las contraseñas generadas en un archivo de texto en la carpeta de Descargas.

    Parámetros:
    contraseñas (list): Lista de contraseñas a guardar.
    """
    ruta_descargas = os.path.join(os.path.expanduser("~"), "Downloads", "passwords.txt")
    
    fecha_hora = datetime.now().strftime("%Y-%m-%d %H:%M:%S")  # Obtener la fecha y hora una sola vez
    with open(ruta_descargas, "a") as f:
        for contraseña in contraseñas:
            f.write(f"{fecha_hora}\nPassword => {contraseña}\n")  # Guardar solo una fecha y hora por sesión
        f.write("\n")  # Agregar un salto de línea adicional después de todas las contraseñas
    print(f"Contraseñas guardadas en '{ruta_descargas}'.")

def mostrar_menu():
    """
    Muestra el menú principal de la herramienta de gestión de contraseñas.
    """
    print("\n--- Menú de Gestor de Contraseñas ---")
    print("1. Generar una contraseña segura")
    print("2. Generar múltiples contraseñas")
    print("3. Verificar si una contraseña es segura")
    print("4. Salir")

def main():
    """
    Función principal que controla el flujo del programa, permitiendo al usuario interactuar con el gestor de contraseñas.
    """
    while True:
        mostrar_menu()
        opcion = input("Selecciona una opción (1-4): ")

        if opcion == '1':
            while True:
                try:
                    longitud = int(input("Ingresa la longitud de la contraseña (mínimo 8): "))
                    if longitud < 8:
                        raise ValueError("La longitud debe ser al menos 8. Inténtelo de nuevo.")
                    contraseña = generar_contraseña(longitud)
                    print("Contraseña generada:", contraseña)
                    
                    guardar = input("¿Desea guardar esta contraseña? Si [1] No [2]: ")
                    if guardar == '1':
                        guardar_contraseñas([contraseña])
                    break  

                except ValueError as e:
                    print(f"Error: {e}")

        elif opcion == '2':
            while True:
                try:
                    num_contraseñas = int(input("¿Cuántas contraseñas desea generar? (entre 2 y 50): "))
                    if num_contraseñas < 2 or num_contraseñas > 50:
                        raise ValueError("Debes elegir un número entre 2 y 50. Inténtelo de nuevo.")
                    
                    contraseñas = [generar_contraseña(12) for _ in range(num_contraseñas)]
                    print("Contraseñas generadas:")
                    for c in contraseñas:
                        print(c)
                    
                    guardar = input("¿Desea guardar estas contraseñas? Si [1] No [2]: ")
                    if guardar == '1':
                        guardar_contraseñas(contraseñas)
                    break  

                except ValueError as e:
                    print(f"Error: {e}")

        elif opcion == '3':
            while True:
                contraseña = input("Ingresa la contraseña a verificar: ")
                mensaje = validar_contraseña(contraseña)
                print(mensaje)
                break  

        elif opcion == '4':
            print("Saliendo de la herramienta Gestor de Contraseñas...")
            break

        else:
            print("Opción no válida. Intenta de nuevo.")

if __name__ == "__main__":
    main()
