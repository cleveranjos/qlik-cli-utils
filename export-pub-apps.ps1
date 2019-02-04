#
# Dump published apps
# a folder for each stream
# 
#

$folder = "c:\dump"

Connect-Qlik ## check https://github.com/ahaydon/Qlik-Cli for details

foreach($qvf in Get-QlikApp -filter "Published eq true") {
    $streamfolder = $qvf.stream.name
    New-Item -ItemType Directory -Force -Path "$folder\$streamfolder"
    Export-QlikApp -id $qvf.id -filename "$($folder)\$($streamfolder)\$($qvf.name).qvf" #dumps the qvf
}

## End of file