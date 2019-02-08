`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Edgar Gutierrez y Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Control de un servomotor
//
//Descripcion: En este modulo se realiza el calculo del I_PD asi como el ajuste aritmetico y truncamiento para la salida del I_PD antes de ingresar 
//					al PWM
//////////////////////////////////////////////////////////////////////////////////
module Acondicionamiento #(parameter Magnitud=17, Decimal=0, N = Magnitud+Decimal+1, ADC = 12)//Se parametriza para hacer flexible el cambio de ancho de palabra
//Declaracion de senales de entrada y salida
(
		input wire clk, reset, enable,
		input wire signed [N-1:0]referencia, y,
		output wire signed [7:0]Entrada_PWM,
		output wire signed [N-1:0]IPD

);

//Declaracion de senales utilizadas dentro del modulo
wire signed [N-1:0] SalidaMultiplicacion,IPD_R;
wire signed [ADC-1:0] Sal;


//Modulo que implementa el I_PD
I_PD #(.Magnitud(Magnitud), .Decimal(Decimal), .N(N)) Sal_IPD (
    .clk(clk), 
    .reset(reset), 
    .enable(enable), 
    .referencia(referencia), 
    .y(y), 
    .IPD(IPD)
    );

//Registro que guarda el valor de salida del I_PD para ajuste aritmetico 
Registro_N_bits #(.N(N))Reg_Timing (
    .clock(clk), 
    .reset(reset), 
    .d(IPD), 
    .q(IPD_R)
    );

//Las siguientes operaciones ajustan aritmeticamente el valor final del I_PD para compensar los cambios hechos a la entrada y durante las operaciones
//del I_PD
Multiplicacion #(.Magnitud(Magnitud),.Decimal(Decimal)) mult (
    .A(18'd2), 
    .B(IPD_R), 
    .multi(SalidaMultiplicacion)
    );
//Suma de offset eliminado a la entrada de los datos provenientes del ADC y la referencia
Suma #(.N(ADC)) Suma_Integrador_Proporcional (
    .A(SalidaMultiplicacion[N-1:N-12]), 
    .B(12'd2048), 
    .SUMA(Sal)
    );

assign Entrada_PWM = Sal[ADC-1:ADC-8];//Truncamiento de 8 bits de la senal de salida del I_PD

endmodule
