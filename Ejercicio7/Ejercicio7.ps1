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


try{
Add-Type -Language CSharp @"
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

    public class matrizWrapper
    {

        int cantidadColumnas;
        int cantidadFilas;
        System.Collections.ArrayList matriz;

        public matrizWrapper()
        {
            this.matriz = new System.Collections.ArrayList();
            this.cantidadColumnas = this.cantidadFilas = 0;
        }

        public matrizWrapper transponer()
        {
            matrizWrapper matrizAuxiliar = new matrizWrapper();
            matrizAuxiliar.cantidadFilas = this.cantidadColumnas;
            matrizAuxiliar.cantidadColumnas = this.cantidadFilas;
            for(int i=0; i<this.cantidadColumnas; i++)
            {
                for (int j = 0; j < this.cantidadFilas; j++)
                    matrizAuxiliar.matriz.Add(this.matriz[i + j * this.cantidadColumnas]);
                    
            }
            return matrizAuxiliar;
        }
        public matrizWrapper restar(matrizWrapper otraMatriz)
        {
            if (this.cantidadColumnas != otraMatriz.cantidadColumnas || this.cantidadFilas != otraMatriz.cantidadFilas)
            {
                System.Console.Error.Write("Error, las matrices deben ser iguales tanto en filas como en columnas");
            }
            matrizWrapper matrizResultado = new matrizWrapper();
            matrizResultado.cantidadFilas = this.cantidadFilas;
            matrizResultado.cantidadColumnas = this.cantidadColumnas;
            for(int i =0; i < this.cantidadColumnas * this.cantidadFilas; i++)
            {
                matrizResultado.matriz.Add((double)this.matriz[i] - (double)otraMatriz.matriz[i]);
            }
            
            return matrizResultado;
        }

        public matrizWrapper sumar(matrizWrapper otraMatriz)
        {
            if (this.cantidadColumnas != otraMatriz.cantidadColumnas || this.cantidadFilas != otraMatriz.cantidadFilas)
            {
                System.Console.Error.Write("Error, las matrices deben ser iguales tanto en filas como en columnas");
            }
            matrizWrapper matrizResultado = new matrizWrapper();
            matrizResultado.cantidadFilas = this.cantidadFilas;
            matrizResultado.cantidadColumnas = this.cantidadColumnas;
            for (int i = 0; i < this.cantidadColumnas * this.cantidadFilas; i++)
            {
                matrizResultado.matriz.Add((double)this.matriz[i] + (double)otraMatriz.matriz[i]);
            }

            return matrizResultado;
        }

        private bool validarMatriz(string[] linea)
        {
            this.cantidadFilas = linea.Length;
            this.cantidadColumnas = linea[0].Split(';').Length;
            for (int i=0; i<this.cantidadFilas;i++)
            {
                string[] fila = linea[i].Split(';');
                if (fila.Length != this.cantidadColumnas)
                {
                    return false;
                }
                else
                {
                    //añado los elementos de la fila presente
                    for (int j = 0; j < this.cantidadColumnas; j++)
                    {
                        //Lo convierto en un double
                        try
                        {
                            matriz.Add(Convert.ToDouble(fila[j]));
                        }
                        catch(FormatException)
                        {
                            System.Console.Error.Write("Error, el contenido de los elementos deben ser numeros reales");
                            System.Environment.Exit(-1);
                        }
                        
                    }
                }
            }
            return true;
        }


            public void mostrarMatriz()
        {
            for (int i = 0; i < this.cantidadFilas; i++)
            {
                string linea = "";
                for (int j = 0; j < this.cantidadColumnas; j++)
                {
                    linea += this.matriz[i * this.cantidadColumnas + j] + "|";
                }
                System.Console.WriteLine(linea);

            }
        }

        public void holaMundo()
        {
            System.Console.WriteLine("Hola mundo de los sistemas operativos");
        }

        public void setLineaTexto(String linea)
        {
            string[] lineaArchivo = Regex.Split(linea, ";;");
            if (!validarMatriz(lineaArchivo))
            {
                System.Console.Error.Write("Error en la cantidad de columnas");
                System.Environment.Exit(-1);
            }
        }
    }

"@;
}
catch [RuntimeException]
{
    Write-Host "Ya se encuentra la clase"    
}


function abrirYCargarArchivo(){
    if( Test-Path $PathMatriz ){
        if(Test-Path $PathMatriz -PathType Container){
            Write-Error "El path especificado debe pertenecer a un archivo y no a un directorio";
            exit;
        }
        $file = Get-Content $PathMatriz
        switch($file.count){
            1{
                if($Operacion.CompareTo("trans") -ne 0 ){
                    Write-Error "La matriz debe tener 2 elementos para realizar la operacion $Operacion."
                    exit
                }
                $array=New-Object matrizWrapper
                $array.setLineaTexto($file)
                $array.transponer().mostrarMatriz()
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
                Write-Error "Error el archivo debe contener dos o una linea."
            }
        }

    }
    else{
        Write-Error "El path no existe"
    }
}

Switch($psboundparameters.Count + $args.Count){
    
    #En caso que tenga un parametro o tres funciona y discrimina las funciones#
    2{
        Write-Debug "Entra por que tiene solo un parametro"
        abrirYCargarArchivo
    }

    default{
        Write-Error "Parametros insuficientes"
    }
}
