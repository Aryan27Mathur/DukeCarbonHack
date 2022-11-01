# Sample I pulled online as reference for WMIC command

@echo OFF
color 0a
cls
:Start1
echo                       1. WMIC list available aliases                     
echo                       2. WMIC Path Win32_NetworkAdapter       
echo                       3. WMIC Path Win32_Processor32_64      
echo                       4. WMIC Path Win32_Hardware info          
echo                       5. WMIC Path Win32_LoadPercentage 
echo                       6. WMIC Path Win32_DiskPartition  

echo                       7. WMIC Path Win32_Network\DNS    
echo                       8. WMIC Path Win32_Processid      
echo                       9. WMIC Process List              
echo                       10.WMIC workingsetsize            
echo                       11.WBEMTest.exe                   
echo                   

echo                       12. Return to Main Menu            
echo                       13. Exit                           
echo                  

echo.
echo.
echo Enter Choice.
SET /P variable=
IF %variable%==13 GOTO exit
IF %variable%==12 GOTO menu
IF %variable%==11 GOTO WBEMTest
IF %variable%==10 GOTO workingsetsize
IF %variable%==9 GOTO processsort
IF %variable%==8 GOTO Processid
IF %variable%==7 GOTO Network\DNS
IF %variable%==6 GOTO DiskPartition
IF %variable%==5 GOTO LoadPercentage
IF %variable%==4 GOTO Hardware
IF %variable%==3 GOTO Processor32_64
IF %variable%==2 GOTO NetworkAdapter
IF %variable%==1 GOTO aliases

:aliases
@echo off
color 0a
cls
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F "skip=1 tokens=1,5" %%A IN ('WMIC /NameSpace:\\root\CLI Path MSFT_CliAlias Get FriendlyName^,Target ^| FIND "*"') DO SET Alias.%%A=%%B
FOR /F "tokens=2,3 delims==." %%A IN ('SET Alias') DO (
 SET "_Alias=%%A                    "
 SET _Alias=!_Alias:~0,20!
 ECHO !_Alias! =  %%B
)
ENDLOCAL
echo.
echo Export send to c:\microsoft_scriptconsole\aliases.txt
echo.
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F "skip=1 tokens=1,5" %%A IN ('WMIC /NameSpace:\\root\CLI Path MSFT_CliAlias Get FriendlyName^,Target ^| FIND "*"') DO SET Alias.%%A=%%B
FOR /F "tokens=2,3 delims==." %%A IN ('SET Alias') DO (
 SET "_Alias=%%A                    "
 SET _Alias=!_Alias:~0,20!
 ECHO !_Alias! =  %%B
) >> c:\microsoft_scriptconsole\aliases.txt
ENDLOCAL
start CMD.EXE
cd\
Echo Completed...
ECHO.
echo Press Enter to go to WMIC menu
echo.
pause > nul
goto start1

:NetworkAdapter
WMIC Path Win32_NetworkAdapter Where "PhysicalAdapter=TRUE" Get /Format:list
echo.
echo Export send to c:\microsoft_scriptconsole\PhysicalAdapter.txt
echo.
WMIC Path Win32_NetworkAdapter Where "PhysicalAdapter=TRUE" Get /Format:list >> c:\microsoft_scriptconsole\PhysicalAdapter.txt
Echo Completed...
ECHO.
echo Press Enter to go to WMIC menu
echo.
pause > nul
goto start1

 

:Processor32_64
@ECHO OFF
color 0a
cls
echo.
WMIC Path Win32_Processor Get AddressWidth /Format:list
echo.
echo Export send to c:\microsoft_scriptconsole\Processor32_64.txt
echo.
WMIC Path Win32_Processor Get AddressWidth /Format:list >> c:\microsoft_scriptconsole\Processor32_64.txt
echo.
Echo Completed...
ECHO.
echo Press Enter to go to WMIC menu
echo.
pause > nul
goto start1


:Hardware
@echo off
color 0a
cls
echo Get Disk Drive Info
echo.
wmic diskdrive get name,size,model  /Format:list
echo.
echo.
echo Export send to c:\microsoft_scriptconsole\DiskDriveModel.txt
echo.
wmic diskdrive get name,size,model  /Format:list >> c:\microsoft_scriptconsole\DiskDriveModel.txt
echo.
echo Press Enter to Get Disk Drive manufacturer
pause > nul
Echo.
Echo Get Vendor Data
echo.
wmic csproduct get name,vendor,identifyingNumber  /Format:list
echo.
echo.
echo Export send to c:\microsoft_scriptconsole\vendor.txt
echo.
wmic csproduct get name,vendor,identifyingNumber  /Format:list >> c:\microsoft_scriptconsole\vendor.txt
echo.
echo Press Enter to Get Bios Data
pause > nul
echo.
echo Get Bios Data
echo.
wmic bios get name,serialnumber,version
echo.
echo Export send to c:\microsoft_scriptconsole\BiosData.txt
echo.
wmic bios get name,serialnumber,version >> c:\microsoft_scriptconsole\BiosData.txt
echo.
echo Press Enter to Get TotalPhysicalMemory
pause > nul
echo.
echo Get TotalPhysicalMemory
wmic COMPUTERSYSTEM get TotalPhysicalMemory,caption /Format:list
echo.
echo.
echo Export send to c:\microsoft_scriptconsole\TotalPhysicalMemory.txt
echo.
wmic COMPUTERSYSTEM get TotalPhysicalMemory,caption /Format:list >> c:\microsoft_scriptconsole\TotalPhysicalMemory.txt
echo.
Echo Completed...
ECHO.
echo Press Enter to go to WMIC menu
echo.
pause > nul
goto start1


:LoadPercentage
@echo off
color 0a
cls
echo.
echo Get CPU Load Percentage
WMIC Path Win32_Processor Get LoadPercentage /Format:LIST
echo.
echo Export send to c:\microsoft_scriptconsole\LoadPercentage.txt
echo.
WMIC Path Win32_Processor Get LoadPercentage /Format:LIST >> c:\microsoft_scriptconsole\LoadPercentage.txt
echo.
Echo Completed...
ECHO.
echo Press Enter to go to WMIC menu
echo.
pause > nul
goto start1


:DiskPartition
@echo off
color 0a
cls
echo Get DiskPartition
echo.
WMIC Path Win32_DiskPartition Where "BootPartition=true And PrimaryPartition=true" Get DeviceID /Format:list
echo.
echo.
echo Export send to c:\microsoft_scriptconsole\DiskPartition.txt
echo.
WMIC Path Win32_DiskPartition Where "BootPartition=true And PrimaryPartition=true" Get DeviceID /Format:list >> c:\microsoft_scriptconsole\DiskPartition.txt
echo.
echo Press Enter to Get LogicalDiskToPartition
pause > nul
echo Get LogicalDiskToPartition
echo.
WMIC Path Win32_LogicalDiskToPartition Get Antecedent^,Dependent /Format:list
echo.
echo.
echo Export send to c:\microsoft_scriptconsole\LogicalDiskToPartition.txt
echo.
WMIC Path Win32_LogicalDiskToPartition Get Antecedent^,Dependent /Format:list >> c:\microsoft_scriptconsole\LogicalDiskToPartition.txt
echo.
Echo Completed...
ECHO.
echo Press Enter to go to WMIC menu
echo.
pause > nul
goto start1


:Network\DNS
@echo off
color 0a
cls
echo Get DNSHostName
echo.
WMIC Path Win32_NetworkAdapterConfiguration Get Description^,DNSHostName^,DNSServerSearchOrder /Format:list
echo.
echo.
echo Export send to c:\microsoft_scriptconsole\DNSHostName.txt
echo.
WMIC Path Win32_NetworkAdapterConfiguration Get Description^,DNSHostName^,DNSServerSearchOrder /Format:list >> c:\microsoft_scriptconsole\DNSHostName.txt
echo.
Echo Completed...
ECHO.
echo Press Enter to go to WMIC menu
echo.
pause > nul
goto start1


:Processid
@echo off
color 0a
cls
echo.
WMIC Path Win32_process get Caption,Processid,Commandline /Format:list
echo.
echo.
echo Export send to c:\microsoft_scriptconsole\Processid.txt
Echo.
WMIC Path Win32_process get Caption,Processid,Commandline /Format:list >> c:\microsoft_scriptconsole\Processid.txt
echo.
Echo Completed...
ECHO.
echo Press Enter to go to WMIC menu
echo.
pause > nul
goto start1


:processsort
@echo off
color 0a
cls
echo.
WMIC Path Win32_process | sort
echo.
echo.
echo Export send to c:\microsoft_scriptconsole\processsort.txt
echo.
echo Set to Excel Import Format
echo.
WMIC Path Win32_process | sort >> c:\microsoft_scriptconsole\processsort.txt
Echo.
echo.
Echo Completed...
ECHO.
echo Press Enter to go to WMIC menu
echo.
pause > nul
goto start1


:workingsetsize
@echo off
color 0a
cls
echo.
wmic process get workingsetsize,commandline /format:list
echo.
echo Export send to c:\microsoft_scriptconsole\workingsetsize.txt
echo.
wmic process get workingsetsize,commandline /format:list >> c:\microsoft_scriptconsole\workingsetsize.txt
echo.
Echo Completed...
ECHO.
echo Press Enter to go to WMIC menu
echo.
pause > nul
goto start1


:WBEMTest
@echo off
color 0a
cls
echo.
Start /wait WBEMTest.exe
echo.
Echo Completed...
ECHO.
echo Press Enter to go to WMIC menu
echo.
pause > nul
goto start1


:menu
Echo Completed...
ECHO.
echo Press Enter to go to menu
echo.
pause > nul
goto menu

:exit
Echo Completed...
ECHO.
echo Press Enter to go to menu
echo.
pause > nul
goto menu

