#Función que hace el listado de archivos ocultos y los guarda en un la carpeta "Archivos ocultos"

<#
.SYNOPSIS
Hace un listado de los archivos ocultos que se encontraron en el directorio que fue ingresado por el usuario

.DESCRIPTION
La función “Save-HiddenFiles” Obtiene la lista de todos los archivos ocultos que se encontraron en el directorio que ingreso el usuario, guarda el listado en un archivo txt el cual se guarda en la carpeta “Archivos Ocultos” que se genera en el directorio que se ingresó por el usuario 

.EXAMPLE 
Save-Hiddenfiles 
Archivos ocultos son aquellos que no se encuentran fácilmente en el sistema C:/Windows/System32 la carpeta System32 en esa carpeta para ver los archivos se requiere un permiso de administrador  

.NOTES
-La función recibe como parámetro un string que contiene el directorio en el que se buscarán los archivos ocultos 
-Se verifica que el directorio ingresado exista, en caso de que no retorna un mensaje para el usuario 
-Se crea la carpeta “Archivos ocultos” donde se guardará el txt con el listado de los archivos ocultos encontrados 
-En caso de haber encontrado archivos devuelve un mensaje con la dirección donde se generó la carpeta y el nombre del archivo, en caso contrario se devuelve un mensaje donde se menciona que no se encontraron archivos ocultos 
#>

function Save-HiddenFiles {
	param(
		[string] $directorio
	)

	#Primero revisamos que existe el directorio que ingreso el usuario
	if (-Not (Test-Path -Path $directorio -PathType Container)){
		Write-Error "El directorio $directorio no existe"
		return
	}

	#Aquí se crea la carpeta donde se guardaran los archivos ocultos en caso de que no exista aun 
	$carpeta = Join-Path -Path $directorio -ChildPath "Archivos Ocultos"
	if (-Not (Test-Path -Path $carpeta)) {
		New-Item -Path $carpeta -ItemType Directory | Out-Null
	}

	#Se guarda el listado de los archivos ocultos 
	$archivosocultos = Get-ChildItem -Path $directorio -File -Force | Where-Object { $_.Attributes -match "Hidden" }

	#Se crea el archivo donde se guardara el listado
	$archivolistado = Join-Path -Path $carpeta -ChildPath "LisArchivosOcultos.txt"


	#Si no hay archivos ocultos en el directorio actual, se devuelve un mensaje al usuario
	if ($archivosocultos.Count -eq 0) {
		Write-Output "No hay archivos ocultos"

	} else {
		$archivosocultos | ForEach-Object { $_.Name } | Out-File -FilePath $archivolistado
		Write-Output "Los archivos ocultos se han guardado en $archivolistado" 
	}
}
