<#VERSION 01.0005#> 
<#DATE 17-OCT2022#> 

$SW2remove = "TeamViewer*"
$OldPath = "C:\Program Files (x86)\TeamViewer"
$app = "TeamViewer"
$ArgList = "/i TeamViewer_Host.msi /qn CUSTOMCONFIGID=<YOUR-CONFIG-ID/>"
$easyAccess = "assign --api-token=<INSERT-KEY-HERE/> --grant-easy-access"

Write-Verbose -Verbose ("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
Write-Verbose -Verbose ("~~~~ STEP 1 - Clean up & Installation of TEAMS VIEWER ~~~~")
Write-Verbose -Verbose ("NOTE: ")
Write-Verbose -Verbose ("(1) You must be logged on with Admin account, running elevated, for this script to work")
Write-Verbose -Verbose ("(2) Must run this ps from same dir location as the TeamViewer msi.")
Write-Verbose -Verbose ("")

<#1 ---- Check interactive user is Admin ---#> 
Write-Verbose -Verbose ("`n #1 --- Running prerequisite checks...")   
Write-Verbose -Verbose ("Info: Account process is: " + (whoami))
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Verbose -Verbose "Info: Process running with admin rights... check."
} else {
    Write-Verbose -Verbose ("Invalid account. You MUST 'Run As' Admin for this script work... Exiting")
    exit
}  

$chkmsi = Test-Path("TeamViewer_Host.msi")
if (-Not $chkmsi)
{
    Write-Verbose -Verbose ("TeamViewer_Host.msi file is missing... Exiting")
    exit
}

<#2 ---- Check for and clean any old T-V installs ---#>    
Write-Verbose -Verbose "`n #2 --- Checking for old TeamViewer installs..."
$Old_Install = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -like $SW2remove}

if ($Old_Install) 
{
    Write-Verbose -Verbose ("`n Info: Existing Teams Viewer *MSI* install found. Removing..." + $Old_Install)
    try 
    {
       $Old_Install.Uninstall()
       if (Test-Path $OldPath) 
       {
          Start-Sleep -Seconds 5
          Write-Verbose -Verbose ("Info: Clean up stale MSI install files")
          Remove-Item $OldPath -Recurse -Force
          Start-Sleep -Seconds 5
       } 
       Write-Verbose -Verbose ("Info: Uninstall work complete.")
    }
    catch {
       Write-Error "Error Uninstalling TeamsViewer *MSI install* occurred: $_"
    }
 }
 else
 {
    if (Test-Path $OldPath) 
    {
        Write-Verbose -Verbose ("Info: Existing TeamViewer *EXE* install detected. Removing...")
        Start-Sleep -Seconds 5
        try 
        {
           Push-Location $OldPath
           $process = Get-Process $app -ErrorAction SilentlyContinue
            if ($process) 
            {
                Stop-Process $process -Force
                Write-Verbose -Verbose "Info: $app has been stopped."
            }
            else 
            {
                Write-Verbose -Verbose "Info: $app is not running."
            }
           Start-Process .\uninstall.exe  -arg "/S" -Wait
           Pop-Location 
           if (Test-Path $OldPath) 
            {
                Start-Sleep -Seconds 5
                Write-Verbose -Verbose ("Info: Clean up stale EXE install files")
                Remove-Item $OldPath -Recurse -Force 
                Start-Sleep -Seconds 5
            } 
            Write-Verbose -Verbose ("Info: EXE/Non-MSI Uninstall work complete.")
        }
        catch {
           Write-Error "Error Uninstalling TeamsViewer *EXE install* occurred: $_"
        }        
     }
     else
     {
        Write-Verbose -Verbose ($Old_Install + "Info: TeamViewer Software install NOT found")
     }
 }

 <#3 ---- Now do clean install ---#>    
 Write-Verbose -Verbose "`n #3 --- Installing Teams Viewer now..."
  try 
    {    
        Write-Verbose -Verbose ("Info: running install with args: " + $ArgList)
        Start-Process -FilePath "msiexec.exe" -Wait -ArgumentList $ArgList
        Write-Verbose -Verbose ("Info: applying easy access...")
        Push-Location "C:\Program Files (x86)\TeamViewer"
        Get-Location
        Start-Sleep -Seconds 5
        Start-Process  .\TeamViewer.exe -arg easyAccess -Wait
        Pop-Location
    }
    catch {
       Write-Error "Install Error occurred: $_"
    }

 Write-Verbose -Verbose ("`n *** TeamViewer Install Automation Script Completed *** ")
 Write-Verbose -Verbose ("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
