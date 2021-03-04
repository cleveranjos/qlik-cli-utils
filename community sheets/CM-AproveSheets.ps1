<#
MIT License
Copyright (c) 2021 Clever Anjos
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

# promoted sheets
$list = "c:\temp\list.csv"

#Connect-Qlik|Out-Null ## check https://github.com/ahaydon/Qlik-Cli for details
Get-PfxCertificate C:\Users\cuv\QlikMachineImages\shared-content\certificates\sense\client.pfx | Connect-Qlik `
-ComputerName sense -UserName INTERNAL\sa_api `
-TrustAllCerts | Out-Null

## logic to retrieve the sheets that should be promoted. Please adjust to your needs
$filter=@"
objectType eq 'sheet' 
 and published eq true 
 and approved eq false 
 and app.stream.name so 'Cloud'

"@  # and app.name so 'tes'

$sheets = Get-QlikObject -filter $filter.Replace([environment]::NewLine , ' ') -full
# Clears the list file
New-Item -Force $list 
"appId,sheetId" | add-content -path $list
foreach ($sheet in $sheets ) {
    ## Adds to the list
    "{0},{1}" -f $sheet.app.id,$sheet.id | add-content -path $list
    Update-QlikObject -id $sheet.id -approved $true
}
