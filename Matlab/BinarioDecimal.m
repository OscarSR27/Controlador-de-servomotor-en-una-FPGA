%Programador: Oscar Soto Rivera
%Curso:Laboratorio de diseño de sistemas digitales
%Proyecto:Control de un servomotor

%Este programa toma los valores en binario de la salida del I_PD
%implementado con lenguaje Verilog y lo convierte a decimal. Esto con
%el objetivo de faciliar la comparacion del modelo teorico del I_PD 
%implementado en Matlab.

load Salida_I_PD.txt%Carga los valores en binario extraidos de la simulacion del I_PD 
                    %implementado en lenguaje Verilog

d = binaryVectorToDecimal(Salida_I_PD);%Conversion a decimal

Salida_IPD_Verilog = fopen('SalidaDecimalVerilog.txt', 'wt');%Abre fichero para escritura de la salida
                                                             %convertida a decimal
                                                             
fprintf(Salida_IPD_Verilog, '%f \n', d);%Escritura de salida convertida a decimal
fclose(Salida_IPD_Verilog);%Se cierra el fichero

%Se carga el archivo que contiene de salida del I_PD implementado en Matlab
load Salida.txt

t = 1:93;%Tiempo

%Se grafican los resultados de la salida tanto del I_PD implementado en
%Matlab como el implementado en lenguaje Verilog para su comparacion
subplot(2,1,1), plot(t, Salida, 'bla');
title('Salida IPD MatLab')
subplot(2,1,2), plot(t, d);
title('Salida IPD Verilog')
