param(
    [Parameter(Mandatory)][string]$directorio
)

$apikey = <#agregue su apikey personal#>
$urlVirusTotal = "https://www.virustotal.com/api/v3/files"
<# 
.NAME
    Get-ChildItem

SINTAXIS
    Get-ChildItem [[-Path] <string[]>] [[-Filter] <string>]  [<CommonParameters>]

    Get-ChildItem [[-Filter] <string>]  [<CommonParameters>]


ALIAS
    gci
    ls
    dir


NOTAS
    Get-Help no encuentra los archivos de Ayuda para este cmdlet en el equipo. Mostrará solo una parte de la Ayuda.
        -- Para descargar e instalar los archivos de Ayuda para el módulo que incluye este cmdlet, use Update-Help.
        -- Para ver en línea el tema de Ayuda de este cmdlet, escriba "Get-Help Get-ChildItem -Online" o
           vaya a https://go.microsoft.com/fwlink/?LinkID=113308. #>
$files = Get-ChildItem -Path $directorio 
$results = @()
<# NOMBRE
    Get-FileHash

SINOPSIS
    Computes the hash value for a file by using a specified hash algorithm.


SINTAXIS
    Get-FileHash [-Algorithm {SHA1 | SHA256 | SHA384 | SHA512 | MACTripleDES | MD5 | RIPEMD160}] -InputStream <System.IO.Stream> [<CommonParameters>]

    Get-FileHash [-Algorithm {SHA1 | SHA256 | SHA384 | SHA512 | MACTripleDES | MD5 | RIPEMD160}] -LiteralPath <System.String[]> [<CommonParameters>]

    Get-FileHash [-Path] <System.String[]> [-Algorithm {SHA1 | SHA256 | SHA384 | SHA512 | MACTripleDES | MD5 | RIPEMD160}] [<CommonParameters>]


DESCRIPCIÓN
    The `Get-FileHash` cmdlet computes the hash value for a file by using a specified hash algorithm. A hash value is a unique value that corresponds to the content of
    the file. Rather than identifying the contents of a file by its file name, extension, or other designation, a hash assigns a unique value to the contents of a file.
    File names and extensions can be changed without altering the content of the file, and without changing the hash value. Similarly, the file's content can be changed
    without changing the name or extension. However, changing even a single character in the contents of a file changes the hash value of the file.

    The purpose of hash values is to provide a cryptographically-secure way to verify that the contents of a file have not been changed. While some hash algorithms,
    including MD5 and SHA1, are no longer considered secure against attack, the goal of a secure hash algorithm is to render it impossible to change the contents of a
    file -- either by accident, or by malicious or unauthorized attempt -- and maintain the same hash value. You can also use hash values to determine if two different
    files have exactly the same content. If the hash values of two files are identical, the contents of the files are also identical.

    By default, the `Get-FileHash` cmdlet uses the SHA256 algorithm, although any hash algorithm that is supported by the target operating system can be used.


VÍNCULOS RELACIONADOS
    Online Version: https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/get-filehash?view=powershell-5.1&WT.mc_id=ps-gethelp
    Format-List

NOTAS
    Para ver los ejemplos, escriba: "get-help Get-FileHash -examples".
    Para obtener más información, escriba: "get-help Get-FileHash -detailed".
    Para obtener información técnica, escriba: "get-help Get-FileHash -full".
    Para obtener ayuda disponible en línea, escriba: "get-help Get-FileHash -online" #>
foreach ($file in $files) {
    $fileHash = (Get-FileHash -Path $file.FullName).Hash
    $url = "$urlVirusTotal/$fileHash"
    $headers = @{
        "x-apikey" = $apikey
    }
<# NOMBRE
    Invoke-RestMethod

SINOPSIS
    Sends an HTTP or HTTPS request to a RESTful web service.


SINTAXIS
    Invoke-RestMethod [-Uri] <System.Uri> [-Body <System.Object>] [-Certificate <System.Security.Cryptography.X509Certificates.X509Certificate>] [-CertificateThumbprint
    <System.String>] [-ContentType <System.String>] [-Credential <System.Management.Automation.PSCredential>] [-DisableKeepAlive] [-Headers
    <System.Collections.IDictionary>] [-InFile <System.String>] [-MaximumRedirection <System.Int32>] [-Method {Default | Get | Head | Post | Put | Delete | Trace |
    Options | Merge | Patch}] [-OutFile <System.String>] [-PassThru] [-Proxy <System.Uri>] [-ProxyCredential <System.Management.Automation.PSCredential>]
    [-ProxyUseDefaultCredentials] [-SessionVariable <System.String>] [-TimeoutSec <System.Int32>] [-TransferEncoding {chunked | compress | deflate | gzip | identity}]
    [-UseBasicParsing] [-UseDefaultCredentials] [-UserAgent <System.String>] [-WebSession <Microsoft.PowerShell.Commands.WebRequestSession>] [<CommonParameters>]


DESCRIPCIÓN
    The `Invoke-RestMethod` cmdlet sends HTTP and HTTPS requests to Representational State Transfer (REST) web services that return richly structured data.

    PowerShell formats the response based to the data type. For an RSS or ATOM feed, PowerShell returns the Item or Entry XML nodes. For JavaScript Object Notation (JSON)
    or XML, PowerShell converts, or deserializes, the content into `[PSCustomObject]` objects.

    > [!NOTE] > When the REST endpoint returns multiple objects, the objects are received as an array. If you pipe > the output from `Invoke-RestMethod` to another
    command, it is sent as a single `[Object[]]` > object. The contents of that array are not enumerated for the next command on the pipeline.

    This cmdlet is introduced in Windows PowerShell 3.0.

    > [!NOTE] > By default, script code in the web page may be run when the page is being parsed to populate the > `ParsedHtml` property. Use the UseBasicParsing switch
    to suppress this.


VÍNCULOS RELACIONADOS
    Online Version: https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-5.1&WT.mc_id=ps-gethelp
    ConvertTo-Json
    ConvertFrom-Json
    Invoke-WebRequest

NOTAS
    Para ver los ejemplos, escriba: "get-help Invoke-RestMethod -examples".
    Para obtener más información, escriba: "get-help Invoke-RestMethod -detailed".
    Para obtener información técnica, escriba: "get-help Invoke-RestMethod -full".
    Para obtener ayuda disponible en línea, escriba: "get-help Invoke-RestMethod -online" #>
    try {
        $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers
        $results += [pscustomobject]@{
            FileName = $file.Name
            FileHash = $fileHash
            Response = $response
        }
    } catch {
<# NOMBRE
    Write-Warning

SINOPSIS
    Writes a warning message.


SINTAXIS
    Write-Warning [-Message] <System.String> [<CommonParameters>]


DESCRIPCIÓN
    The `Write-Warning` cmdlet writes a warning message to the PowerShell host. The response to the warning depends on the value of the user's `$WarningPreference`
    variable and the use of the WarningAction common parameter.


VÍNCULOS RELACIONADOS
    Online Version: https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/write-warning?view=powershell-5.1&WT.mc_id=ps-gethelp
    about_Output_Streams
    about_Redirection
    Write-Debug
    Write-Error
    Write-Host
    Write-Information
    Write-Output
    Write-Progress
    Write-Verbose

NOTAS
    Para ver los ejemplos, escriba: "get-help Write-Warning -examples".
    Para obtener más información, escriba: "get-help Write-Warning -detailed".
    Para obtener información técnica, escriba: "get-help Write-Warning -full".
    Para obtener ayuda disponible en línea, escriba: "get-help Write-Warning -online" #>
        Write-Warning "Failed to get data for file $($file.Name) with hash $fileHash : $_"
    }
}

<# NOMBRE
    ConvertTo-Json

SINOPSIS
    Converts an object to a JSON-formatted string.


SINTAXIS
    ConvertTo-Json [-InputObject] <System.Object> [-Compress] [-Depth <System.Int32>] [<CommonParameters>]


DESCRIPCIÓN
    The `ConvertTo-Json` cmdlet converts any .NET object to a string in JavaScript Object Notation (JSON) format. The properties are converted to field names, the field
    values are converted to property values, and the methods are removed.

    You can then use the `ConvertFrom-Json` cmdlet to convert a JSON-formatted string to a JSON object, which is easily managed in PowerShell.

    Many web sites use JSON instead of XML to serialize data for communication between servers and web-based apps.

    This cmdlet was introduced in Windows PowerShell 3.0.


VÍNCULOS RELACIONADOS
    Online Version: https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/convertto-json?view=powershell-5.1&WT.mc_id=ps-gethelp
    An Introduction to JavaScript Object Notation (JSON) in JavaScript and .NET
    ConvertFrom-Json
    Get-Content
    Get-UICulture
    Invoke-WebRequest
    Invoke-RestMethod

NOTAS
    Para ver los ejemplos, escriba: "get-help ConvertTo-Json -examples".
    Para obtener más información, escriba: "get-help ConvertTo-Json -detailed".
    Para obtener información técnica, escriba: "get-help ConvertTo-Json -full".
    Para obtener ayuda disponible en línea, escriba: "get-help ConvertTo-Json -online" #>
$results | ConvertTo-Json -Depth 5
