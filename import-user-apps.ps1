$myserver = "qmi-qs-sn"
$folder = "c:\dump"
$domain = "QMI-QS-SN"
Connect-Qlik $myserver
foreach ($qvf in gci -Recurse -Filter "*.qvf" -Path $folder ) {
    $app = $qvf.BaseName
    $user =  $qvf.Directory.Name
    $app = Import-QlikApp -file $qvf.FullName -name "$app" -upload
    Update-QlikApp -id $app.id -ownername $user 
}
