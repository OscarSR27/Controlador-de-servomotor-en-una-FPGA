`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Edgar Gutierrez y Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Control de un servomotor
//
//Descripcion: En este modulo se realiza la operacion binaria de multiplicacion
//////////////////////////////////////////////////////////////////////////////////
module Multiplicacion
#(parameter Magnitud = 8, Decimal = 16) // Se parametriza para hacer flexible el cambio de ancho de palabra
//Declaracion de senales de entrada y salida
(
	input wire signed[N-1:0]A,B,
	output reg signed[N-1:0]multi
);
//Declaracion de parametros locales 
	 localparam  N = (Decimal + Magnitud + 1), //Se calcula el ancho de palabra
					 M = (2**(N-1)-1),
					 maximo = M[N-1:0], // Se determina el valor maximo que se puede representar con N bits
					 m = (2**(N-1)+1),	
					 minimo = m[N-1:0]; // Se determina el valor minimo que se puede representar con N bits
					 
//Declaracion de senales utilizadas dentro del modulo
reg signed[2*N-1:0]MultiAux;
reg overflow, underflow;
always @* //Lista sensitiva, responde ante cualquier cambio de senal
	begin
	MultiAux =A*B; //Se realiza la multiplicacion de los operandos A y B. El resultado es del doble de sus operandos y se distribuye como sigue:
						//1 bit de signo		1 bit de signo		Magnitud		Magnitud		Decimal		Decimal
		if ((A[N-2:0] == 0) || (B[N-2:0] == 0))//Si los dos operandos son cero el resultado es cero
			multi = 0;
		else
		begin
			if ((A[N-1] == B[N-1]) && ((MultiAux[2*N-1:(Magnitud+Decimal+Decimal)] > 0)))//Evaluacion de las condiciones para overflow
				multi = maximo;
			else if  ((A[N-1] != B[N-1]) && (~(&(MultiAux[2*N-1:(Magnitud+Decimal+Decimal)])) == 1'b1))//Evaluacion para las condiciones de underflow
				multi = minimo;
			else
				multi = {MultiAux[2*N-1], MultiAux[(Magnitud+Decimal+Decimal-1):Decimal]};//Resultado de multiplicacion que no presenta ni overflow ni underflow
		end																									  //El resultado se forma con el MSB y  concatenando los bits de Magnitud
	end																										  //mas cercanos al MSB con los bits de Decimal mas cercanos al MSB
endmodule

