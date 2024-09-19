<#
.SYNOPSIS
Obtiene la cantidad de memoria utilizada por cada proceso en el sistema.

.DESCRIPTION
Este cmdlet obtiene la lista de procesos en ejecución en el sistema y muestra la cantidad de memoria utilizada por cada proceso en megabytes (MB).

.PARAMETER None
No se requiere ningún parámetro para este cmdlet.

.EXAMPLE
Get-MemoryUsage
#>
function Get-MemoryUsage {
  Get-Process | Select-Object -Property Id, Name, @{ #Para cada ID y Nombre despliega la cantidad de memoria utilizada
    Name = 'Cantidad de memoria'
    Expression = {"$($_.WorkingSet / 1MB) MB"} #Utiliza el formato de redondeo para hacerlo mas amable a la vista del usuario
  }
}

<#
.SYNOPSIS
Obtiene la cantidad de disco local utilizado en el dispositivo.

.DESCRIPTION
Este cmdlet obtiene el uso de disco local en el dispositivo, imprime en pantalla el DriveLetter, su almacenamiento y almacenamiento restante en gigabytes (GB).

.PARAMETER None
No se requiere ningún parámetro para este cmdlet.

.EXAMPLE
Get-DiskUsage
#>
function Get-DiskUsage {
  Get-Volume | 
    Select-Object -Property `
        DriveLetter, 
        @{Name='Almacenamiento';Expression={$_.Size / 1GB | ForEach-Object { "{0:F2} GB" -f $_ }}},
        @{Name='Almacenamiento restante';Expression={$_.SizeRemaining / 1GB | ForEach-Object { "{0:F2} GB" -f $_ }}} | 
    Format-Table -AutoSize #Para cada disco, muestra su almacenamiento y restante redondeado, ademas se le da formato de tabla para acomodar los datos.
}

<#
.SYNOPSIS
Obtiene la lista de procesos en ejecución en el sistema y muestra el nombre del proceso y su uso de CPU.

.DESCRIPTION
Este cmdlet obtiene la lista de procesos en ejecución en el sistema y muestra el nombre del proceso y su uso de CPU.

.PARAMETER None
No se requiere ningún parámetro para este cmdlet.

.EXAMPLE
Get-ProcessorUsage
#>
function Get-ProcessorUsage {
  Get-Process | Select-Object -Property ProcessName, CPU #Para cada nombre de proceso, muestra la utilidad de CPU
}

<#
.SYNOPSIS
Obtiene la cantidad de bytes enviados y recibidos para la interfaz de red en el sistema.

.DESCRIPTION
Este cmdlet utiliza Win32_PerfFormattedData_Tcpip_NetworkInterface para obtener la cantidad de bytes enviados y recibidos por segundo para cada interfaz de red en el sistema. Los resultados se muestran en megabytes por segundo (MB/s).

.PARAMETER None
No se requiere ningún parámetro para este cmdlet.

.EXAMPLE
Get-NetworkUsage
#>
function Get-NetworkUsage {
  $network = Get-WmiObject Win32_PerfFormattedData_Tcpip_NetworkInterface
  foreach ($net in $network) {
    $bytesSentPs = [math]::Round($net.BytesSentPersec / 1MB, 1)
    $bytesReceivedPs = [math]::Round($net.BytesReceivedPersec / 1MB, 1)
    Write-Host "Nombre: $($net.Name)"
    Write-Host "Bytes Enviados: $bytesSentPs MB"
    Write-Host "Bytes Recibidos: $bytesReceivedPs MB"`n #Para cada interfaz de red, imprime su nombre, bytes enviados y recibidos en forma de redondeo.
  }
}

<#
.SYNOPSIS
Ejecuta una serie de cmdlets para obtener información del sistema, incluyendo el uso de memoria, disco, procesador y red.

.DESCRIPTION
Este cmdlet ejecuta los siguientes cmdlets en orden: Get-MemoryUsage, Get-DiskUsage, Get-ProcessorUsage y Get-NetworkUsage. Cada cmdlet se ejecuta con Start-Sleep de 7 segundos entre ellos para que logren terminar su proceso completamente.

.PARAMETER None
No se requiere ningún parámetro para este cmdlet.

.EXAMPLE
Get-MainFunction
#>
function Get-MainFunction {#El Start-Sleep de 7 segundos nos ayuda a tener un intervalo para dar tiempo a que las funciones terminen de ejecutarse correctamente
	Get-MemoryUsage
	Start-Sleep -s 7
	Get-DiskUsage
	Start-Sleep -s 7
	Get-ProcessorUsage
	Start-Sleep -s 7
	Get-NetworkUsage
}