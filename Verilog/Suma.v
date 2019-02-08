`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Edgar Gutierrez y Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Control de un servomotor
//
//Descripcion: En este modulo se realiza la operacion binaria de suma
//////////////////////////////////////////////////////////////////////////////////
module Suma
#(parameter N = 25)//Se parametriza para hacer flexible el cambio de ancho de palabra
//Declaracion de senales de entrada y salida
(
	input wire signed[N-1:0] A, B,
	output reg signed[N-1:0] SUMA
);
//Declaracion de senales utilizadas dentro del modulo
reg signed[N-1:0] SUMAAux;
reg [N-1:0] maximo;
reg [N-1:0] minimo;
reg [N:0] M,m;

always @* //Lista sensitiva, responde ante cualquier cambio de senal
	begin
	SUMAAux = A+B; //Se realiza la suma de los operandos A y B
	
	M = (2**(N-1)-1); 
	maximo = M[N-1:0] ; // Se determina el valor maximo que se puede representar con N bits	
	m = (2**(N-1)+1); 
	minimo = m[N-1:0]; // Se determina el valor minimo que se puede representar con N bits
	end
	
always @* //Lista sensitiva, responde ante cualquier cambio de senal
begin
	if (A[N-1] == 0 && B[N-1] == 0 && SUMAAux[N-1] == 1)//Condiciones para overflow revisando los signos de los operandos y el resultado
		begin															 //Si el operando A y B son positivos y la suma da negativa, implica un overflow
		SUMA = maximo;
		end
	else if (A[N-1] == 1 && B[N-1] == 1 && SUMAAux[N-1] == 0)//Condiciones para underflow revisando los signos de los operandos y el resultado
		begin																	//Si el operando A y B son negativos y la suma positiva, implica underflow
		SUMA = minimo;
		end
	else
		SUMA = SUMAAux;//Resultado de suma que no presenta ni overflow ni underflow
end
endmodule
