`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Control de un servomotor
//
//Descripcion: En este modulo se realiza un divisor de frecuencia para obtener la frecuencia de muestreo del ADC, la cual es de 100Hz
//					Esto se realiza con ayuda de un contador
//////////////////////////////////////////////////////////////////////////////////
module tiempodemuestreo
//Declaracion de senales de entrada y salida
(
 input wire Clck_in,enable,
 input wire reset_Clock,
 output reg Clock_out
 ); 
 
 //Declaracion de senales utilizadas dentro del modulo
 reg [18:0] contador; 


 
always @(posedge Clck_in,posedge reset_Clock) //Lista sensitiva, responde ante un flanco positivo del Clck_in o reset_Clock
 begin
      if (reset_Clock) //Si el reset esta encendido el contador permanece en cero y la salida de reloj que se quiere generar tambien
		   begin
		   Clock_out <= 0;
			contador <= 0;
			end 
      else if (enable)
          begin		// Cuando el contador llega a la cuenta de 499999 cambia la polaridad del reloj de salida y reinicia la cuenta, generando un reloj
							// de 100Hz. El valor de 499999 necesario para obtener esta senal de reloj se obtuvo redondeando al entero mas cercano el resultado
							// de la siguiente formula: [(100MHz/100Hz)/2]-1. Donde 100MHz es el reloj interno de la FPGA y 100Hz el reloj deseado.
		    if (contador == 19'd499999)  
		        begin                    
			     contador <=19'd0;       
		        Clock_out <= ~Clock_out;
		        end 
		     else 
		        contador <= contador + 1'b1; 
          end 
		else 
		   begin 
		   contador <= 0;
			Clock_out <= 0;
			end
 end 
  
endmodule 




  