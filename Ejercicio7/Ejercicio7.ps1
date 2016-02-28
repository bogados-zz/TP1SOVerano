#############################################################################################
# PROGRAM-ID.  ejercicio7.ps1					                                            #
# OBJETIVO DEL PROGRAMA: Analiza la estructura de una matriz y determina el tipo al         #
# que corresponde.                                                                          #
# TIPO DE PROGRAMA: .ps1                                                                    #
# ALUMNOS :                                                                                 #                                                                              
#           -Bogado, Sebastian                                                              #
#           -Rey, Juan Cruz                                                                 #
# EjemploEj.:                                                                               #
# C:\PS> .\ejercicio4.ps1 C:/miarchivo.txt                                                  #
#############################################################################################

<#
.SYNOPSIS 
Analiza la estructura de una matriz y determina el tipo al que corresponde.
.DESCRIPTION
Lee y analiza la estructura de una Matriz cargarda en un Archivo separada por un caracter que llega de parametro y filas por salto de linea.
.PARAMETER Path
Especifica el path del archivo que contiene la matriz.
.PARAMETER delim
Especifica el caracter separador de las columnas.
.EXAMPLE
c:\PS> ./ejercicio7.ps1 -path C:/matriz.txt -delim '&'
.EXAMPLE
c:\PS> ./ejercicio7.ps1 -path C:/matriz.txt '&'
    
.EXAMPLE
c:\PS> ./ejercicio7.ps1 C:/matriz.txt '&'    
            
#>

Param
(
    [parameter(Position=0, Mandatory=$true)]
    [String]
    [ValidateNotNullOrEmpty()]
    $PathMatriz,

    [parameter(Position=1, Mandatory=$true)]
    [String]
    [ValidateLength(4,20)]
    $Operacion
)


function SumarMatrices{
    param($matriz1, $cantF1, $cantC1, $matriz2, $cantF2, $cantC2)
    
    if($cantF1 -ne $cantF2 -or $cantC1 -ne $cantC2)
    {
        Write-Error 'Las matrices son de distinto orden, no se pueden sumar.';
        return ;
    }
    
    $res = @();

    for($i = 0; $i -lt $cantF1; $i++)
    {
        $res += ,@();

        for($j = 0; $j -lt $cantC1; $j++)
        {
            $res[$i] += ,($matriz1[$i][$j] + $matriz2[$i][$j]);
        }
    }
    MostrarMatriz $res $cantF1 $cantC1;
}

function RestarMatrices{
    param($matriz1, $cantF1, $cantC1, $matriz2, $cantF2, $cantC2)
    
    if($cantF1 -ne $cantF2 -or $cantC1 -ne $cantC2)
    {
        Write-Error 'Las matrices son de distinto orden, no se pueden restar.';
        return ;
    }
    
    $res = @();

    for($i = 0; $i -lt $cantF1; $i++)
    {
        $res += ,@();

        for($j = 0; $j -lt $cantC1; $j++)
        {
            $res[$i] += ,($matriz1[$i][$j] - $matriz2[$i][$j]);
        }
    }
    MostrarMatriz $res $cantF1 $cantC1;
}




function MultiplicarMatrices{
    param($matriz1, $cantF1, $cantC1, $matriz2, $cantF2, $cantC2)
    
    if($cantC1 -ne $cantF2)
    {
        Write-Error 'Las matrices son de distinto orden, no se pueden multiplicar.';
        return ;
    }

    $res = @();

    for ($i = 0; $i -lt $cantF1; $i++) 
    {
        $res += ,@();
        for ($j = 0; $j -lt $cantC2; $j++) 
        {
            $sum = 0;
            for ($k = 0; $k -lt $cantF2; $k++) 
            {
                $sum += $matriz1[$i][$k]*$matriz2[$k][$j];
            }
 
            $res[$i] += ,$sum;
        }
    }
    MostrarMatriz $res $cantF1 $cantC1;
}

function TrasponerMatriz{
    param($matriz1, $cantF1, $cantC1)
    
    $res = @();

    for($i = 0; $i -lt $cantC1; $i++)
    {
        $res += ,@();

        for($j = 0; $j -lt $cantF1; $j++)
        {
            $res[$i] += ,$matriz1[$j][$i];
        }
    }
    MostrarMatriz $res $cantC1 $cantF1;
}

function MostrarMatriz
{
    param($matriz, $cantF, $cantC)

    for($i = 0; $i -lt $cantF; $i++)
    {
        $txt = ''
        for($j = 0; $j -lt $cantC; $j++)
        {
            $txt += $matriz[$i][$j]
            $txt += "`t";
        }
        write $txt;
    }
}

cargarMatriz($matriz, $arrayAux ){
    $matriz= new String[][];
    echo $arrayAux.Count

    $cantidadColumnas=0;
    $contColumnas=0;
    $cantidadFilas=0;

    foreach ($elemento in $arrayAux){
        ##La cantidad de letras del elemento es distinta de cero
        ##Tengo agregarlo a la matriz y sumar 1 a la cantidad de columnas
        if($elemento.Length -ne 0){
            $matriz[$cantidadFilas][$contColumnas]=$elemento;
            $contColumnas++;
        }
        else{

            if( $contColumnas -eq 0 ){
                Write-Error "La matriz no puede contener filas vacias"
                exit
            }
            else{
                if( $cantidadColumnas -eq 0 ){
                    $cantidadColumnas=$contColumnas
                }
                if( $cantidadColumnas -ne $contColumnas ){
                    Write-Error "La fila $cantidadFilas es desigual en la cantidad de columnas. Las columnas anteriores eran de $cantidadColumnas elementos y esta contiene $contColumnas"
                 }
                $cantidadFilas++
            }
        }
    }
}


function abrirYCargarArchivo($PathMatriz){
$delimitadorFilas=";;"
$delimitadorColumnas=";"
$file = Get-Content $PathMatriz
switch($file.count){
        1{
            $matriz
            if($Operacion.CompareTo("trans") -ne 0 ){
                Write-Error "La matriz debe tener 2 elementos para realizar la operacion $Operacion."
                exit
            }
            $arrayAux=$file.Split($delimitadorFilas)
            cargarMatriz $matriz $arrayAux
            TrasponerMatriz     
        }
            
        2{

            $matriz1= New-Object Matriz
            switch($Operacion){
                "suma"
                {
                        
                }
                "resta"
                {
                        
                }
                "multi"
                {
                    
                }
            }

        }
        default{
            Write-Error "Error el archivo debe contener una o dos lineas."
        }
    }
}

Switch($psboundparameters.Count + $args.Count){
    
    #En caso que tenga un parametro o tres funciona y discrimina las funciones#
    2{
        if( Test-Path $PathMatriz ){
            if(Test-Path $PathMatriz -PathType Container){
                Write-Error "El path especificado debe pertenecer a un archivo y no a un directorio";
                exit;
            }
            Write-Debug "Entra por que tiene solo un parametro"
            abrirYCargarArchivo $PathMatriz
        }else{
            Write-Error "El path especificado debe existir";
        }

    }

    default{
        Write-Error "Parametros insuficientes"
    }
}
