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