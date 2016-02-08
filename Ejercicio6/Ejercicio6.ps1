#############################################################################################
# PROGRAM-ID.  ejercicio6.ps1					                                            #
# OBJETIVO DEL PROGRAMA: Permite mantener ejecutando un proceso                             #          
# TIPO DE PROGRAMA: .ps1                                                                    #
# ALUMNOS :                                                                                 #                                                                              
#           -Bogado, Sebastian                                                              #
#           -Gutierrez, Rubén                                                               #
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
        [String]$npid
      )

function registrarProceso([System.Diagnostics.Process] $process){
    $path = $process.Path
    Register-ObjectEvent -InputObject $process -EventName "exited" -Action{
        $process = (Start-Process -FilePath $path -PassThru -Wait)
        registrarProceso $process
    }

}


$process = Get-Process -id $npid
registrarProceso $process
while($true){
    
}
