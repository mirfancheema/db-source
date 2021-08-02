#Requires -RunAsAdministrator
$ErrorActionPreference ='Stop'

# Get a service which doesn't exist
try {
    Get-Service "This will fail"
}
catch {

    Write-Error "Unable find service" -ErrorAction Continue
    Write-Error $_.Exception.Message -ErrorAction Continue
    exit 1
}


exit 0
