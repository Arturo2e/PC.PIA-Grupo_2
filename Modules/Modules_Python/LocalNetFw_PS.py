import subprocess

__name__ = "__locNetFw_PS__"

# Lista de los comandos que se ejecutan
Command = ["Get-NetFirewallRule",\
      ["Rename-NetFirewallRule", "Disable-NetFirewallRule", "Enable-NetFirewallRule", "Remove-NetFirewallRule", "Set-NetFirewallRule", "Copy-NetFirewallRule"], \
      "Get-NetFirewallSetting", "Get-NetFirewallProfile", "Get-NetFirewallPortFilter", "Get-NetFirewallAddressFilter", \
        "Set-FirewallSetting", "Set-NetFirewallProfile", "Set-NetFirewallPortFilter", "Set-NetFirewallAddressFilter"]

# Toma como argumento un comando de PowerShell y lo ejecuta.
# El comando puede contener parametros en los que se le pide al usuario \
# el argumento correspondiente. Por ejemplo, vea la linea 35
def run_command(Command : str):
    cli_line = "PowerShell -ExecutionPolicy ByPass -Command " + str(Command)
    cmd_output = subprocess.check_output(cli_line, text=True)
    return cmd_output

# Muestra un menú de acciones y cuando se ingresa la accion \ 
# esta funcion ejecuta el comando especificado en el argumento de 'run_command()'
def mod_rule(desc_op : str):
    while (True):
        print("¿Qué desea hacer con las reglas mostradas? (Ingrese una acción)")
        print("*************************")
        print("-> Renombrar ó 'Ren'")
        print("-> Deshabilitar ó 'D'")
        print("-> Habilitar ó 'H'")
        print("-> Remover ó 'Rem'")
        print("-> Copiar ó 'C'")
        print("-> Volver ó 'V'")
        print("*************************")
        desc_op = input("Accion: ")

        if (desc_op == "Renombrar" or desc_op == "Ren"):
            name = str(input("Nombre: "))
            new_name = str(input("Nuevo_nombre: "))
            run_command(Command[1][0] + f" -Name {name} " + f" -NewName {new_name} " )
        
        elif (desc_op == "Deshabilitar" or desc_op == "D"):
            name = str(input("Nombre: "))
            run_command(Command[1][1] + f" -Name {name} ")
        
        elif (desc_op == "Habilitar" or desc_op == "H"):
            name = str(input("Nombre: "))
            run_command(Command[1][2] + f" -Name {name} ")
        
        elif (desc_op == "Remover" or desc_op == "Rem"):
            name = str(input("Nombre: "))
            run_command(Command[1][3] + f" -Name {name} ")

        elif (desc_op == "Copiar" or desc_op == "C"):
            name = str(input("Nombre: "))
            copy_name = str(input("Nombre_de_la_copia: "))
            run_command(Command[1][5] + f" -Name {name} " + f"-NewName {copy_name} ")

        elif (desc_op == "Volver" or desc_op == "V"):
            break

        else:
            print("Acción ingresada no encontrada. Ingrese una accion del menú.")
            continue

        print("Modificación realizada con éxito.")

# Si la respuesta es o 'Si' o 'S' entonces la funcion ejecuta el comando 'Set-NetFirewallRule'
def set_rule(desc_op = "No"):
    desc_op = str(input("¿Desea establecer una nueva regla? (Si/No): "))
    if (desc_op == "Si" or desc_op == 'S'):
        name = str(input("Nombre:  "))
        action = str(input("Accion (Allow/Block): "))
        protocol = str(input("Protocolo (TCP/UDP/ICMPv4/ICMPv6): "))
        profile = str(input("Perfil (Any/Domain/Private/Public/NotApplicable): "))
        run_command(Command[1][4] + f" -Name {name} " + f"-Action {action} " + f"-Protocol {protocol} " + f"-Profile {profile} ")

# Guarda la salida del comando ejecutado en la funcion 'run_command()' en un archivo de texto plano
def save_in_file(file : str, subject : str, output : str, desc = "No"):
    desc = str(input(f"¿Desea guardar {str(subject)} en un archivo? (Si/No):  "))
    if (desc == "Si" or desc == 'S'):
        rulefile = open(f"{file}.txt", "w")
        rulefile.write(str(output))
        rulefile.close()
        # Al ejecutar como administrador el script\
        # el archivo "Reglas_Firewall-de-Red.txt" \
        # se guardó en C:\Windows\System32   

def mod_task(subject, desc_op = "No"):
    desc_op = str(input(f"¿Desea modificar {subject}? (Si/No): "))
    if (desc_op == "Si" or desc_op == 'S'):
        if (subject == "la configuracion"):
            run_command(Command[6])
        
        elif (subject == "el perfil"):
            profile_name = str(input("Nombre_de_perfil: "))
            run_command(Command[7] + f" -Name {profile_name}")
        
        elif (task == 4):
            locport = str(input("Puerto_Local: "))
            remport = str(input("Puerto_Remoto: "))
            protocol = str(input("Protocolo: "))
            run_command(Command[8] + f" -LocalPort {locport} " + f"-Protocol {protocol} " + f"-RemotePort {remport} ")
        
        elif (task == 5):
            locaddrss = str(input("Dirección_Local: "))
            remadrss = str(input("Dirección_Remota: "))
            run_command(Command[9] + f" -LocalAddress {locaddrss} " + f"-RemoteAddress {remadrss}")
    
    print("Modificación realizada con éxito.")


# Ejecute el script en pantalla en la terminal \
# como administrador (En PowerShell.exe o CMD.exe)
def menu_netfw():
    while (True):
        try:
            print("--------------------------------Modulo_de_NetFirewall--------------------------------")
            print("¿Qué tarea desea realizar?")
            print("*************************************************************************************")
            print("[1] Mostrar las reglas definidas \
                        [4] Obtener el filtro de puertos")
            print("[2] Obtener la configuración global actual \
            [5] Obtener filtro de direcciones") 
            print("[3] Obtener la configuración de perfiles \
                [6] Salir")
            print("*************************************************************************************")

            task = int(input("Número_de_sub-tarea:  "))

            # Cada tarea muestra la salida del comando ejecutado \ 
            # y dan la opcion de guardar las salidas en un archivo
            if (task == 1):
                output = run_command(Command[0])
                print(output)
                save_in_file("Reglas_Firewall-de-Red", "las reglas", output)
                set_rule()
                mod_rule(desc_op = any)
                continue

            if (task == 2):
                output = run_command(Command[2])
                print(output)
                save_in_file("Configuracion_Firewall-de-Red", "la configuración", output)
                mod_task("la configuracion")
                continue

            if (task == 3):
                output = run_command(Command[3])
                print(output)
                save_in_file("Perfiles_Firewall-de-Red", "los perfiles", output)
                mod_task("el perfil")
                continue

            if (task == 4):
                output = run_command(Command[4])
                print(output)
                save_in_file("Filtros-de-Puertos_Firewall-de-Red", "los filtros", output)
                mod_task("los filtros")
                continue

            if (task == 5):
                output = run_command(Command[5])
                print(output)
                save_in_file("Filtro-de-Direcciones_Firewall-de-Red", "los filtros", output)
                mod_task("los filtros")
                continue

            elif (task == 6):
                print("Tarea finalizada con éxito.")
                exit()
                break

            else:
                print("Número de sub-tarea ingresado no válido. Ingrese un número del menú.")
                continue
            
        except ValueError: 
            print("Ingresaste una cadena o un valor de tipo flotante. Ingrese un valor del menú")
            continue

        except subprocess.CalledProcessError:
            print("Algo salió mal. Ejecute el script como administrador y vuelva a intertarlo.")
            exit()
            break

        except KeyboardInterrupt:
            print("El programa ha sido interrumpido por el usuario.")
            print("")
            continue

if (__name__ == "__locNetFw_PS__"):
    menu_netfw()
