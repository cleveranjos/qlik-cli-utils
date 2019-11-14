<#
MIT License

Copyright (c) 2018 Clever dos Anjos

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

#>

$folder = "c:\dump"

Connect-Qlik|Out-Null ## check https://github.com/ahaydon/Qlik-Cli for details
$streams = Get-QlikStream -full
$streams | Export-Csv -Path $folder\streams.csv
foreach($stream in $streams) {
    $streamfolder = $stream.name
    if (-not (Test-Path -LiteralPath "$folder\$streamfolder")) {
        Write-Host "Creating $($streamfolder)"
        New-Item -ItemType Directory -Force -Path "$folder\$streamfolder" | Out-Null 
    }
    $streamfolder
    foreach($qvf in Get-QlikApp -full -filter "Published eq true and stream.name eq '$($streamfolder)' ") {  
        if (-not (Test-Path -LiteralPath "$folder\$streamfolder\$($qvf.name).qvf")) {
            Write-Host "Exporting $($qvf.name) with $($qvf.fileSize) bytes"
            Try {
                Export-QlikApp -id $qvf.id -filename "$($folder)\$($streamfolder)\$($qvf.name).qvf" | Out-Null #dumps the qvf
            } finally { 
            
            } 
        } else {
            Write-Host "Skipping $($folder)\$streamfolder\$($qvf.name).qvf"
        } 
    }
}



## End of file
