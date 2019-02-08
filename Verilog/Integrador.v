`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Edgar Gutierrez y Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Control de un servomotor
//
//Descripcion: En este modulo se realiza el calculo de la parte integrativa del I_PD
//////////////////////////////////////////////////////////////////////////////////
module Integrador #(parameter Magnitud=17, Decimal=0, N = Magnitud+Decimal+1)//Se parametriza para hacer flexible el cambio de ancho de palabra
//Declaracion de senales de entrada y salida
(
	input wire clk, reset, enable,
	input wire signed [N-1:0]error,
	output wire signed [N-1:0] integrador
);

//Declaracion de senales utilizadas dentro del modulo
wire signed [N-1:0] SalidaMultiplicacion,SalidaMultiplicacion_R,SalidaRegistro,error_R;

//Se instancian las unidades aritmeticas que se requieren para el calculo de la parte integrativa
Registro_N_bits #(.N(N)) Reg_Timing (
    .clock(clk), 
    .reset(reset), 
    .d(error), 
    .q(error_R)
    );

Multiplicacion #(.Magnitud(Magnitud),.Decimal(Decimal)) mult (
    .A(18'd7), 
    .B(error_R), 
    .multi(SalidaMultiplicacion)
    );
	 
Registro_N_bits #(.N(N)) Reg_Timing2 (
    .clock(clk), 
    .reset(reset), 
    .d(SalidaMultiplicacion), 
    .q(SalidaMultiplicacion_R)
    );
	 
Suma #(.N(N)) sum (
    .A(SalidaRegistro), 
    .B(SalidaMultiplicacion_R), 
    .SUMA(integrador)
    );

Registro_Pipeline #(.N(N)) Reg (
    .clk(clk), 
    .reset(reset), 
    .data_in(integrador), 
    .enable(enable), 
    .q_out(SalidaRegistro)
    );

endmodule
