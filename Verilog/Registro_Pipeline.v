`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Edgar Gutierrez y Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Control de un servomotor
//
//Descripcion: En este modulo se genera un registro universal
//////////////////////////////////////////////////////////////////////////////////
module Registro_Pipeline
#(parameter N = 8) // Se define el parametro de los bits del registro
//Declaracion de senales de entrada y salida
	(
		input wire clk,reset, // Se define el reloj y el reset 
		input wire [N-1:0] data_in, // Se define el dato de entrada
		input wire enable, // El enable solo carga el dato cuando esta en 1
		output wire [N-1:0] q_out // El dato de salida 
    );
//Declaracion de senales utilizadas dentro del modulo
 reg [N-1:0] q_actual ,q_next; // Se definen los valores de q actual y q siguiente
                               // para el proceso en la logica actual y siguente 
// Logica actual dependen del clok 
always@(posedge clk, posedge reset) //Lista sensitiva, responde ante un flanco positivo del clk o reset
	if(reset)
		q_actual <= 0; // Se incializa q
	else
		q_actual <= q_next; // Se actualiza q actual 
// Logica siguiente 		
always@*
   begin
	q_next = q_actual;
	if(enable) // Si el enable esta activado se deja pasar el dato
	   q_next =  data_in; 
	else 
	   q_next = q_actual; // Sino se mantienen las salidas iguales 
	end 
	
assign q_out = q_actual ; // Se asigna a la salida el q actual 
endmodule 