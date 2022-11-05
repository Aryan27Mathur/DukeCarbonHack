strComputer = "." 
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\OpenHardwareMonitor") 
Set colItems = objWMIService.ExecQuery( _
    "SELECT * FROM Sensor WHERE Name = 'CPU Package' AND SensorType = 'Power'",,48) 
For Each objItem in colItems 
    'Wscript.Echo "-----------------------------------"
    'Wscript.Echo "Sensor instance"
    'Wscript.Echo "-----------------------------------"
    'Wscript.Echo "Name: " & objItem.Name
    'Wscript.Echo "Parent: " & objItem.Parent
    'Wscript.Echo "ProcessId: " & objItem.ProcessId
    'Wscript.Echo "SensorType: " & objItem.SensorType
    'Wscript.Echo "Value: " & objItem.Value

    Set objFSO=CreateObject("Scripting.FileSystemObject")

    ' Write to a file
    outFile = "C:\Users\pcw14\OneDrive - Duke University\Desktop\powertest\vbs_cpu_package_power.txt"
    Set objFile = objFSO.CreateTextFile(outFile,True)
    objFile.Write objItem.Value & vbCrLf
    objFile.Close
Next