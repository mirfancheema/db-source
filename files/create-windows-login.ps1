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
Function CREATE_LOGIN_WINDOWS{
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
           CREATE LOGIN [$Domain\$LoginName] FROM WINDOWS WITH DEFAULT_DATABASE=[master] 
"@                                              
                                               $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
                                               $SqlConnection.ConnectionString = "Data Source = $sqlinstance; Initial Catalog = Master; Integrated Security=true; Connection Timeout=60;"
                                               $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
                                               $SqlCmd.CommandText = $query1
                                               $SqlCmd.Connection = $SqlConnection
                                               $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
                                               $SqlAdapter.SelectCommand = $SqlCmd
                                               $DataSet = New-Object System.Data.DataSet
                                                $SqlAdapter.Fill($DataSet) | Out-Null
                                                $ErrorActionPreference = "Continue"
                                }
                                Catch{
                                               Write-Error "Login Creation Failed" -ErrorAction Continue
                                               Write-Error $_.Exception.Message -ErrorAction Continue
#                                               Write-Host "Login Creation Failed" -ForegroundColor "Red"
                                               return $false
                                }
                }
                Process{
#                                Write-Host "$query1"
                                $DataSet.Tables[0]
#                                return $DataSet.Tables[0]
                                return $true
                }
                END{
                                $SqlConnection.Close()
#                                 Write-Host "END"
                }

}


  for ($i = 0; $i -lt $LoginName.length; $i++){
#     Write-Host $LoginName[$i]
  $lgin = $LoginName[$i]
  $LoginCreate = CREATE_LOGIN_WINDOWS -instance $sqlinstance -login $LoginName[$i] -domainname $Domain
  if ( !$LoginCreate )
  {
#   Write-Error "Create Login $lgin Failed" -ErrorAction Continue
   exit 1
     }
  }

  exit 0
