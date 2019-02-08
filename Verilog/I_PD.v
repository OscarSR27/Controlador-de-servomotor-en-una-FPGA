`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Programador: Edgar Gutierrez y Oscar Soto
//Curso: Laboratorio de circuitos digitales
//Proyecto: Control de un servomotor
//
//Descripcion: En este modulo se implementan las operaciones aritmeticas que producen el resultado del I_PD
//////////////////////////////////////////////////////////////////////////////////
module I_PD #(parameter Magnitud=17, Decimal=0, N = Magnitud+Decimal+1)//Se parametriza para hacer flexible el cambio de ancho de palabra
//Declaracion de senales de entrada y salida
	(
		input wire clk, reset, enable,
		input wire signed [N-1:0]referencia, y,
		output wire signed [N-1:0]IPD
    );
//Declaracion de senales utilizadas dentro del modulo
wire signed [N-1:0]error, integrador, proporcional, derivador, Integrador_Proporcional, Registro_y, Registro_r;

reg [1:0] valor_A;
wire [1:0] Valor_next; 
reg  clockd_A;
wire clockd_next;

//Se genera la senal que habilita el paso del valor entrante y de referencia por medio de un registro
always @(posedge clk, posedge reset)
  if (reset)
		begin 
         valor_A <= 0 ;
			clockd_A <= 0 ;
		end   
  else 
		begin 
			valor_A <= Valor_next ;
			clockd_A <= clockd_next ;
		end 
	
  assign Valor_next =  {enable,valor_A[1]};
  assign clockd_next =  (valor_A==2'b11) ? 1'b1 :(valor_A==2'b00) ? 1'b0 : clockd_A;
          
  assign fall_edge =  ~clockd_A & clockd_next ;

//Registro que guarda el valor de la senal entrante para enviarla al I_PD
Registro_Pipeline #(.N(N)) Reg_y (
    .clk(clk), 
    .reset(reset), 
    .data_in(y), 
    .enable(fall_edge), 
    .q_out(Registro_y)
    );
//Registro que guarda el valor de la referencia para enviarla al I_PD 
Registro_Pipeline #(.N(N)) Reg_r (
    .clk(clk), 
    .reset(reset), 
    .data_in(referencia), 
    .enable(fall_edge), 
    .q_out(Registro_r)
    );
//Se calcula el error entre la entrada y la referencia
CalculoError #(.Magnitud(Magnitud), .Decimal(Decimal), .N(N)) ERROR (
    .referencia(Registro_r), 
    .y(Registro_y), 
    .error(error)
    );
//Se calcula la parte integrativa del I_PD
Integrador #(.Magnitud(Magnitud), .Decimal(Decimal), .N(N)) INTEGRADOR (
    .clk(clk), 
    .reset(reset), 
    .enable(fall_edge), 
    .error(error),
    .integrador(integrador)
    );
//Se calcula la parte proporcional del I_PD
Proporcional #(.Magnitud(Magnitud), .Decimal(Decimal), .N(N)) PROPORCIONAL (
    .clk(clk), 
    .reset(reset),
	 .y(Registro_y), 
    .proporcional(proporcional)
    );
//Se calcula la parte derivativa del I_PD
Derivador #(.Magnitud(Magnitud), .Decimal(Decimal), .N(N)) DERIVADOR (
    .clk(clk), 
    .reset(reset), 
    .enable(fall_edge), 
    .y(Registro_y), 
    .derivador(derivador)
    );
//Se suman los resultados de la parte integrativa, proporcional y derivativa utilizando dos sumas. La primera para sumar la parte integrativa y
//porporcional y la segunda para adicionar a este resultado la parte derivativa
Suma #(.N(N)) Suma_Integrador_Proporcional (
    .A(integrador), 
    .B(-(proporcional)), 
    .SUMA(Integrador_Proporcional)
    );

Suma #(.N(N)) Suma_Integrador_Proporcional_Derivador (
    .A(Integrador_Proporcional), 
    .B(-(derivador)), 
    .SUMA(IPD)
    );

endmodule
