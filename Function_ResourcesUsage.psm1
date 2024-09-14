function Get-MemoryUsage {
  Get-Process | Select-Object -Property Id, Name, @{
    Name = 'Cantidad de memoria'
    Expression = {"$($_.WorkingSet / 1MB) MB"}
  }
}

function Get-DiskUsage {
  Get-Volume | 
    Select-Object -Property `
        DriveLetter, 
        @{Name='Almacenamiento';Expression={$_.Size / 1GB | ForEach-Object { "{0:F2} GB" -f $_ }}},
        @{Name='Almacenamiento restante';Expression={$_.SizeRemaining / 1GB | ForEach-Object { "{0:F2} GB" -f $_ }}} | 
    Format-Table -AutoSize
}

function Get-ProcessorUsage {
  Get-Process | Select-Object -Property ProcessName, CPU
}

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

function Get-MainFunction {
	Get-MemoryUsage
	Start-Sleep -s 7
	Get-DiskUsage
	Start-Sleep -s 7
	Get-ProcessorUsage
	Start-Sleep -s 7
	Get-NetworkUsage
}