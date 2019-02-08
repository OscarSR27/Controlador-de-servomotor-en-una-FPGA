`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Edgar Gutierrez y Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Control de un servomotor
//
//Descripcion: En este modulo se realiza el calculo de la parte proporcional del I_PD
//////////////////////////////////////////////////////////////////////////////////
module Proporcional #(parameter Magnitud=17, Decimal=0, N = Magnitud+Decimal+1)//Se parametriza para hacer flexible el cambio de ancho de palabra
//Declaracion de senales de entrada y salida
(
	input wire clk, reset,
	input wire signed [N-1:0]y,
	output wire signed [N-1:0]proporcional
);

//Declaracion de senales utilizadas dentro del modulo
wire signed [N-1:0]proporcional_R;

//Se instancian las unidades aritmeticas que se requieren para el calculo de la parte proporcional	 
Multiplicacion #(.Magnitud(Magnitud),.Decimal(Decimal)) mult (
    .A(18'd18), 
    .B(y), 
    .multi(proporcional_R)
    );
	 
Registro_N_bits #(.N(N)) Reg_Timing (
    .clock(clk), 
    .reset(reset), 
    .d(proporcional_R), 
    .q(proporcional)
    );

endmodule
