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
Connect-Qlik|Out-Null ## check https://github.com/ahaydon/Qlik-Cli for details
[System.Collections.ArrayList]$sessions = @()
foreach ($vp in Get-QlikVirtualProxy) {
    foreach ($session in Get-QlikSession -virtualProxyPrefix $vp.prefix) {
        $s = [PSCustomObject]@{
            Index              = "[$($sessions.Count+1)]" 
            UserId             = $session.UserId
            VirtualProxy       = $vp.description        
            SessionId          = $session.SessionId
            VirtualProxyPrefix = $vp.prefix
        }
        $sessions.Add($s)|Out-Null
    } 
}

$sessions | Format-Table

$value = $(Read-Host -Prompt 'Choose a session to terminate') -as [int]
if (($value -gt 0) -and ($value -le $sessions.Count)) {
    $yn = Read-Host -Prompt "Are you sure you want to terminate session [$value] - [$($sessions.Item($value-1).SessionId)] (y/n)?"
    if ($yn -match "[yY]") {
        $proxy = Get-QlikProxy local
        $prefix = "https://$($proxy.serverNodeConfiguration.hostName):$($proxy.settings.restListenPort)/qps"
        if ($sessions.Item($value - 1).VirtualProxyPrefix) {
            $prefix = "$($prefix)/$($sessions.Item($value-1).VirtualProxyPrefix)"
        }
        Invoke-QlikDelete -path "$prefix/session/$($sessions.Item($value-1).SessionId)"
    }
}

