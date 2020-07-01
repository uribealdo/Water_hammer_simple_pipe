function [f,hf,hm,Qo] = loss_total_Q_unknow(Di,ks,Ho,visc,L);
%FUNCION VALIDO PARA CONDUCCION SIMPLE CON TUBERIA
%Caudal desconocido, diametro conocido
%Ingreso de Datos
fprintf('\nDATOS DE ENTRADA: \n');
g=9.81;
A=pi*Di^2/4;
%Pérdidas Locales
prg1=input('Perdidas locales totales(l) o parciales(0): ');
[km] = coef_local_loss(prg1);
%Perdidas por friccion
tol=0.0001;
x(1)=Ho;
err=1;
i=0;
while err>tol % Flujo Transicional
    i=i+1;
    v(i)=-2*(2*g*Di*x(i)/L)^0.5*log10(ks/(3.7*Di)+2.51*(visc/Di)/(2*g*Di*x(i)/L)^0.5);
    x(i+1)=Ho-(v(i))^2/(2*g)*(1+km);
    err=abs(x(i+1)-x(i));
    if err>tol
        x(i)=x(i+1);
    else
        hf=x(i+1);
        fprintf('\nRESULTADOS: \n');
        fprintf('Perdida por friccion hf = %5.2f \n',hf);        
        v=v(i);
        fprintf('Velocidad estimada v = %5.2f \n',v);
    end
end
vo=v;
Qo=vo*A;
fprintf('Caudal estimado Q = %5.3f \n',Qo);
f=hf*2*g*Di/(L*vo^2);
fprintf('Coeficiente de friccion f = %5.3f \n',f);
hm=km*(vo)^2/(2*g);
fprintf('Perdida Local Total hm = %5.2f \n',hm);
end
