function [f,hf,hm]=loss_total_Q_know(Qo,Di,ks,visc,L);
%FUNCION VALIDO PARA ESTIMAD COEF. DE FRICCION
%Q EN (m3/s)
%D Y ks en (mm)
g=9.81;
tol=0.0001;
fo=0.002;
vo=Qo/(pi*Di^2/4);
Re=vo*Di/visc;
if Re<100
    f=0.64;
elseif Re<=2000
    f=64/Re;
else
    x(1)=1/(fo)^0.5;
    err=1;
    i=0;
    while err>tol % Flujo Transicional
    i=i+1;
    F(i)=-2*log10(ks/(3.7*Di)+2.51*x(i)/(Re));
    Fd(i)=(-2/log(10))*((2.51/Re)/(ks/(3.7*Di)+2.51*x(i)/Re));
    x(i+1)=x(i)-(F(i)-x(i))/(Fd(i)-1);
    err=abs(x(i+1)-x(i));
    if err>tol
        x(i)=x(i+1);
    else
        f=1/x(i+1)^2;
    end
    end
end
hf=f*(L/Di)*vo^2/(2*g);
fprintf('Coeficiente de friccion f = %5.3f \n',f);
%Pérdidas Locales
prg1=input('Perdidas locales totales(l) o parciales(0): ');
[km] = coef_local_loss(prg1);
hm=km*(vo)^2/(2*g);
end