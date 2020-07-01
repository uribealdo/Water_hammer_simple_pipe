function [km] = local_loss(prg1)
condicion=0;
while condicion==0
    if prg1==1
        km=input('Ingrese coeficiente de perdida local total: ');
        condicion=2;
    elseif prg1==0
        fprintf('Estimaremos las pérdidas locales \n');
        km_intake=input('Numero de tomas: ');
        km_men_11_5=input('Numero de codos menores a 11.5deg: ');
        km_11_5=input('Numero de codos de 11.5deg: ');
        km_15=input('Numero de codos de 15deg: ');
        km_22_5=input('Numero de codos de 22.5deg: ');
        km_30=input('Numero de codos de 30deg: ');
        km_45=input('Numero de codos de 45deg: ');
        km_60=input('Numero de codos de 60deg: ');
        km_90=input('Numero de codos de 90deg: ');
        km_bifur=input('Numero de bifurcaciones: ');
        km_contractions=input('Numero de contracciones: ');
        km_valve_nozzle=input('Numero de valvulas e inyectores: ');
        km_ouput=input('Numero de salidas: ');
        km=0.1*km_intake+0.015*km_men_11_5+0.031*km_11_5+0.033*km_15+0.06*km_22_5+0.07*km_30+0.13*km_45+0.014*km_60+0.2*km_90+0.2*km_contractions+0.35*km_bifur+0.3*km_valve_nozzle+1*km_ouput;
        fprintf('Coeficiente de perdida Locales km = %5.2f \n',km);
        condicion=2;
    else
        condicion=0;
        prg1=input('Perdidas locales totales(l) o parciales(0): ');
    end
end
end

