<#
.SYNOPSIS
Realiza un backup de su base de datos en un archivo de texto plano

.DESCRIPTION
Lee el archivo de backup y genere un archivo CSV. La primer fila del archivo CSV contiener los nombres de los campos 

.PARAMETER pathEntrada
Ruta archivo que se migrara al csv

.PARAMETER pathSalida
Ruta donde se exportara el archivo csv

.EXAMPLE
C:\PS> .\ejercicio3.ps1 D:\Prueba.txt -pathSalida D:\Backup\Salida.csv 
     
.EXAMPLE
C:\PS> .\ejercicio3.ps1 .\file.txt ./salida.c

.EXAMPLE
C:\PS> .\ejercicio3.ps1 .\file.txt ./salida.csv

#>

param(
    [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string] $path_archivo,
    [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string] $path_resultado
)


if(test-path -Path $path_archivo)
{}else{
    echo "$($path_archivo) Path de origen no valido"
    exit 1;
}
#$path_archivo = "C:\Users\Igna\Desktop\csv.txt";
#$path_resultado = "C:\Users\Igna\Desktop\csv.csv";


$cont=0; #inicializo contador
$registroArray =@() #inicializo array


$linea = (Get-Content $path_archivo);
$objetoCreado=$false
$cont=0
$registro;
foreach($aux in  $linea)
{
    if($aux -eq "///"){
        if($objetoCreado -eq $true -and $cont -ne 0){
            $objetoCreado
            $cont = 0;
            $objetoCreado=$false
            $registroArray += $registro
        }
    }
    else
    {
            if($aux.Contains('='))
            {
                $partes = $aux.Split('=');   
                if($cont -eq 0) #es un nuevo registro de la BD
                {
                    #creo un objeto y le agrego como clave el nombre del campo y valor el contenido del campo
                    $registro = new-object PSObject
                    $registro | add-member -membertype NoteProperty -name $partes[0] -Value $partes[1] 
                    $objetoCreado=$true
                    #write $registro  
                }
                else
                {
                        $registro  | add-member -membertype NoteProperty -name $partes[0] -Value $partes[1]
                }
                $cont++
            }
    }
  
     
    <#if($cont -eq 3) #fin del registro BD 
    {
      $registroArray += $registro 
    }#>
}
 if($objetoCreado -eq $true -and $cont -ne 0){
            $objetoCreado
            $cont = 0;
            $objetoCreado=$false
            $registroArray += $registro
}

write $registroArray | Format-Table
try{
    $registroArray| Export-csv -Delimiter ";" $path_resultado -NoTypeInformation #el -notypeinformation sirve para que no grabe que tipo de objeto que exporto 
}
catch
{
    Write-Output "Error al exportar archivo csv"
}