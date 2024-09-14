#Funcion que nos ayuda a revisar el uso de memoria, esta misma despliega el ID, Nombre y cantidad de memoria utilizada
function Get-MemoryUsage {
  Get-Process | Select-Object -Property Id, Name, @{
    Name = 'Cantidad de memoria'
    Expression = {"$($_.WorkingSet / 1MB) MB"}
  }
}

#Funcion que nos ayuda a revisar el uso del disco local, con su nombre, almacenamiento y almacenamiento restante en GB
function Get-DiskUsage {
  Get-Volume | 
    Select-Object -Property `
        DriveLetter, 
        @{Name='Almacenamiento';Expression={$_.Size / 1GB | ForEach-Object { "{0:F2} GB" -f $_ }}},
        @{Name='Almacenamiento restante';Expression={$_.SizeRemaining / 1GB | ForEach-Object { "{0:F2} GB" -f $_ }}} | 
    Format-Table -AutoSize
}

#Funcion que nos ayuda a revisar el uso del procesador, despliega la aplicacion y la utilidad de CPU
function Get-ProcessorUsage {
  Get-Process | Select-Object -Property ProcessName, CPU
}

#Funcion que nos ayuda a revisar el uso de red, misma que despliega el nombre, los bytes enviados y recibidos en MB, estos mismos 
redondeados a dos decimales con funciones que ya conociamos mas o menos de Python, esto para que sea mas agradable de leer para el usuario.
function Get-NetworkUsage {
  $network = Get-WmiObject Win32_PerfFormattedData_Tcpip_NetworkInterface
  foreach ($net in $network) {
    $bytesSentPs = [math]::Round($net.BytesSentPersec / 1MB, 1)
    $bytesReceivedPs = [math]::Round($net.BytesReceivedPersec / 1MB, 1)
    Write-Host "Nombre: $($net.Name)"
    Write-Host "Bytes Enviados: $bytesSentPs MB"
    Write-Host "Bytes Recibidos: $bytesReceivedPs MB"`n
  }
}

#Funcion principal, esta misma llama a todas las demas funciones, ademas Start-Sleep nos ayuda a implementar un delay de 7 segundos entre llamado
para que asi las funciones puedan terminar de ejecutarse por completo 
function Get-MainFunction {
	Get-MemoryUsage
	Start-Sleep -s 7
	Get-DiskUsage
	Start-Sleep -s 7
	Get-ProcessorUsage
	Start-Sleep -s 7
	Get-NetworkUsage
}

