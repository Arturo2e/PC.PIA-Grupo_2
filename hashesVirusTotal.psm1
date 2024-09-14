param(
    [Parameter(Mandatory)][string]$directorio
)

$apikey = "28a9486807f8affe3d3def697dfabf726b687a6cd71b6027ed230baa104959a7"
$urlVirusTotal = "https://www.virustotal.com/api/v3/files"

$files = Get-ChildItem -Path $directorio 
$results = @()

foreach ($file in $files) {
    $fileHash = (Get-FileHash -Path $file.FullName).Hash
    $url = "$urlVirusTotal/$fileHash"
    $headers = @{
        "x-apikey" = $apikey
    }

    try {
        $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers
        $results += [pscustomobject]@{
            FileName = $file.Name
            FileHash = $fileHash
            Response = $response
        }
    } catch {
        Write-Warning "Failed to get data for file $($file.Name) with hash $fileHash : $_"
    }
}


$results | ConvertTo-Json -Depth 5
