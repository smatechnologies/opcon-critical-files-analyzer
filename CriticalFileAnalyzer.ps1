Add-Type -AssemblyName System.Windows.Forms
$global:LogFolder = $null
$global:LogFile = $null
$global:LogAnalyzedList = $null
$global:LogAnalyzedContent = $null
$global:LogMatchingResult = $null
$global:nCriticalFileFound = 0
$global:InitialFolder = "C:\ProgramData\OpConxps\SAM\Log"
$global:Outfilename=".\Out.txt"

enum ENSearchScope
{
   None
   SingleFile
   FolderNoRecursive
   FolderRecursive
}
[ENSearchScope]$enSScope = [ENSearchScope]::None

enum ENAnalisysType
{
   None
   Basic
   Intermediate
   Full
}

enum ENOutputType
{
   Video
   TextFile
}
[ENOutputType]$enOutType = [ENOutputType]::Video


function mainMenu {
    $mainMenu = 'X'
    while($mainMenu -ne ''){
        Clear-Host
        Write-Host "`n`t`t OpCon Log Parser`n"
        Write-Host -ForegroundColor Cyan "Main Menu"
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "1"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
        Write-Host -ForegroundColor DarkCyan " Analize single Critical.log file"

        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "2"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
        Write-Host -ForegroundColor DarkCyan " Analize all Critical.log files in a specific folder (i.e. <Programdata\OpConxps\SAM\Log\>)"

        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "3"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
        Write-Host -ForegroundColor DarkCyan " Analize all Critical.log files recursively from a starting folder (i.e. <Programdata\OpConxps\SAM\Log>), can take a while"

            
        $mainMenu = Read-Host "`nSelection (leave blank to quit)"
        # Launch subMenuSearchDetails
        if($mainMenu -eq 1){
            $global:LogFile = Get-File($global:InitialFolder)
            #$global:LogFile = "C:\AActivities\prospect&Activities\20_G2S\2021\GroupamaLog\Log\Critical 000018 - 080441.log"
           RetrieveLogFilesToAnalyze([ENSearchScope]::SingleFile) 
            subMenuSearchDetails
        }
        # Launch subMenuSearchDetails
        if($mainMenu -eq 2){
            
            $global:LogFolder = Get-Folder($global:InitialFolder)
            RetrieveLogFilesToAnalyze ([ENSearchScope]::FolderNoRecursive)
            subMenuSearchDetails
        }
        # Launch subMenuSearchDetails
        if($mainMenu -eq 3){
            [ENSearchScope]$enSScope = [ENSearchScope]::FolderRecursive
            $global:LogFolder = Get-Folder($global:InitialFolder)
            RetrieveLogFilesToAnalyze([ENSearchScope]::FolderRecursive)
            subMenuSearchDetails
        }
    }
}

function subMenuSearchDetails {
    $subMenuSearchDetails = 'X'
    while($subMenuSearchDetails -ne ''){
        Clear-Host


        Write-Host "`n`t`t OpCon Log Parser`n"
        
        Write-Host -ForegroundColor Cyan "Number of Critical files found :  $($global:nCriticalFileFound)"
        
        Write-Host
        Write-Host -ForegroundColor Cyan "Analisys Type Menu"
        Write-Host

        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "1"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
        Write-Host -ForegroundColor DarkCyan " Basic (only event statistics) "
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "2"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
        Write-Host -ForegroundColor DarkCyan " Intermediate (Includes Schedules data) "
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "3"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
        Write-Host -ForegroundColor DarkCyan " Full (Includes Rows with the event) "
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "4"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
        Write-Host -ForegroundColor DarkCyan " Change output type, current: $($enOutType) "



        $subMenuSearchDetails = Read-Host "`nSelection (leave blank for Main Menu)"
        $timeStamp = Get-Date -Uformat %m%d%y%H%M
        # Option 1 - Basic Analysis
        if($subMenuSearchDetails -eq 1){        

            
            DisplayResults([ENAnalisysType]::Basic)


            # Pause and wait for input before going back to the menu
            Write-Host -ForegroundColor DarkCyan "`nScript execution complete."
            Write-Host "`nPress any key to return to the menu"
            [void][System.Console]::ReadKey($true)
        }
        # Option 2 - Intermediate
        if($subMenuSearchDetails -eq 2){
            
            DisplayResults([ENAnalisysType]::Intermediate)
            
            # Pause and wait for input before going back to the menu
            Write-Host -ForegroundColor DarkCyan "`nScript execution complete."
            Write-Host "`nPress any key to return to the menu"
            [void][System.Console]::ReadKey($true)
        }
        # Option 3 - Full
        if($subMenuSearchDetails -eq 3){
            
            DisplayResults([ENAnalisysType]::Full)
            
            # Pause and wait for input before going back to the menu
            Write-Host -ForegroundColor DarkCyan "`nScript execution complete."
            Write-Host "`nPress any key to return to the menu"
            [void][System.Console]::ReadKey($true)
        }
        if($subMenuSearchDetails -eq 4){
            if ($enOutType -eq 'Video' ){
                $enOutType = [ENOutputType]::TextFile
            }
            else{
                $enOutType = [ENOutputType]::Video
            }
        }
    }
}

function RetrieveLogFilesToAnalyze([ENSearchScope]$enSScope ){
#$LogFolder = "C:\AActivities\prospect&Activities\20_G2S\2021\GroupamaLog\Log\Archives"
#$LogFolder = "C:\AActivities\prospect&Activities\20_G2S\2021\GroupamaLog\Log\RMA\tmp\tmp"
# Log file extension
$LogExtension = "Critical"

Write-Host "Retrieving file lists"

switch ( $enSScope )
{
    SingleFile{
        $global:LogAnalyzedList = Get-ChildItem -Path $global:LogFile | Where {$_.Name -match $LogExtension} | Select Name,FullName
    }
    FolderNoRecursive{
        $global:LogAnalyzedList = Get-ChildItem -Path $LogFolder | Where {$_.Name -match $LogExtension} | Select Name,FullName
    }
   FolderRecursive{
    $global:LogAnalyzedList = Get-ChildItem -Path $LogFolder -recurse | Where {$_.Name -match $LogExtension} | Select Name,FullName
   }

}

# Finding all logs in the folder (add -Recurse to get all logs in sub folders too)
#$Logs = Get-ChildItem -Path $LogFolder -recurse | Where {$_.Name -match $LogExtension} | Select Name,FullName
# Counting log files
$global:nCriticalFileFound = $LogAnalyzedList  | Measure | Select -ExpandProperty Count


if ($global:nCriticalFileFound -gt 0 ){
    Write-Host "Retrieving global files content"

    $global:LogAnalyzedContent = ForEach ($Log in $global:LogAnalyzedList) {  
            Get-Content -Path $Log.FullName 
        }

        $pattern = '(?<TimeStamp>[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3})    Invalid event \((?<ErrDesc>[^)]+)\): \$(?<EvtType>[^,]+),(?<skdDate>[^,]+),(?<SkdName>[^,]+),(?<Jobname>[^,|.]+)'
        $global:LogMatchingResult = [regex]::Matches($LogAnalyzedContent, $pattern)    
    }
}

function DisplayResults([ENAnalisysType]$enScanType ){

    if ($enOutType -eq 'Video' ){
        DisplayResultsToVideo($enScanType )
    }
    else{
        DisplayResultsToFile($enScanType )
    }
}

function DisplayResultsToVideo($enScanType ){
    
    
   
    Write-Host "------------------------------"
    Write-Host " List of file analyzed:       "
    Write-Host "------------------------------"

    ForEach ($Log in $global:LogAnalyzedList) {  Write-Host $log.FullName } 


    Write-Host "------------------------------"
    Write-Host "Statistics for 'Invalid events'"
    Write-Host "------------------------------"
    
    Write-Host "Total 'Invalid events' : $($global:LogMatchingResult.Count)"
    
    if ($($global:LogMatchingResult.Count) -gt 0){

        Write-Host "Aggregated by error type"
        Write-Host "------------------------------"

        $global:LogMatchingResult | Foreach-Object {$_.Groups['ErrDesc'].Value } |  Group-Object -NoElement | Sort-Object -Property Count -Descending | Format-Table  
        

        Write-Host
        Write-Host "Aggregated by actions"
        Write-Host "------------------------------"
        Write-Host
        $global:LogMatchingResult | Foreach-Object {$_.Groups['EvtType'].Value} |  Group-Object -NoElement | Sort-Object -Property Count -Descending | Format-Table  -auto 
        
        Write-Host

        if ($enScanType -eq [ENAnalisysType]::Intermediate -Or $enScanType -eq [ENAnalisysType]::Full) {
            Write-Host "Aggregated by Skedule Name"
            Write-Host "------------------------------"
            $global:LogMatchingResult | Foreach-Object {$_.Groups['SkdName'].Value} |  Group-Object -NoElement  | Sort-Object -Property Count -Descending| Format-Table  -auto 
            
        }

        if ($enScanType -eq [ENAnalisysType]::Full) {
            Write-Host "All matching rows"
            Write-Host "------------------------------"
            

            $ct = 0
            
            foreach ($item in $global:LogMatchingResult) {
                
                Write-host  $ct $item.Groups['TimeStamp'] "Invalid event:"  $item.Groups['ErrDesc'].value " SkdDate:"  $item.Groups['skdDate'].value "SkdName:" $item.Groups['SkdName'].value "JobName:" $item.Groups['Jobname'].value -   $item.Groups['EvtType'].value
            
                $ct +=1
            }
            
        }

    }

}

function DisplayResultsToFile([ENAnalisysType]$enScanType ){
        
        If (Test-Path $global:Outfilename){
            Remove-Item $global:Outfilename
        }
        AppendToFile "------------------------------"
        AppendToFile " List of file analyzed:       "
        AppendToFile "------------------------------"
       
        AppendToFile ""

        ForEach ($Log in $global:LogAnalyzedList) {  
            AppendToFile $log.FullName 
        }
    
        AppendToFile ""
        AppendToFile "------------------------------"
        AppendToFile "Statistics for 'Invalid events'"
        AppendToFile "------------------------------"
        AppendToFile
        AppendToFile "Total 'Invalid events' : $($global:LogMatchingResult.Count)"
        AppendToFile ""
        AppendToFile "Aggregated by error type:"

        $global:LogMatchingResult | Foreach-Object {$_.Groups['ErrDesc'].Value } |  Group-Object -NoElement | Sort-Object -Property Count -Descending | Format-Table  -auto | Out-File -FilePath $global:Outfilename  -Append -Encoding UTF8

        AppendToFile ""
        AppendToFile "Aggregated by actions:"
    
        $global:LogMatchingResult | Foreach-Object {$_.Groups['EvtType'].Value} |  Group-Object -NoElement | Sort-Object -Property Count -Descending |  Format-Table  -auto | Out-File -FilePath $global:Outfilename  -Append -Encoding UTF8
        
    
        if ($enScanType -eq [ENAnalisysType]::Intermediate -Or $enScanType -eq [ENAnalisysType]::Full) {
            AppendToFile "Aggregated by Skedule Name:"
            
            $grouped = $global:LogMatchingResult | Foreach-Object {$_.Groups['SkdName'].Value.Trim()} |  Group-Object -NoElement  | Sort-Object -Property Count -Descending

            AppendToFile "Count      Name"
            AppendToFile "------     ----"      
            foreach ($item in $grouped) {
                $line =  "{0,6} {1,10}" -f $($item.Count), $($item.Values.trim())
                AppendToFile $line
            }

        }
    
        if ($enScanType -eq [ENAnalisysType]::Full) {
            AppendToFile ""
            AppendToFile "All matching rows: "
            AppendToFile "----------------- "

            $grouped = $global:LogMatchingResult | Foreach-Object {$_.Groups['SkdName'].Value.Trim()} |  Group-Object -NoElement  | Sort-Object -Property Count -Descending
            foreach ($item in $global:LogMatchingResult) {
                            AppendToFile $item.value
            }

        }

    }

Function Get-Folder($initialDirectory)

{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select a folder"
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $initialDirectory

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}

Function Get-File($initialDirectory)
{

    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = $global:InitialFolder}
            $null = $FileBrowser.ShowDialog()
            
            #Write-Host $FileBrowser.FileName
            $file = $FileBrowser.FileName
            
            return $file
}
        
Function AppendToFile($strLine){
    Add-Content  -Path $global:Outfilename -Value $strline

}


mainMenu