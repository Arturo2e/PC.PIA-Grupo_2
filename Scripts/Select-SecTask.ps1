function Select-SecTask {
    <#
    .DESCRIPCION
    Muestra un menú en dónde se da a elegir 4 tareas que son realizadas 
    mediante el llamado de funciones pertenecientes a modulos. 
    Las tareas que realiza son obtener y leer hashes de archivos, 
    mostrar en forma de lista los archivos ocultos en el directorio actual,
    muestra los recursos del sistema que se encuentran en uso con el objetivo de 
    observar anomalias, y obtener y mostrar los programas que están instalados en el equipo
    con el objetivo de encontrar anomalias en la autorizacion de instalacion de programas 
    sin conocimiento del propietario del equipo.

    .SINOPSIS
    Selecciona y realiza una de las siguientes 4 tareas.
    #>

    #Establecimiento del modo estricto en la version actual de PS
    Set-StrictMode -Version $PSVersionTable.PSVersion

    #Importacion de los modulos de las 4 tareas
    Import-Module $HOME\Downloads\Function_ResourcesUsage.psm1 -Force
    Import-Module $HOME\Downloads\Modules\hashesVirusTotal.psm1 -Force
    Import-Module $HOME\Downloads\Modules\fun_arocultos.psm1 -Force
    Import-Module $HOME\Downloads\Modules\Funcion_Mostrar_Prog.psm1 -Force

    try {
        
        #Menú principal
        Write-Host "¿Que tarea desea hacer? 
        [1] Revisar hashes de archivos. 
        [2] Listar archivos ocultos de la carpeta actual. 
        [3] Revisar los recursos en uso del sistema. 
        [4] Obtener programas instalados en la computadora"
        
        [int]$Tarea = Read-Host -Prompt "Tarea"

        switch ($Tarea) {
            1 {
              Show-HashFile
            }
            
            2 {
                
                Save-HiddenFiles
                break
            }
            
            3 {
                #Menu que muestra las opciones 
                Write-Host "¿Que desea hacer?
                [1] Obtener la memoria en uso.
                [2] Obtener la cantidad de disco en uso.
                [3] Obtener la cantidad de CPU en uso.
                [4] Obtener la red en uso.
                [5] Realizar todo lo anterior."
                
                #Captura el error en caso de que el valor ingresado no sea entero.
                try {
                    [int]$Op_RescUsg = Read-Host -Prompt "Opción"
                }
                
                catch {
                    $_.Exception.Message
                }
                
                switch ($Op_RescUsg) {
                    1 {
                        #Obtiene la memoria en uso
                        Get-MemoryUsage
                        break
                      }
                    
                    2 {
                        #Obtiene el disco en uso.
                        Get-DiskUsage
                        break
                      }
                    
                    3 {
                        #Obtiene la cantidad de procesador en uso.
                        Get-ProcessorUsage
                        break
                      }
                    
                    4 {
                        #Obtiene la red en uso.
                        Get-NetworkUsage
                        break
                      }
                    
                    5 {
                        #Realiza todo a la vez.
                        Get-MainFunction
                        break
                      }
                }
                
                break
            }
            
            4 {
                Get-InstProgm
                break
            
            }
            
            default {
                Write-Host "Opción ingresada no válida, por favor ingrese una opción del menú de nuevo."
            }
        }

    }
    
    catch {
        $_.Exception.Message
    }
    
}
