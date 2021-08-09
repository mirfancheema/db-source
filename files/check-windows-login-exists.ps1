[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [Alias('hostname')]
    [string]$computer,
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [string]$sqlinstance,
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [string[]]$LoginName,
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [string]$Domain
  )
$ErrorActionPreference ='Stop'
#  Write-Host $computer
#  Write-Host $sqlinstance
  # Write-Host $LoginName
#  for ($i = 0; $i -lt $LoginName.length; $i++){
#     Write-Host $LoginName[$i]
#     }
#
Function CHECK_LOGIN_EXISTS{
                [CmdletBinding()]
                Param(
                                [Parameter(Mandatory=$true)]
                                [Alias('instance')]
                                [string]$sqlinstance,
                                [Parameter(Mandatory=$true)]
                                [Alias('login')]
                                [string]$LoginName,
                                [Parameter(Mandatory=$true)]
                                [Alias('domainname')]
                                [string]$Domain
                )
               BEGIN{
                               Try{
 $query1 = @"
               SELECT name FROM master.sys.server_principals WHERE name = '$Domain\$LoginName'
"@                                              
                                               $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
                                               $SqlConnection.ConnectionString = "Data Source = $sqlinstance; Initial Catalog = Master; Integrated Security=true; Connection Timeout=60;"
                                               $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
                                               $SqlCmd.CommandText = $query1
                                               $SqlCmd.Connection = $SqlConnection
                                               $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
                                               $SqlAdapter.SelectCommand = $SqlCmd
                                               $DataSet = New-Object System.Data.DataSet
                                               $rowcount = $SqlAdapter.Fill($DataSet)
                                               $ErrorActionPreference = "Continue"
                                }
                                Catch{
                                               Write-Error "Login Exist Check Failed" -ErrorAction Continue
                                               Write-Error $_.Exception.Message -ErrorAction Continue
                                               return $false
#                                               Write-Host "Login Creation Failed" -ForegroundColor "Red"
                                }
                }
                Process{
#                                Write-Host "$query1"
#                                $DataSet.Tables[0]
#                                return $DataSet.Tables[0]
                                if ( $rowcount -eq 0 ){
                                   return $false
                                } else {
                                   return $true
                                }
                }
                END{
                                $SqlConnection.Close()
#                                 Write-Host "END"
                }

}


  for ($i = 0; $i -lt $LoginName.length; $i++){
#     Write-Host $LoginName[$i]
  $lgin = $LoginName[$i]
  $LoginCheck = CHECK_LOGIN_EXISTS -instance $sqlinstance -login $LoginName[$i] -domainname $Domain
  if ( $LoginCheck )
  {Write-Error "Login $lgin Exists" -ErrorAction Continue
   exit 1
     }
  }

  exit 0
