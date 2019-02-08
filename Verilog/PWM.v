`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Control de un servomotor
//
//Descripcion: En este modulo se realiza el PWM
//////////////////////////////////////////////////////////////////////////////////
module PWM  #(parameter N=8) //Se parametriza para hacer flexible el cambio de ancho de palabra 

(  
  input wire Clock,reset, // se declaran el reloj y el reset 
  input wire [N-1:0] Entrada, // se declara la entrada del modulo 
  output wire pwm_out // se declara la salida del PWM
    ); 
	 // Debido a que la frecuencia del PWM es de 10KHz se debe dividir el reloj de 100MHz por 10 000 veces (100MHz/10KHz), esto se hace con un contador 
	 // que al llegar a 10 000  reinicia la cuenta, de esta forma la salida del contador sera el reloj de 10KHz. Para hacer el PWM se modula el ancho 
	 // del pulso por medio de una comparacion entre la cuenta actual y el valor a modular, asi, si se desea un ciclo de trabajo del 100 por ciento, 
	 // se deberia indicar que si el contador es igual a 0 se mantenga en alto. Si se desea un ciclo de trabajo del 50 por ciento, se deberia indicar 
	 // que si el contador es igual a 5 000 se invierta el nivel logico del reloj (de alto a bajo, o de bajo a alto), y asi sucesivamente con otros 
	 // valores.
	 // Sin embargo la entrada para modular el ancho del pulso esta conformada por 8 bits. Con esta cantidad de bits el numero maximo de combinaciones
	 // posibles es 2^8 (256), por lo que se debe hacer una equivalencia de 256 a 10 000. De esta forma cero equivaldra a cero y 256 a 10 000. Cada valor
	 // entero intermedio entre 0 y 256 tendra su equivalente en 10 000. A continuacion se lleva el proceso necesario para generar el cambio de escala:
	 
	 // Frecuencia de salida = 10 KHz
	 // T = Frecuencia de reloj de entrada * periodo de senal PWM 
	 // T = 100MHz * 0.1ms = 10 000
	 // Ahora se calcula la cantidad por la cual se debe multiplicar 256 para hacer la equivalencia a 10 000 
	 // SR = T/ 2^N
	 // SR = 10 000/256
	 // SR = 40
	 
localparam  SR = 40;// Valor a multiplicar para hacer la equivalencia de los valores entrantes de 8 bits

reg pwm; // Se declara un reg que tome el valor de la salida del pwm 
reg [13:0] contador ; // Se declara un reg para hacer el contador que controla tanto el ancho del pulso como la frecuencia de reloj del PWM


always @(posedge Clock, posedge reset)  //Lista sensitiva, responde ante un flanco positivo del Clock o reset
begin 
     if(reset) // Se ponen las senales en 0 
	     begin
	     pwm <=0;
	     contador <= 0;
	     end 
	  else
        begin	  
	     contador <= contador +1'b1; // Contador
		  
        if (contador <= SR*Entrada) //Modulacion de pulso por medio de comparacion con valor entrante una vez escalado
	         pwm <= 1'b1;
        else 	  
	         pwm <= 1'b0;
			
	     if (contador >= 10000) // Frecuencia de 10KHz
	         contador <= 0;
        end			
      end 

assign pwm_out = pwm; //Salida del PWM

endmodule
