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
$backupFolder = "C:\QlikBackup" 
Function LogWrite {
    Param ([string]$logstring)
    $Stamp = (Get-Date).toString("yyyy-MM-dd HH:mm:ss")
    Add-content "AppsToPurge.log" -value "$Stamp $logstring"
}

Connect-Qlik ## check https://github.com/ahaydon/Qlik-Cli for details

Push-Location("$env:ProgramData\Qlik\Sense\Log")

foreach ($app in (Import-Csv AppsToPurge.txt) ) {
    LogWrite "[$($app.AppId)] - $($app.'App Name') - marked for deletion"
    $filter = "id eq $($app.AppId)"
    if ($qvf = Get-QlikApp -filter $filter -full ) {
        LogWrite "[$($app.AppId)] - $($app.'App Name') - Creating $backupFolder\$($qvf.owner.userId)"
        New-Item -ItemType Directory -Force -Path "$backupFolder\$($qvf.owner.userId)"
        LogWrite "[$($app.AppId)] - $($app.'App Name') - Dumping a copy of [$($app.AppId)]"
        Export-QlikApp -id $qvf.id -filename "$($backupFolder)\$($qvf.owner.userId)\$($qvf.name).qvf" 
        LogWrite "[$($app.AppId)] - $($app.'App Name') - Removing the app"
        Remove-QlikApp -id $qvf.id
    }
    else {
        LogWrite "[$($app.AppId)] - $($app.'App Name') - does not exist in server, skipped"
    } 
}

Pop-Location
