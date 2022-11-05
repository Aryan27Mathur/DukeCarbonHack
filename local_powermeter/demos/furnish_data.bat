@echo off

set power=0
setlocal enabledelayedexpansion
set count=0
for /f "tokens=*" %%x in (vbs_cpu_package_power.txt) do (
    set /a count+=1
    set var[!count!]=%%x
    Rem ECHO %var[0]%
    set %power%=%%x
)

set count=0
for /f "tokens=*" %%x in (vbs_cpu_package_load.txt) do (
    set /a count+=1
    set var[!count!]=%%x
)

SET out=hid,1,power,"%power%"

echo %power%


Rem curl -X POST https://dukecarbonhack.aryanmathur4.repl.co/watt -d hid,0,power,end
curl -X POST https://dukecarbonhack.aryanmathur4.repl.co/watt -d hid,0,power,100

PAUSE