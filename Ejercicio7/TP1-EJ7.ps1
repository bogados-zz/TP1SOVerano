#############################################################################################
# PRIMERA REENTREGA
# PROGRAM-ID.  ejercicio7.ps1					                                            #
# OBJETIVO DEL PROGRAMA: Analiza la estructura de una matriz y determina el tipo al         #
# que corresponde.                                                                          #
# TIPO DE PROGRAMA: .ps1                                                                    #
# ALUMNOS :                                                                                 #                                                                              
#           -Bogado, Sebastian                                                              #
#           -Rey, Juan Cruz                                                                 #
#############################################################################################

<#
.SYNOPSIS 
Analiza la estructura de una matriz y determina el tipo al que corresponde.
.DESCRIPTION
Lee y analiza la estructura de una Matriz cargarda en un Archivo que llega de parametro y filas por salto de linea.
.PARAMETER Path
Especifica el path del archivo que contiene la matriz.
    .EXAMPLE
        ./Ejercicio7.ps1 ./matrices.txt s
        Retorna la suma de las dos matrices del archivo matrices.txt
    .EXAMPLE
       ./Ejercicio7.ps1 ./matrices.txt r
       Retorna la resta de las dos matrices del archivo matrices.txt
    .EXAMPLE
        ./Ejercicio7.ps1 ./matrices.txt m
        Retorna el producto de las dos matrices del archivo matrices.txt
    .EXAMPLE
        ./Ejercicio7.ps1 ./matrices.txt t
        Retorna la trasposicion de la matrices del archivo matrices.txt. En caso de que el archivo tenga dos matrices, retorna la trasposicion de ambas.
#>

Param(
    [Parameter(Position=1, Mandatory=$true)][ValidateScript({Test-Path $_ -PathType leaf -IsValid})][String]$pathMatriz,
    [Parameter(Position=2, Mandatory=$true)][char]$operacion
)

function MultiplicarMatrices{
    param($m1, $cantF1, $cantC1, $m2, $cantF2, $cantC2)
    
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
                $sum += $m1[$i][$k]*$m2[$k][$j];
            }
 
            $res[$i] += ,$sum;
        }
    }

    write 'Solucion Producto:'
    MostrarMatriz $res $cantF1 $cantC1;
}

function TrasponerMatriz{
    param($m1, $cantF1, $cantC1)
    
    $res = @();

    for($i = 0; $i -lt $cantC1; $i++)
    {
        $res += ,@();

        for($j = 0; $j -lt $cantF1; $j++)
        {
            $res[$i] += ,$m1[$j][$i];
        }
    }

    write 'Solucion Trasposicion:'
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



function SumarMatrices{
    param($m1, $cantF1, $cantC1, $m2, $cantF2, $cantC2)
    
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
            $res[$i] += ,($m1[$i][$j] + $m2[$i][$j]);
        }
    }

    write 'Solucion Suma:'
    MostrarMatriz $res $cantF1 $cantC1;
}

function RestarMatrices{
    param($m1, $cantF1, $cantC1, $m2, $cantF2, $cantC2)
    
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
            $res[$i] += ,($m1[$i][$j] - $m2[$i][$j]);
        }
    }

    write 'Solucion Resta:'
    MostrarMatriz $res $cantF1 $cantC1;
}


$matrizFile = Get-Content $pathMatriz
if($matrizFile -eq $null)
{
    Write-Error "Debe ingresar al menos una matriz.";
    return ;
}
$matrices = '';
$matrices = $matrizFile.Split('[\r\n]');
$matriz1 = @();
$matriz2 = @();
$contF1 = 0;
$contC1 = 0;
$contF2 = 0;
$contC2 = 0;

if($matrices.Count -ge 1 -and $matrices -ne '')
{
        
    $filaMat = $matrices[0] -split ";;";

    for($i = 0; $i -lt $filaMat.Count; $i++)
    {
        $matriz1 += ,@();
        
        
        $colFila = $filaMat[$i] -split ";";
        $contF1 = $filaMat.Count;

        if($i -eq 0)
        {
            $contC1 = $colFila.Count;
        }
        else
        {
            if($contC1 -ne $colFila.Count)
            {
                Write-Error "La matriz ingresada es invalida";
                return ;
            }
        }

        for($j = 0; $j -lt $colFila.Count; $j++)
        {
            try
            {
                $matriz1[$i] += ,[double]$colFila[$j];
                  
            }
            catch
            {
                Write-Error "La matriz ingresada es invalida";
                return ;
            }
        }
    }

    if($matrices.Count -eq 2)
    {
        
        $filaMat = $matrices[1] -split ";;";
        

        for($i = 0; $i -lt $filaMat.Count; $i++)
        {
            $matriz2 += ,@();
        
        
            $colFila = $filaMat[$i] -split ";";
            $contF2 = $filaMat.Count;

            if($i -eq 0)
            {
                $contC2 = $colFila.Count;
            }
            else
            {
                if($contC2 -ne $colFila.Count)
                {
                    Write-Error "La matriz ingresada es invalida";
                    return ;
                }
            }

            for($j = 0; $j -lt $colFila.Count; $j++)
            {
                try
                {
                    $matriz2[$i] += ,[double]$colFila[$j];
                  
                }
                catch
                {
                    Write-Error "La matriz ingresada es invalida";
                    return ;
                }
            }
        }
        
        
        switch ($operacion) 
        { 
            's' {SumarMatrices $matriz1 $contF1 $contC1 $matriz2 $contF2 $contC2;} 
            'r' {RestarMatrices $matriz1 $contF1 $contC1 $matriz2 $contF2 $contC2;} 
            'm' {MultiplicarMatrices $matriz1 $contF1 $contC1 $matriz2 $contF2 $contC2;} 
            't' {TrasponerMatriz $matriz1 $contF1 $contC1; TrasponerMatriz $matriz2 $contF2 $contC2;} 
            default 
            {
                Write-Error "Operación Inválida.";
                return ;
            }
        }
        
                
    }
    else
    {
        if($matrices.Count -gt 2)
        {
            Write-Error "No puede ingresar mas de dos matrices.";
            return ;
        }

        if($operacion -eq 's' -or $operacion -eq 'r' -or $operacion -eq 'm')
        {
            Write-Error "Para la operación a realizar debe ingresar dos matrices.";
            return ;
        }
        else
        {
            if($operacion -eq 't')
            {
                TrasponerMatriz $matriz1 $contF1 $contC1;
            }
            else
            {
                Write-Error "Operación Inválida.";
                return ;
            }
        }
    }
}
else
{
    Write-Error "Debe ingresar al menos una matriz.";
    return ;
}