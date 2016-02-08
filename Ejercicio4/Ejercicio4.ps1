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

[cmdLetbinding()]
param(
      [Parameter(position=0)]
      [ValidateLength(1,2)]
      [String]$flag="-h",

      [Parameter(position=1)]
      [ValidateLength(1,50)]
      [String]$file_origen="origen",

      [Parameter(position=2)]
      [ValidateLength(1,50)]
      [String]$file_destino="destino"
      )



Function  Comprimir
{
[CmdletBinding()]
  param
  (
      [Parameter(Mandatory=$true, position=0)]
      [ValidateLength(1,60)]
      [String]$pathOrigen,

      [Parameter(Mandatory=$true, position=1)]
      [ValidateLength(1,60)]
      [String]$pathDestino
  )

    try
    {
        if(test-path -Path $pathOrigen)
        {
            #if(test-path -Path $pathDestino)
            #{     
                #Agrego la libreria necesaria para comprimir archivos                           
                Add-Type -Assembly "System.IO.Compression.FileSystem" 
                $instancia = [System.IO.Compression.ZipFile]
                try
                {
                    Write-Host "Comprimiendo Archivos..."
                    #Guardo el backup
                    $instancia::CreateFromDirectory($pathOrigen,$pathDestino)

                }
                Catch [System.IO.IOException]
                {
                    echo "Error: El archivo ya existe."
                }
                Catch
                {
                    echo "Error al crear el archivo comprimido."   
                }
            # }
             #else
             #{
             #   echo "$($pathDestino) Path de salida no valido"
             #   exit 1
             #}
         }
         else
         {
            echo "$($pathOrigen) Path de origen no valido"
            exit 1;
         }
    }
    catch
    {
        echo "Error al ejecutar el script"
    }
}

Function  Descomprimir
{
[CmdletBinding()]
  param
  (
      [Parameter(Mandatory=$true, position=0)]
      [ValidateLength(1,60)]
      [String]$pathOrigen,

      [Parameter(Mandatory=$true, position=1)]
      [ValidateLength(1,60)]
      [String]$pathDestino
  )
 
    try
    {
        if(test-path -Path $pathOrigen)
        {
            if(test-path -Path $pathDestino)
            {     
                #Agrego la libreria necesaria para descomprimir archivos

                Add-Type -AssemblyName 'System.IO.Compression.Filesystem'
                $instancia = [System.IO.Compression.ZipFile]
                try
                {
                    Write-Host "Descomprimiendo Archivos..."
                    #Guardo el backup
                    $instancia::ExtractToDirectory($pathOrigen, $pathDestino) | Format-Table

                }
                Catch [System.IO.IOException]
                {
                    echo "Error: El archivo ya existe o ya ha sido descomprimido en esa ruta."
                }
                Catch
                {
                    echo "Error al crear el archivo comprimido."   
                }
             }
             else
             {
                echo "$($pathDestino) Path de salida no valido"
                exit 1
             }
         }
         else
         {
            echo "$($pathOrigen) Path de origen no valido"
            exit 1;
         }
    }
    catch
    {
        echo "Error al ejecutar el script"
    }
}


Function  MostrarZip
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, position=0)]
        [ValidateLength(1,50)]
        [String]$FileName
    )
    
    [Void][Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem')            
    $ObjArray = @()            
    foreach($zipfile in $FileName) {    
        if(Test-Path $ZipFile) { 
            $RawFiles = [IO.Compression.ZipFile]::OpenRead($zipFile).Entries            
            foreach($RawFile in $RawFiles) {  
                $object = New-Object -TypeName PSObject
                $Object | Add-Member -MemberType NoteProperty -Name FileName -Value $RawFile.Name
                #$Object | Add-Member -MemberType NoteProperty -Name FullPath -Value $RawFile.FullName
                #$Object | Add-Member -MemberType NoteProperty -Name CompressedLengthInKB -Value ($RawFile.CompressedLength/1KB).Tostring("00")
                $Object | Add-Member -MemberType NoteProperty -Name UnCompressedLengthInKB -Value ($RawFile.Length/1KB).Tostring("00")
                #$Object | Add-Member -MemberType NoteProperty -Name FileExtn -Value ([System.IO.Path]::GetExtension($RawFile.FullName))
                #$Object | Add-Member -MemberType NoteProperty -Name ZipFileName -Value $zipfile
                $ObjArray += $Object
                if(!$ExportCSVFileName) {
                    $Object
                }  
            }
        } else {
            Write-Warning "$ZipFileInput Archivo no encontrado"            
        }
    }
}


switch ($flag) 
{ 
    "-v" {MostrarZip $file_origen}
    "-c" {Comprimir $file_destino $file_origen} 
    "-d" {Descomprimir $file_origen $file_destino}
    default {"La opcion elegida en el primer parametro no es valida"}
}
