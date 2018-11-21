#
#  Re-imports apps exported by export-user-apps.ps1
#
$folder = "c:\dump"
Connect-Qlik 
foreach ($qvf in gci -Recurse -Filter "*.qvf" -Path $folder ) {
    $app = $qvf.BaseName
    $user =  $qvf.Directory.Name
    $app = Import-QlikApp -file $qvf.FullName -name "$app" -upload
    Update-QlikApp -id $app.id -ownername $user 
}
