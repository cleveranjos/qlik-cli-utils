#converted from https://qlik.dev/tutorials/migrate-apps-from-qlik-sense-on-windows-to-qlik-sense-saas#make-private-sheets-public
##Obtain a list of sheets in an app where ${appId} is the GUID for the app, also
##known as the resource id in Qlik Sense SaaS.
$SaasAppId='d32fd3a1-8830-4ca1-b1bf-3fcc1484f12c'
foreach ( $sheet in $(qlik app object ls --app $SaasAppId --json | ConvertFrom-Json).Where({$_.qType -eq 'sheet'}) ) {
    qlik app object publish $($sheet.qId)  -a $SaasAppId
}
