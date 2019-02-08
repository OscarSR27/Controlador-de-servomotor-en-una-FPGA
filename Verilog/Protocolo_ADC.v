`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Edgar Gutierrez
//Curso: Laboratorio de circuitos digitales
//Proyecto: Control de un servomotor
//
//Descripcion: En este modulo se realiza la interfaz con el ADC por medio de una maquina de estados para capturar los datos. 
//////////////////////////////////////////////////////////////////////////////////
module Protocolo_ADC
//Declaracion de senales de entrada y salida
(
input wire Clock_Muestreo,reset, 
input wire data_ADC,
input wire start,FS,
output reg done,
output wire CS,Enable_divisor,
output wire [3:0] data_basura,
output wire [11:0] Dato

);

// Se definen los estados de la maquina

localparam [1:0]
                Inicio=2'b00,
					 Capturar=2'b01,
					 Listo=2'b10;
// Variables de logica de la maquina
      
reg [15:0] Data_Act,Data_next;
reg [11:0] Dato_final_A,Dato_final_N;
reg CS_A , CS_N; 
reg [1:0] Estado_Act,Estado_Next;
reg [3:0]contador_A,contador_N; 

// Acualizacion de los estados actuales, siguiente y reset. Se definen los valores por defecto de las salidas de la maquina de estados

always@(posedge Clock_Muestreo,posedge reset) //Lista sensitiva, responde ante un flanco positivo del Clock_Muestreo o reset
       begin 
        if(reset)
       begin
       Data_Act <= 0;
               CS_A <= 1;
     Estado_Act <= 0;
     contador_A <= 0;
     Dato_final_A <=0;
       end
            else 
       begin 
       Data_Act <= Data_next;
     CS_A <= CS_N;
     Estado_Act <= Estado_Next;
     contador_A <= contador_N;
     Dato_final_A <= Dato_final_N;
     end 
   end 
   
// Logica de estado proximo de la maquina

always @*
      begin 
  Data_next = Data_Act;
  CS_N = CS_A;
  Estado_Next = Estado_Act;
  contador_N = contador_A;
  Dato_final_N = Dato_final_A;
  done = 1'b0; 
  case (Estado_Act)
        
    Inicio :  if(start && CS_N) //Se permanece en este estado hasta que se indique el inicio de una conversion
                 begin
                 CS_N = 1'b0;
					  Estado_Next = Capturar; //El estado siguiente es Capturar
					  contador_N = 4'd0;
					  end 
				  else 
					  Estado_Next = Inicio;
      Capturar :  
                if(contador_N == 15)//En este estado se procede a capturar los 16 bits provenientes del ADC. Mientras no se hayan capturado
												//los 16 bits se permanece en este estado
						Estado_Next = Listo;//El siguiente estado es Listo
					 else 
					 begin 
					 Data_next = {data_ADC,Data_next[15:1]};
					 contador_N = contador_N + 1'b1;
					 end
    Listo :
               begin						//En este estado se hace la asignacion de los 16 bits del ADC y se indica la finalizacion del proceso
												//al asignar el valor de 1 a las senales done y CS_N
						   done = 1'b1;
						   CS_N = 1'b1;
						   Dato_final_N [0] = Data_next[15];
						   Dato_final_N [1] = Data_next[14];
                     Dato_final_N [2] = Data_next[13];
						   Dato_final_N [3] = Data_next[12];
						   Dato_final_N [4] = Data_next[11];
					   	Dato_final_N [5] = Data_next[10];
						   Dato_final_N [6] = Data_next[9];
						   Dato_final_N [7] = Data_next[8];
						   Dato_final_N [8] = Data_next[7];
						   Dato_final_N [9] = Data_next[6];
                     Dato_final_N [10] = Data_next[5];
                     Dato_final_N [11] = Data_next[4];
					 if (FS)
					      begin
							Estado_Next = Inicio;//Se regresa al inicio de la maquina de estados
							end
					 end 
       
   default :   Estado_Next = Inicio;
   endcase
   end 
   
// Asignaciones a las salidas del modulo 

assign CS = CS_A;
assign data_basura = Data_Act[3:0];
assign Dato = Dato_final_N;
assign Enable_divisor = (Estado_Act==Listo);

endmodule
