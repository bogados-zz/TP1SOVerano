#############################################################################################
# PROGRAM-ID.  ejercicio6.ps1					                                            #
# OBJETIVO DEL PROGRAMA: Permite mantener ejecutando un proceso                             #          
# TIPO DE PROGRAMA: .ps1                                                                    #
# ALUMNOS :                                                                                 #                                                                              
#           -Bogado, Sebastian                                                              #
#           -Rey, Juan Cruz                                                                 #
# EjemploEj.:                                                                               #
# C:\PS> .\ejercicio6.ps1 C:/miarchivo.txt                                                  #
#############################################################################################
<#
.SYNOPSIS
Permite Mantener Ejecutando un Proceso

.DESCRIPTION
  Si el proceso termina,el Script vuelve a ejecutarlo automáticamente.
  
.EXAMPLE
    Ejemplo de funcionamiento:
    .\Ejercicio6.ps1 17556

#>
[cmdLetbinding()]
param(
        [parameter(Position=0, Mandatory=$true)]
        [int]$npid
      )
      
function evento
{
    param($processPathArg)
    $new = Start-Process -FilePath $processPathArg -PassThru;
    $process = Get-Process -Id $new.Id;
    $processPath = $process.Path;
    Register-ObjectEvent -InputObject $process -EventName "Exited" -Action {evento $processPath;}
};

$process = Get-Process -Id $npid;
$processPath = $process.Path;

Register-ObjectEvent -InputObject $process -EventName "Exited" -Action {evento $processPath;}
