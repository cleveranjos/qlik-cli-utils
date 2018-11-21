$backup_path = "C:\QlikBackup"
$install_path = "$env:ProgramFiles\Qlik\Sense"

# change working directory to postgres bin directory
Push-Location "$(( `
    Get-ChildItem "$install_path\Repository\PostgreSQL" `
    | Sort-Object -Descending)[0].FullName)\bin"

# get postgres password from config file
$config = [System.Configuration.ConfigurationManager]::OpenExeConfiguration(`
    "$install_path\Repository\Repository.exe")
$match = ($config.GetSection('connectionStrings').ConnectionStrings `
    | ? Name -eq QSR).ConnectionString `
    | Select-String -Pattern 'User ID=([^;]*);.*Password=\''([^;]*)\'';'

# store postgres password in environment variable to prevent being prompted
$user = $match.Matches.Groups[1].Value
$env:PGPASSWORD = $match.Matches.Groups[2].Value

Stop-Service QlikSenseEngineService
Stop-Service QlikSensePrintingService
Stop-Service QlikSenseProxyService
Stop-Service QlikSenseSchedulerService
Stop-Service QlikSenseServiceDispatcher
Stop-Service QlikSenseRepositoryService

# dump the repository database to a file for backup
.\pg_dump.exe -h localhost -p 4432 -U $user -b -F t -f `
    "$backup_path\QSR_backup.tar" QSR

Start-Service QlikSenseRepositoryService
Start-Service QlikSenseEngineService
Start-Service QlikSensePrintingService
Start-Service QlikSenseProxyService
Start-Service QlikSenseSchedulerService
Start-Service QlikSenseServiceDispatcher

Pop-Location
