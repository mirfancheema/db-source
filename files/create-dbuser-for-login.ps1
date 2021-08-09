[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [Alias('hostname')]
    [string]$computer,
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [string]$sqlinstance,
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [string]$LoginName,
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [string]$Domain,
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [string[]]$Databases
  )
$ErrorActionPreference ='Stop'
#  Write-Host $computer
#  Write-Host $sqlinstance
  # Write-Host $LoginName
#  for ($i = 0; $i -lt $LoginName.length; $i++){
#     Write-Host $LoginName[$i]
#     }
#
Function CREATE_USER_FOR_LOGIN{
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
                                [string]$Domain,
                                [Parameter(Mandatory=$true)]
                                [Alias('dbname')]
                                [string]$DatabaseName

                )
               BEGIN{
                               Try{
 $query1 = @"
           CREATE user [$Domain\$LoginName] for login [$Domain\$LoginName] 
"@                                              
                                               $ErrorActionPreference = "Continue"
                                               $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
                                               $SqlConnection.ConnectionString = "Data Source = $sqlinstance; Initial Catalog = $DatabaseName; Integrated Security=true; Connection Timeout=60;"
                                               $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
                                               $SqlCmd.CommandText = $query1
                                               $SqlCmd.Connection = $SqlConnection
                                               $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
                                               $SqlAdapter.SelectCommand = $SqlCmd
                                               $DataSet = New-Object System.Data.DataSet
                                               $SqlAdapter.Fill($DataSet) | Out-Null
                                               return $true
                                }
                                Catch{
                                               Write-Error "User Creation Failed" -ErrorAction Continue
                                               Write-Error $_.Exception.Message -ErrorAction Continue
                                               return $false
                                }
                                finally {
                                $SqlConnection.Close()
                                }
                }

}


  for ($i = 0; $i -lt $Databases.length; $i++){
  $db = $Databases[$i]
  $LoginCreate = CREATE_USER_FOR_LOGIN -instance $sqlinstance -login $LoginName -domainname $Domain -DatabaseName $db
  if ( !$LoginCreate )
  {
   Write-Error "Create Login $LoginName Failed!!!" -ErrorAction Continue
   exit 1
     }
  }

 exit 0
