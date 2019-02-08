%Programador: Oscar Soto Rivera
%Curso:Laboratorio de diseño de sistemas digitales
%Proyecto:Control de un servomotor

%Este programa implementa las ecuaciones de I_PD en Matlab para que sirva de
%referencia contra la implementacion hecha en lenguaje Verilog. Adicionalmente
%genera los archivos que serviran como estimulo a la implementacion hecha
%en lenguaje Verilog tales como y_Binario.txt y Referencia_Binario. Ademas genera
%las salidas del I_PD y de cada componente del mismo, los cuales son:
%Integrador, Proporcional y Derivador con el fin de realizar comparaciones
%en los calculos aritmeticos que se llevan a cabo en la implementacion
%fisica.

y1 = 0;%Inicializacion de la variable que guarda las entradas anteriores
i1 = 0;%Inicializacion de la variable que guarda las iteraciones anteriores de la parte integrativa
Sal=fopen('Salida.txt', 'wt');%Abre fichero para escritura de salidas
ref = fopen('Referencia.txt', 'wt');%Abre fichero para escritura de valores de referencia
ye = fopen('y.txt', 'wt');%Abre fichero para escritura de valores de entrada

propor = fopen('proporcional.txt', 'wt');%Abre fichero para escritura de la parte proporcional
inte = fopen('integrador.txt', 'wt');%Abre fichero para escritura de la parte integrativa
deri = fopen('derivador.txt', 'wt');%Abre fichero para escritura de la parte derivativa

load FuncRampa.txt%Carga la funcion rampa que sera el estimulo para el I_PD

ref_binario = fopen('Referencia_Binario.txt', 'wt');%Abre fichero para escritura de valores de referencia
                                                    %en binario
ye_binario = fopen('y_Binario.txt', 'wt');%Abre fichero para escritura de valores de entrada
                                          %en binario

for k = 1:93
   
    r = 500;%Referencia
    y = (FuncRampa(k));%Entrada
    fprintf(ref, '%f \n', r);%Escritura de referencia
    fprintf(ye, '%f \n', y);%Escritura de entrada
    
    %Conversion de la referencia en decimal a binario y concatenacion de signo
    r_binAux1 = decimalToBinaryVector(r,11);
    r_binAux2 = [0 r_binAux1];
    r_bin = num2str(r_binAux2);
    
    %Conversion de la entrada en decimal a binario y concatenacion de signo
    y_binAux1 = decimalToBinaryVector(y,11);
    y_binAux2 = [0 y_binAux1];
    y_bin = [0 num2str(y_binAux2)];
    
    fprintf(ref_binario, '%s \n', r_bin);%Escritura de referencia en binario
    fprintf(ye_binario, '%s \n', y_bin);%Escritura de entrada en binario
    
    %Ajuste de offset
    y = y -2048;
    r = r -2048;
    %Calculo del error entre la entrada y la referencia
    e = r - y;
    
    p = 18 * y;%Ecuacion de la parte proporcional
    
    i = 7 * e + i1;%Ecuacion de la parte integrativa
    
    %Iteraciones anteriores para calculo de la parte integrativa
    iAux1 = 7*e;
    iAux2 = iAux1 + i1;
    
    d = 150 * (y - y1);%Ecuacion de la parte derivativa
    
    PID = i - p - d;%Calculo de I_PD
    
    fprintf(propor, '%f \n', p);%Escritura de la parte proporcional
    fprintf(inte, '%f \n', i);%Escritura de la parte integrativa
    fprintf(deri, '%f \n', d);%Escritura de la parte derivativa
    
    if (PID >= 131072)%Saturacion
        Salida = 131072;
    else
        Salida = PID;
    end
    
    y1 = y;%Actualizacion de entrada anterior
    i1 = i;%Actualizacion de iteracion anterior de la parte integrativa
    
    fprintf(Sal, '%f \n', Salida);%Escritura de salida
end

%Se cierran los ficheros abiertos
fclose(Sal);
fclose(ref);
fclose(ye);
fclose(ref_binario);
fclose(ye_binario);
fclose(propor);
fclose(inte);
fclose(deri);

%Se carga la salida y se grafica para ver su resultado ante una entrada de
%funcion rampa
load Salida.txt;
Tiempo = 1:93;
plot(Tiempo, Salida);


