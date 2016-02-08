#############################################################################################
# PROGRAM-ID.  ejercicio5.ps1					                                                      #
# TIPO DE PROGRAMA: .ps1                                                                    #
# ALUMNOS :                                                                                 #                                                                              
#           -Bogado, Sebastian                                                              #
#           -Gutierrez, Rubén                                                               #
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

Get-WmiObject -class win32_Processor | Format-Table
Get-WmiObject -Class Win32_OperatingSystem | Format-Table
Get-WmiObject -Class Win32_PhysicalMemory|Format-Table Description, ConfiguredClockSpeed, Manufacturer, Name, PartNumber, Capacity
$hola=Get-WmiObject Win32_NetworkAdapter -filter "AdapterType != NULL" 
$i=0
foreach($tarjeta in $hola){
    $i++
}
echo "La cantidad de tarjetas de red que hay en este equipo es/son: $i"
