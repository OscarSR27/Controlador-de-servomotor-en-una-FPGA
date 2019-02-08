`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//Programador: Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Control de un servomotor
//
//Descripcion: Se realiza el testbench para simular el sistema digital. Las entradas se cargan por medio de los archivos y_Binario.txt y 
//					Referencia_Binario.txt generados en Matlab. La salide del testbench genera el archivo Salida_I_PD.txt. Este archivo 
//					debe ser convertido de binario a decimal utilizando el programa de Matlab BinarioDecimal.m, y de esta forma realizar la comparacion 
//					con el modelo teorico del I_PD hecho en Matlab
//////////////////////////////////////////////////////////////////////////////////

module Test_Proyect;

	// Entradas
	reg Clock_Nexys;
	reg Reset;
	reg reset_Clck;
	reg data_ADC;
	reg start;
	reg [11:0] Entrada_referencia;

	// Salidas
	wire CS;
	wire Clock_Muestreo;
	wire [3:0] data_basura;
	wire pwm_out;
	wire [17:0] IPD;

	// Unit Under Test (UUT)
	Servo_Top uut (
		.Clock_Nexys(Clock_Nexys), 
		.Reset(Reset), 
		.reset_Clck(reset_Clck), 
		.data_ADC(data_ADC), 
		.start(start), 
		.Entrada_referencia(Entrada_referencia), 
		.CS(CS), 
		.Clock_Muestreo(Clock_Muestreo), 
		.data_basura(data_basura), 
		.pwm_out(pwm_out), 
		.IPD(IPD)
	);

integer I_PD, k;
reg [11:0]mem1[90:0];
reg [11:0]mem2[90:0];//Se genera una memoria para abir el fichero .txt, donde la primera parametrizacion (los primeros parentesis cuadrados 
							//leyendo de izquierda a derecha) son para determinar el tamaño de los bits en el arreglo, mientras que los segundos es para 
							//indicar cuantos datos existen en el fichero .txt 
reg [11:0]VariableAux;

initial forever
	# 20 Clock_Nexys = ~Clock_Nexys;//Generacion de senal de reloj principal para simulacion

initial begin
	// Initialize Inputs
	Clock_Nexys = 0;
	Reset = 0;
	reset_Clck = 0;
	data_ADC = 0;
	start = 0;

	// Wait 100 ns for global reset to finish
	#100;
	  
	// Add stimulus here
	
	// Initialize Inputs
	Clock_Nexys = 0;
	Reset = 1;
	reset_Clck = 1;
	data_ADC = 0;
	start = 0;

	// Wait 100 ns for global reset to finish
	#100;
	  
	// Add stimulus here
	
	// Initialize Inputs
	Reset = 0;
	reset_Clck = 0;
	data_ADC = 0;
	start = 0;

	// Wait 100 ns for global reset to finish
	#100;
	I_PD = $fopen("Salida_I_PD.txt");// Abre fichero para escritura
	$readmemb("Referencia_Binario.txt",mem1);// Carga en mem los datos del fichero Referencia_Binario.txt para lectura
	$readmemb("y_Binario.txt",mem2); // Carga en mem2 los datos del fichero y_Binario.txt para lectura
	for (k=0; k<89; k=k+1)// Ciclo for para recorrer el fichero cargado
	begin
	// 
		Entrada_referencia = mem1[k];
		VariableAux = mem2[k];
		@(negedge Clock_Muestreo)
		start = 1;
		repeat(4) @(posedge Clock_Muestreo); // Se esperan 4 ciclos de reloj, esto equivale a los primeros 4 datos del ADC que son para estabilizar
														 // la senal 
		@(negedge Clock_Muestreo)
		data_ADC = VariableAux[11]; // bit numero 1 del dato 
		@(negedge Clock_Muestreo)
		data_ADC = VariableAux[10]; // bit numero 2 del dato 
		@(negedge Clock_Muestreo)
		data_ADC = VariableAux[9]; // bit numero 3 del dato 
		@(negedge Clock_Muestreo)
		data_ADC = VariableAux[8]; // bit numero 4 del dato 
		@(negedge Clock_Muestreo)
		data_ADC = VariableAux[7]; // bit numero 5 del dato 
		@(negedge Clock_Muestreo)
		data_ADC = VariableAux[6]; // bit numero 6 del dato 
		@(negedge Clock_Muestreo)
		data_ADC = VariableAux[5]; // bit numero 7 del dato 
		@(negedge Clock_Muestreo)
		data_ADC = VariableAux[4]; // bit numero 8 del dato
		@(negedge Clock_Muestreo)
		data_ADC = VariableAux[3]; // bit numero 9 del dato 
		@(negedge Clock_Muestreo)
		data_ADC = VariableAux[2]; // bit numero 10 del dato 
		@(negedge Clock_Muestreo)
		data_ADC = VariableAux[1]; // bit numero 11 del dato 
		@(negedge Clock_Muestreo)
		data_ADC = VariableAux[0]; // bit numero 12 del dato
		start = 0; 
      repeat(18) @(posedge Clock_Muestreo);
		$fdisplayb(I_PD, IPD);
		
	end
	$fclose(I_PD);//Se cierra el fichero Salida_I_PD.txt
	$stop;
	end
      
endmodule
