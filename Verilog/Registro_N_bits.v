`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Edgar Gutierrez y Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Control de un servomotor
//
//Descripcion: En este modulo se genera un registro de transmision de datos paralelo-paralelo
//////////////////////////////////////////////////////////////////////////////////
module Registro_N_bits

#(parameter N = 6)//Se parametriza para hacer flexible el cambio de ancho de palabra
//Declaracion de senales de entrada y salida
(
  input wire clock,
  input wire reset,
  input wire signed  [N-1:0] d ,
  output reg signed [N-1:0] q  
); 

always @(posedge clock , posedge reset) //Lista sensitiva, responde ante un flanco positivo del clock o reset
	 if (reset)
		q <= 0; // Si reset esta en alto salidas en 0
	else 
      q <= d; // Si el enable esta en alto q toma el valor de la entrada d 
endmodule

