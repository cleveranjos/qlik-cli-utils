#
# re-import e publisfapps
# a folder for each stream
# 

connect-qlik

$folder = "C:\Users\qlikservice\Documents\apps\ExportedApps"

foreach ($file in Get-ChildItem -recurse -Filter *.qvf -Path $folder ) {
    Import-QlikApp -file $file.FullName -name $file.Basename -upload | Publish-QlikApp -stream $file.Directory.BaseName
}

## End of file