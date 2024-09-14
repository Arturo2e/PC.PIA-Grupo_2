function Get-InstProgm {
	#Código para mostrar programas instalados en la computadora
	$installed = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |  	Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
	$installed += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
	$installed | ?{ $_.DisplayName -ne $null } | sort-object -Property DisplayName -Unique | 	Format-Table -AutoSize
}