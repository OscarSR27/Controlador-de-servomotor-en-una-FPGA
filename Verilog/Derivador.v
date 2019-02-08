`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Edgar Gutierrez y Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Control de un servomotor
//
//Descripcion: En este modulo se realiza el calculo de la parte derivativa del I_PD
//////////////////////////////////////////////////////////////////////////////////
module Derivador #(parameter Magnitud=17, Decimal=0, N = Magnitud+Decimal+1)//Se parametriza para hacer flexible el cambio de ancho de palabra
//Declaracion de senales de entrada y salida
(
	input wire clk, reset, enable,
	input wire signed [N-1:0]y,
	output wire signed [N-1:0] derivador
);

//Declaracion de senales utilizadas dentro del modulo
wire signed [N-1:0] SalidaSuma,SalidaSuma_R,derivador_R,SalidaRegistro;

//Se instancian las unidades aritmeticas que se requieren para el calculo de la parte derivativa
Registro_Pipeline #(.N(N)) Reg (
    .clk(clk), 
    .reset(reset), 
    .data_in(y), 
    .enable(enable), 
    .q_out(SalidaRegistro)
    );

Suma #(.N(N)) sum (
    .A(y), 
    .B(-(SalidaRegistro)), 
    .SUMA(SalidaSuma)
    );
	 
Registro_N_bits #(.N(N)) Reg_Timing (
    .clock(clk), 
    .reset(reset), 
    .d(SalidaSuma), 
    .q(SalidaSuma_R)
    );

Multiplicacion #(.Magnitud(Magnitud),.Decimal(Decimal)) mult (
    .A(SalidaSuma_R), 
    .B(18'd150), 
    .multi(derivador_R)
    );
	 
Registro_N_bits #(.N(N)) Reg_Timing2 (
    .clock(clk), 
    .reset(reset), 
    .d(derivador_R), 
    .q(derivador)
    );

endmodule

