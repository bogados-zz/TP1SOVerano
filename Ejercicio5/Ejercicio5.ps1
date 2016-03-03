#############################################################################################
# PRIMERA REENTREGA
# PROGRAM-ID.  ejercicio5.ps1					                                                      #
# TIPO DE PROGRAMA: .ps1                                                                    #
# ALUMNOS :                                                                                 #                                                                              
#           -Bogado, Sebastian                                                          #
#           -Rey, Juan Cruz                                                                 #
#############################################################################################

<#
.SYNOPSIS
Muestra el modelo de CPU, cantidad de memoria RAM, placas de red y versión del sistema operativo en formato de tabla.
.DESCRIPTION
Muestra el modelo de CPU, cantidad de memoria RAM, placas de red y versión del sistema operativo en formato de tabla.
.EXAMPLE
    C:\PS> .\ejercicio5.ps1 
	
#>




$modeloCPU = (Get-WmiObject win32_processor).Name
$memoriaRamInstalada = [math]::Round( (Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory/1GB )
$placasDeRed = Get-WmiObject -Class Win32_NetworkAdapter | where {$_.PhysicalAdapter -eq "True"} | select name
$sistemaOperativo = (Get-WmiObject Win32_OperatingSystem).Caption

write-host "Modelo de CPU: "
$modeloCPU | Format-Table
write-host "Memoria RAM instalada en GB: "
$memoriaRamInstalada | Format-Table
write-host "Placas de red: "
$placasDeRed|Format-Table
write-host "Versi�n del sistema operativo: "
$sistemaOperativo | Format-Table
