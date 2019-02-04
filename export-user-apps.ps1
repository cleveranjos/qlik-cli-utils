#
# Export all unpublished apps to a folder
# a separate folder for each user
#

$folder = "c:\dump"

Connect-Qlik|Out-Null ## check https://github.com/ahaydon/Qlik-Cli for details

foreach($qvf in get-qlikapp -filter "Published eq false" -full ) {
    $user = $qvf.owner.userId
    New-Item -ItemType Directory -Force -Path "$folder\$user"
    Export-QlikApp -id $qvf.id -filename "$($folder)\$($user)\$($qvf.name).qvf" #dumps the qvf
}


## End of file