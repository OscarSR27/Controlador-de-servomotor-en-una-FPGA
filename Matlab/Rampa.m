%Programador: Oscar Soto Rivera
%Curso:Laboratorio de diseño de sistemas digitales
%Proyecto:Control de un servomotor

%Este programa genera una funcion de rampa para estimular el I_PD
%hecho en Matlab y lenguaje Verilog.

rampa = fopen('FuncRampa.txt', 'wt');%Se abre el archivo para escritura

for i = 1:200%Se genera la funcion rampa con el uso de la ecuacion lineal 
             %y = mx + b. La combinacion de una funcion lineal con pendiente 
             %positiva y otra con pendiente negativa dan por resultado la 
             %funcion de rampa que se quiere generar
    if (i < 100)
        y = 10*i;
    else
        y = -10*i + 2000;
    end
    fprintf(rampa, '%f \n', y);%Escritura de datos
end

fclose(rampa);%Se cierra el archivo FuncRampa.txt

load FuncRampa.txt;%Se carga el archivo FuncRampa y se grafica contra el tiempo para comprobar su funcionamiento
Tiempo = 1:200;
plot(Tiempo, FuncRampa);