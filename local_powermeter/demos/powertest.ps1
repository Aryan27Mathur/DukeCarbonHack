#!/bin/sh
# GSF Power Reading Program

$pid_table = wmic path Win32_PerfFormattedData_PerfProc_Process get Name,PercentProcessorTime | findstr /i /c:Cakewalk

$tot_table = wmic path Win32_PerfFormattedData_PerfProc_Process get Name,PercentProcessorTime | findstr /i /c:Total

$idle_table = wmic path Win32_PerfFormattedData_PerfProc_Process get Name,PercentProcessorTime | findstr /i /c:Idle

$pid_table2 = $pid_table -split '\s+'
$tot = $tot_table -split '\s+'
$idle = $idle_table -split '\s+'

ECHO ($tot[1] + " is our total CPU value.")
ECHO ($idle[1] + " is our idle CPU value.")
ECHO ("" + $pid_table2[1].ToString() + " is our partial CPU value (relative to total CPU value).")

$out = [Math]::Round(100*$pid_table2[1]/($tot[1]-$idle[1]), 1)
$out2 = [Math]::Round(100*$pid_table2[1]/($tot[1]), 1)
# check that this doesn't truncate double digit numbers (23 to 2)

ECHO ""
ECHO "========================================="
ECHO ($out.ToString() + "% is our CPU current utilization for our given PID.") # this will be used in power calc.
ECHO ($out2.ToString() + "% is our CPU max utilization for our given PID.") # this reflects what is shown in task manager.
$out >> powertest_out.txt

#PAUSE
# uncomment pause above if you want to see output in console when launching by hand.