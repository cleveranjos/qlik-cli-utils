Connect-Qlik|Out-Null
[System.Collections.ArrayList]$sessions = @()
foreach ($vp in Get-QlikVirtualProxy) {
   foreach ($session in Get-QlikSession -virtualProxyPrefix $vp.prefix) {
    $s = [PSCustomObject]@{
        Index = "[$($sessions.Count+1)]" 
        UserId = $session.UserId
        VirtualProxy  =  $vp.description        
        SessionId = $session.SessionId
        VirtualProxyPrefix = $vp.prefix
        }
    $sessions.Add($s)|Out-Null
   } 
}
$sessions | Format-Table

$value = $(Read-Host -Prompt 'Choose a session to terminate') -as [int]
if (($value -gt 0) -and ($value -le $sessions.Count)) {
    $yn = Read-Host -Prompt "Are you sure you want to terminate session [$value] - [$($sessions.Item($value-1).SessionId)] (y/n)?"
    if($yn -match "[yY]") {
        $proxy = Get-QlikProxy local
		$prefix = "https://$($proxy.serverNodeConfiguration.hostName):$($proxy.settings.restListenPort)/qps"
        if($sessions.Item($value-1).VirtualProxyPrefix) {
             $prefix = "$($prefix)/$($sessions.Item($value-1).VirtualProxyPrefix)"
        }
        Invoke-QlikDelete -path "$prefix/session/$($sessions.Item($value-1).SessionId)"
    }
}
