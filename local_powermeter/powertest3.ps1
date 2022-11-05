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
            
            #Write-Output ("Total CPU Usage for PID " + $procID + ": " + $i + "%.")
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


$process_id = 21756
#This process_id is what we're using to reference our program of interest (for our demo, it's a music DAW program called Cakewalk)
Get-ThreadProcessorUtilization($process_id) # finds util for Cakewalk (estimated around 1.5%-5% at rest)
# Get-ThreadProcessorUtilization(-1) # finds util for Idle Process (est. around 80%-90% at rest)

# Get-PerfProc("Cakewalk")

# $proc_time = typeperf "\Processor(_Total)\% Processor Time" -si 1 -sc 1 -o "perf.txt"

$file_out = "perf.txt"

Remove-Item 'perf.txt'

$proc_time = typeperf "\Processor(_Total)\% Processor Time" -si 1 -sc 2 -o $file_out

$perf_data = Get-Content "perf.txt" | Format-Table

$partial_CPU_usage = $perf_data[2] | Out-String
$partial_CPU_usage = $partial_CPU_usage.Substring(27,5)
echo ("fraction of total CPU load utilization of program with PID " + $process_id + ": " + $partial_CPU_usage + "%")

#run vbs scripts
.\vbs_cpu_package_power.vbs | Out-Null
.\vbs_cpu_package_load.vbs | Out-Null


#access data from vbs scripts
$total_cpu_usage = Get-Content .\vbs_cpu_package_load.txt
$cpu_power_consumption = Get-Content .\vbs_cpu_package_power.txt
echo $total_cpu_usage
echo $partial_CPU_usage

echo ("total CPU load utilization: " + $total_cpu_usage + "%")
echo ("net CPU load utilization for program with PID " + $process_id + ": " + ($partial_CPU_usage/$total_cpu_usage) + "%")
echo ("power consumed by CPU package: " + $cpu_power_consumption + "W")

#compute partial power usage for single program.
$program_power_consumption = (1.0 * $partial_CPU_usage/100 * $cpu_power_consumption)
echo ("power consumed by program with PID " + $process_id + ": " + $program_power_consumption + "W")


#curl request with power data to replit
#curl -X POST https://dukecarbonhack.aryanmathur4.repl.co/watt -d hid,0,power,100 #only works in batch
Invoke-WebRequest -Uri https://dukecarbonhack.aryanmathur4.repl.co/watt -Method POST -Body "hid,0,power,$program_power_consumption"


#$props = Get-Member -InputObject $t
#Write-Output $props  #lists methods for PSCustomObject
#$out >> powertest_out.txt

#PAUSE
# uncomment pause above if you want to see output in console when launching by hand.