#
# re-import e publisfapps
# a folder for each stream
# 

$folder = "c:\dump"

foreach ($file in Get-ChildItem -Filter *.qvf -Path $folder ) {
    Import-QlikApp -file $file.FullName -name $_.Basename -upload | Publish-QlikApp -stream $file.Directory.BaseName
}
