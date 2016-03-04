<#
.SYNOPSIS
Permita manipular archivos .zip.
.DESCRIPTION
 Dependiendo el parámetro que se le pase, puede realizar diferentes tareas: 
    -v archivo.zip: Muestra un lisado del nombre y peso de cada uno de los archivos contenidos en “archivo.zip”.
    -d archivo.zip destino: Descomprime “archivo.zip” en el directorio “destino”.
    -c archivo.zip origen: Comprime el directorio “origen” en “archivo.zip”.

.EXAMPLE
    Ejemplo de muestra de contenido:
.\Ejercicio4.ps1 '-v' 'C:\Users\Igna\Desktop\Descomprimir\todo.zip'

.EXAMPLE
Ejemplo de compresión:
./Ejercicio4.ps1 '-c'  'C:\Users\Igna\Desktop\Descomprimir\todo.zip' 'C:\Users\Igna\Desktop\Datos\' 

.EXAMPLE
Ejemplo de compresión:
.\Ejercicio4.ps1  '-d' 'C:\Users\Igna\Desktop\Descomprimir\todo.zip' 'C:\Users\Igna\Desktop\Destino\'
	
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True, position=1, ParameterSetName=”v")][switch] $v,
    [Parameter(Mandatory=$True, position=1, ParameterSetName=”d")][switch] $d,
    [Parameter(Mandatory=$True, position=1, ParameterSetName=”c")][switch] $c,
    [Parameter(Mandatory=$True, position=2)][String] $directorio1,
    [Parameter(Mandatory=$False, position=3)][ValidateScript({Test-Path $_ -PathType "Container" -isValid})][String] $directorio2
    )

Add-Type -AssemblyName "System.IO.Compression.FileSystem"

$path_actual = Get-Location
if (! ($directorio1 -match "C:" -or $directorio1 -match "c:" )){
    $directorio1=Join-Path $path_actual $directorio1
}

if ($v.IsPresent){
    $elementos = [IO.Compression.ZipFile]::OpenRead("$directorio1").Entries
    $elementos | Format-Table -Property Name, Length -AutoSize
}    
else{
    if( ! ($directorio2 -eq $null -or $directorio2 -eq "") ){

        if (! ($directorio2 -match "C:" -or $directorio2 -match "c:" )){
            $directorio2=Join-Path $path_actual $directorio2
        }
        

        if($d.IsPresent) {
            if(Test-Path $directorio1)
            {
                $elementos = [IO.Compression.ZipFile]::OpenRead("$directorio1").Entries

                foreach($element in $elementos)
                {
                    $arch=Join-Path $directorio2 $element.FullName
                    if(Test-Path $arch)
                    {
                        Write-Error "Uno o mas de los archivos a descomprimir existe en el directorio de destino."
                        return;
                    }
                }
                Write-Host "Se esta descomprimiendo el archivo"
                [IO.Compression.ZipFile]::ExtractToDirectory("$directorio1","$directorio2")
                Write-Host "El archivo se descomprimio correctamente"
            }
            else
            {
                Write-Error "EL archivo a descomprimir es incorrecto o no existe."
                return;
            }


        }
        else{
            if(Test-Path $directorio1)
            {
                Write-Error "El archivo ya se encuentra creado"
                return;
            }
            try{
                Write-Host "Se esta comprimiento el archivo..."
                [IO.Compression.ZipFile]::CreateFromDirectory("$directorio2","$directorio1")
                Write-Host "El archivo se ha comprimido correctamente"
            }
            catch [System.IO.IOException]{
                Write-Error "Error con alguno de los dos archivos revise que existan los directorios, para poder crear el archivo."
            }
            catch{
                Write-Error "Error al comprimir el archivo"
            }
            
        }
    }else{
        Write-Error "El segundo parametro es obligatorio para ejecutar esta funcionalidad."
        return;
    }
}