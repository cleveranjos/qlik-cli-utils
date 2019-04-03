<#
MIT License
Copyright (c) 2019 Clever dos Anjos
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
 
$logfolder = "C:\QlikShare\ArchivedLogs\vmqliksense\Script"
$export_file = "C:\QlikShare\ArchivedLogs\list-app-conn- vmqliksense.csv"
[System.Collections.ArrayList]$apps_connections = @()
foreach ($log in Get-ChildItem -Path $logfolder -Filter *.log) {
    foreach ($line in Select-String -LiteralPath $log.FullName  -Pattern "\[lib:\/\/(.*)\/" -AllMatches | %{$_.matches.groups[1].Value} | Get-Unique) {
        $a = [PSCustomObject]@{
            App = $log.Name.split('.')[0]
            AppName = ""
            Stream = ""
            Connection = $line.split('/')[0]
            LogFile = $log.Name            
        }
        $apps_connections.Add($a)|Out-Null
    }
    foreach ($line in Select-String -LiteralPath $log.FullName  -Pattern "LIB CONNECT TO '(.*)'" -AllMatches | %{$_.matches.groups[1].Value} | Get-Unique) {
        $a = [PSCustomObject]@{
            App = $log.Name.split('.')[0]
            AppName = ""
            Stream = ""
            Connection = $line.split('/')[0]
            LogFile = $log.Name            
        }
        $apps_connections.Add($a)|Out-Null
    }
}
$apps_connections = $apps_connections | Sort-Object 
 
Connect-Qlik|Out-Null ## check https://github.com/ahaydon/Qlik-Cli for details
$tmp = ""
for ($i = 0; $i -lt $apps_connections.Count; $i++) {
    if ($tmp -ne $apps_connections[$i].App) {
        try {
            $a = Get-QlikApp -id $apps_connections[$i].App
            $tmp = $a.name
            $apps_connections[$i].AppName = $tmp
        } catch {}
    }
}
 
$apps_connections | Format-Table
$apps_connections | Export-Csv -Path $export_file -Delimiter ';' -NoTypeInformation
## End of file
