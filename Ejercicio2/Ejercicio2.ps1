<#
.SYNOPSIS
El script copia los archivos de texto que contengan una cadena determinada a un directorio destino

.DESCRIPTION
El script copia los archivos de texto que contengan una cadena determinada a un directorio destino
Para ello, se necesita tener el directorio origen del archivo txt a copiar, directorio destino y la cadena que se quiera buscar en los archivos
Al finalizar la copia, se debe crear un archivo de log en donde se indique La fecha y hora de ejecución del script,
el directorio de origen, el tamaño y la fecha de modificación de cada uno de los archivos copiados
y La cantidad de veces que se repite la palabra dentro del archivo.

.PARAMETER cadenaABuscar
Palabra de texto que se buscara en cada uno de los archivos del directorio especificado

.PARAMETER directorioOrigen
Directorio donde contenga los archivos txt que se quieren encontrar con la cadena dada por parametro

.PARAMETER directorioDestino
Directorio donde se copiaran los arhcivos


.EXAMPLE
C:\Windows> .\ej2.ps1 -cadena aprobado -pathOrigen 'D:\archivosTxt' -pathDestino D:\salida  

.EXAMPLE
C:\Windows> .\ej2.ps1 palabra .\directorioOrigen d:\directorioDestino 

.EXAMPLE
C:\Windows> .\ej2.ps1 lapicera -directorioOrigen ./txtFiles -directorioDestino ./ 
#>

Param(
[Parameter(Mandatory = $true)][String] $origen,
[Parameter(Mandatory = $true)][String] $destino,
[Parameter(Mandatory = $true)][String] $cadena
)

<#Podria testeo los directorios#>
$path1 = Test-Path $origen
$path2 = Test-Path $destino

if($path1 -ne $true){
    echo "El directorio origen debe ser valido"
    exit
}

if($path2 -ne $true){
    echo "El directorio destino debe ser valido"
    exit
}




if($path1 -eq $true -and $path2 -eq $true){

    #$directorio = Get-ChildItem -Path $origen| Where {$_.psIsContainer -eq $false}<#$true si quiero listar directorio#>
    #$directorio = Get-ChildItem -Path $origen -Recurse | Where {$_.psIsContainer -eq $false}<#$true si quiero listar directorio#>
    $directorio = ls -Path $origen -Recurse -Include "*.txt"
    $fechaYHoraScript = Get-Date
    $fechaYHoraScript >$destino\archivoLog.log

    foreach($file in $directorio){
        $cant = 0
        $copio = $false
        $textFile = Get-Content -Path $file
        foreach($linea in $textFile){
            if($linea -match $cadena){
                $cant++
                $copio = $true
            }
            else{}        
        }
        if($copio -eq $true){
            cp $file -Destination $destino
            $new = dir -Path $file| Format-List -Property Directory, Length, LastWriteTime
            $new,$cant >> $destino\archivoLog.log #$new, $cant concateno al escribir
        
            }
    }
}
