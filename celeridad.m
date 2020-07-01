function [c]=celeridad(den,bk,E,pois,Di,e);
fprintf('\nCALCULO DE LA CELERIDAD: \n');
%TIPO DE SISTEMA DE ANCLAJE
fprintf('Como es la instalacion de la tuberia Forzada? \n') % Se quiere saber si la TF se instala con J.E, apoyos y abrazaderas
fprintf('1: Tuberia asegurado solo en el extremo de aguas arriba \n')
fprintf('2: Tuberia asegurado en todo lo largo contra movimiento axial \n')
fprintf('3: Tuberia asegurado en todo lo largo contra movimiento axial \n')
condic=0;
while condic==0 % Elegimos el tipo de sistema de instalacion de la tuberia forzada
    pre1=input('Ingrese el que corresponde: ');
    if pre1==1
    coef_c=1-pois/2;
    elseif pre1==2
    coef_c=1-pois^2;
    elseif pre1==3
    coef_c=1;
    else
    coef_c=0;
    end
    condic=coef_c;
 end
condic=0;
c=((bk/den)/(1+bk/E*(Di/e)*coef_c))^0.5;
end