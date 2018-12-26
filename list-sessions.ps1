Connect-Qlik|Out-Null
[System.Collections.ArrayList]$sessions = @()
foreach ($vp in Get-QlikVirtualProxy) {
   foreach ($session in Get-QlikSession -virtualProxyPrefix $vp.prefix) {
    $s = [PSCustomObject]@{
        Index = "[$($sessions.Count+1)]" 
        UserId = $session.UserId
        VirtualProxy  =  $vp.description        
        SessionId = $session.SessionId
        }
    $sessions.Add($s)|Out-Null
   } 
}
$sessions | Format-Table
