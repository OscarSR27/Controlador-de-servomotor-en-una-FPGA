`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Edgar Gutierrez y Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Control de un servomotor
//
//Descripcion: En este modulo se realiza el calculo del error entre la posicion actual y la posicion de referencia
//////////////////////////////////////////////////////////////////////////////////
module CalculoError #(parameter Magnitud=17, Decimal=0, N = Magnitud+Decimal+1)//Se parametriza para hacer flexible el cambio de ancho de palabra
//Declaracion de senales de entrada y salida
	(
		input wire signed [N-1:0]referencia, y,
		output wire signed [N-1:0]error
    );

//Se calcula el error entre la posicion actual y la referencia
Suma #(.N(N)) sum (
    .A(referencia), 
    .B(-(y)), 
    .SUMA(error)
    );


endmodule
