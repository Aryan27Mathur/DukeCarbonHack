#!/bin/sh
# GSF Power Reading Program

# SELECT * FROM Win32_Process WHERE ProcessId = pID

function Get-ThreadProcessorUtilization() {

    Param(
        [Parameter(Mandatory=$true)]
        [int]$ProcId,
        [int]$DurationMs = 2000
    )

    $StatsPrev=$null;
    $ThreadAge = @{L="ThreadAge";E={[Timespan]::FromMilliseconds($_.ElapsedTime).ToString("hh\:mm\:ss")}}
    # $ProcUtilization = @{L="ProcUtilization";E={(([Math]::Round(($_.UserModeTime - ($StatsPrev | ? Handle -eq $_.Handle).UserModeTime)/($_.ElapsedTime - ($StatsPrev | ? Handle -eq $_.Handle).ElapsedTime)*100,2)).ToString() + "%")}}
    $ProcUtilization = @{L="ProcUtilization";E={(([Math]::Round(($_.UserModeTime - ($StatsPrev | ? Handle -eq $_.Handle).UserModeTime)/($_.ElapsedTime - ($StatsPrev | ? Handle -eq $_.Handle).ElapsedTime)*100,2)))}}


    $k=1
    while ($k -ge 0) {
        $Stopwatch =  [System.Diagnostics.Stopwatch]::StartNew(); 
        $Stats = Get-CimInstance Win32_Thread -filter "ProcessHandle = $ProcId" | Select ProcessHandle, Handle, UserModeTime, ElapsedTime | Sort-Object -Property UserModeTime -Descending;

        
        $i=0
        if ($StatsPrev -ne $null) {
            # $CurrStats = $Stats | Select-Object ProcessHandle, Handle, $ThreadAge, $ProcUtilization
            $CurrStats = $Stats | Select-Object $ProcUtilization  # CurrStats is array of PSCustomObjects
            Clear-Host

            $props = Get-Member -InputObject $CurrStats[0]
            # Write-Output $props  #lists methods for PSCustomObject

            #Write-Output "Partial Utilization (represents CPU usage of all handles for given thread of PID)"
            foreach($line in $CurrStats) {# | Format-Table -HideTableHeaders)) { # -split '\s+')) {  # line is PSCustomObject
                
                # Write-Output $propValue  # ProcUtilization : 0.8
                #if($line.ProcUtilization -ne 0.0) {Write-Output $line.ProcUtilization}
                $i += $line.ProcUtilization

            }
            
            Write-Output ("Total CPU Usage for PID " + $procID + ": " + $i + "%.")
            #Write-Output $CurrStats | Format-Table -AutoSize -HideTableHeaders
        }
        $statsPrev=$stats
        $Stopwatch.Stop()
        [System.Threading.Thread]::Sleep([Math]::Max($DurationMs-($Stopwatch.ElapsedMilliseconds), 2))
        $k--
    }
}

function Get-PerfProc() {
    Param(
        [Parameter(Mandatory=$true)]
        [String]$ProcName
    )

    # Get-CimInstance Win32_Thread -filter "ProcessHandle = 2736" | select ProcessHandle, Handle, UserModeTime


    $pid_table = wmic path Win32_PerfFormattedData_PerfProc_Process get Name,PercentProcessorTime | findstr /i /c:Cakewalk

    $tot_table = wmic path Win32_PerfFormattedData_PerfProc_Process get Name,PercentProcessorTime | findstr /i /c:Total

    $idle_table = wmic path Win32_PerfFormattedData_PerfProc_Process get Name,PercentProcessorTime | findstr /i /c:Idle

    $pid_table2 = $pid_table -split '\s+'
    $tot = $tot_table -split '\s+'
    $idle = $idle_table -split '\s+'

    #ECHO ($tot[1] + " is our total CPU value.")
    #ECHO ($idle[1] + " is our idle CPU value.")
    #ECHO ("" + $pid_table2[1] + " is our partial CPU value (relative to total CPU value).")

    $out = [Math]::Round(100*$pid_table2[1]/($tot[1]+$idle[1]), 1)
    $out2 = [Math]::Round(100*$pid_table2[1]/($tot[1]), 1)
    # check that this doesn't truncate double digit numbers (23 to 2)

    #ECHO ""
    ECHO "========================================="
    # ECHO ($out.ToString() + "% is our CPU current utilization for our given PID.") # this will be used in power calc.
    ECHO ($out2.ToString() + "% is our CPU max utilization for our given PID.") # this reflects what is shown in task manager.


}

# Get-ThreadProcessorUtilization(2736) # finds util for Cakewalk (estimated around 1.5%-5% at rest)
# Get-ThreadProcessorUtilization(-1) # finds util for Idle Process (est. around 80%-90% at rest)

# Get-PerfProc("Cakewalk")

# $proc_time = typeperf "\Processor(_Total)\% Processor Time" -si 1 -sc 1 -o "perf.txt"

$file_out = "perf.txt"

Remove-Item 'C:\Users\pcw14\OneDrive - Duke University\Desktop\powertest\perf.txt'

$proc_time = typeperf "\Processor(_Total)\% Processor Time" -si 1 -sc 2 -o $file_out

$perf_data = Get-Content "C:\Users\pcw14\OneDrive - Duke University\Desktop\powertest\perf.txt" | Format-Table

ECHO $perf_data[0]
ECHO $perf_data[1]

foreach ($str in $perf_data) {
    $s = $str.ToString()
    if($s.SubString(1,8) -ne "(PDH-CSV") {
        echo $s.split(",")[1]
    }
}

#Get-Member -InputObject $perf_data[0]

# $test = Get-Member -InputObject $proc_time[0]
# ECHO $test
#ECHO $test.GetType()

#$out >> powertest_out.txt

#PAUSE
# uncomment pause above if you want to see output in console when launching by hand.