`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Edgar Gutierrez y Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Control de un servomotor
//
//Descripcion: En este modulo se realiza la instanciacion de la maquina de estados para el ADC y del divisor de frecuencia que genera la senal de reloj
//					utilizada. Tambien se instancia el modulo que genera la frecuencia de muestreo
//////////////////////////////////////////////////////////////////////////////////

module Prueba_ADC
//Declaracion de senales de entrada y salida
(
input wire Clock_Nexys,Reset,reset_Clck,
input wire  data_ADC,start,
output wire done,CS,Clock_Muestreo,
output wire [3:0] data_basura,
output wire [11:0] Dato
);
//Declaracion de senales utilizadas dentro del modulo
wire Clock_out;
assign Clock_Muestreo = Clock_out;

//Instanciacion del divisor de frecuencia para generar la senal de reloj de 3.2 KHz usada en la maquina de estados que captura el dato del ADC
Divisor_Clock_ADC divisor (
    .Clck_in(Clock_Nexys), 
    .reset_Clock(reset_Clck), 
    .Clock_out(Clock_out)
    );

//Maquina de estados para capturar el dato proveniente del ADC
Protocolo_ADC obtener_dato (
    .Clock_Muestreo(Clock_Muestreo), 
    .reset(Reset), 
    .data_ADC(data_ADC), 
    .start(start), 
    .FS(FS), 
    .done(done), 
    .CS(CS), 
    .Enable_divisor(Enable_divisor), 
    .data_basura(data_basura), 
    .Dato(Dato)
    );
	 
//Instanciacion del divisor de frecuencia para generar la frecuencia de muestreo del ADC
tiempodemuestreo muestreo (
    .Clck_in(Clock_Nexys), 
    .enable(Enable_divisor), 
    .reset_Clock(reset_Clck), 
    .Clock_out(FS)
    );

endmodule
