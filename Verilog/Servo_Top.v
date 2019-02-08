`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Edgar Gutierrez y Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Control de un servomotor
//
//Descripcion: Este es el modulo principal en donde se realiza la instanciacion de todos los submodulos digitales que conforman el controlador para el 
//servomotor
//////////////////////////////////////////////////////////////////////////////////
module Servo_Top #( parameter ADC_A=12,Ref_A=8,Magnitud=17, Decimal=0, N = Magnitud+Decimal+1)
//Declaracion de senales de entrada y salida
(
 input wire Clock_Nexys,Reset,reset_Clck,
 input wire data_ADC,start,
 input wire signed [11:0] Entrada_referencia,
 output wire CS,Clock_Muestreo,
 output wire [3:0] data_basura,
 output wire pwm_out,
 output wire signed [N-1:0]IPD
 );

//Declaracion de senales utilizadas dentro del modulo
wire signed [N-1:0] yk,Referencia; // Entradas del IPD 
wire signed [ADC_A-1:0] Adc_out,Adc_OFF, refe_OFF; // Datos utilizados para los datos provenientes del ADC y el ajuste de los mismos asi como el ajuste
																	// de la referencia
wire signed [Ref_A-1:0] Entrada_PWM; // Entrada PWM 

//Se instancia la interfaz con el ADC para la captura de los datos entrantes
Prueba_ADC ADC (
    .Clock_Nexys(Clock_Nexys), 
    .Reset(Reset), 
    .reset_Clck(reset_Clck), 
    .data_ADC(data_ADC), 
    .start(start), 
    .done(done), 
    .CS(CS), 
    .Clock_Muestreo(Clock_Muestreo), 
    .data_basura(data_basura), 
    .Dato(Adc_out)
    );

//Suma que se hace con los datos del ADC para eliminar el offset
Suma #(.N(ADC_A)) offset_adc ( 
    .A(Adc_out), 
    .B(-(12'd2048)), 
    .SUMA(Adc_OFF)
    );

//Se hace una extension de signo del dato que viene del ADC para ajustar el ancho de palabra con las operaciones aritmeticas hechas en el I_PD
assign yk = {Adc_OFF[11],Adc_OFF[11],Adc_OFF[11],Adc_OFF[11],Adc_OFF[11],Adc_OFF[11],Adc_OFF}; 

//Suma que se hace con los datos de la referencia para eliminar el offset
Suma #(.N(ADC_A)) ofset_referencia ( 
    .A(Entrada_referencia),                      
    .B(-(12'd2048)), 
    .SUMA(refe_OFF)
    );

//Se hace una extension de signo del dato que viene de la referencia para ajustar el ancho de palabra con las operaciones aritmeticas hechas en el I_PD
assign Referencia = {refe_OFF[11],refe_OFF[11],refe_OFF[11],refe_OFF[11],refe_OFF[11],refe_OFF[11],refe_OFF};

//Se instancia tanto el I_PD como las operaciones necesarias para ajustar el resultado antes de ingresar al PWM
Acondicionamiento tratamiento_IPD (
    .clk(Clock_Nexys), 
    .reset(Reset), 
    .enable(done), 
    .referencia(Referencia), 
    .y(yk),
    .IPD(IPD), 	 
    .Entrada_PWM(Entrada_PWM)
    );

//PWM para la conversion digital-analogica
PWM #(.N(Ref_A)) pwm (
    .Clock(Clock_Nexys), 
    .reset(Reset), 
    .Entrada(Entrada_PWM), 
    .pwm_out(pwm_out)
    );

endmodule
