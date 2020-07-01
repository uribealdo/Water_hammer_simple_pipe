clc;
clear all;
close all;
%### PRESENTACION
fprintf('Universidad Nacional de Ingenieria \n')
fprintf('Facultad de Ingenieria Civil \n')
fprintf('Programa Desarrolado por Uribe Aldo \n \n')
%### ESQUEMA HIDRAULICO
fprintf('\nESQUEMA HIDRAULICO: \n');
z1=input('Ingrese cota aguas arriba z1(m): ');
h1=input('Ingrese nivel aguas arriba h1(m): ');
z2=input('Ingrese cota aguas abajo z2(m): ');
h2=input('Ingrese nivel aguas abajo h2(m): ');
L=input('Ingrese Longitud de la Tuberia Forzada L(m): '); % Longitud de Tramos de Tuberia Ej. 100m
Ho=(h1+z1)-(h2);%Carga bruta
condic=0;
while condic==0 % Calculamos o ingresamos la celeridad de onda
    preg=input('Desea considerar la inclinacion de la tuberia? si(1)/no(0): ');
    if preg==1
        ang=asin((z1-z2)/L); %Se calcula la inclinacion
        fprintf('Angulo de inclinacion = %5.2f \n',ang);
        condic=2;
    elseif preg==0
        ang=0;
        condic=2;
    else
        condic=0;
    end
end
%### DATOS DE LA TUBERIA
g=9.81;
fprintf('\nDATOS FISICOS: \n');
prg1=input('Desea ingresar valores fijos de viscosidad y densidad? si(1)/No(0): ');
if prg1==1
    visc=input('Ingrese viscosidad cinematica del agua (m2/s): ');
    den=input('Ingrese densidad del agua (Kg/m3): ');
else
    Temp_C=input('Ingrese temperatura en celsius: ');
    fprintf('Para una Temperatura %f: \n',Temp_C);
    [den,visc]=densidad_viscosidad(Temp_C);
    fprintf('den = %5.2f \n',den);
    fprintf('vis = %5.3g \n',visc); %Expresa en notacion cientifica
end
%### INGRESO DE DATOS FISICOS
%Parametro de la tuberia
bk=input('Modulo del Bulk del agua 2.074E+9(Pa): ');
E=input('Modulo de elasticidad de la tuberia 1.962E+11(Pa): ');
pois=input('Coeficiente de Poisson u: ');
Di=input('Diametro interno de la tuberia Di(mm): ')/1000;
do=input('Ingrese diametro de la valvula (mm): ');
do=do/1000;
p_ov=input('Apertura inicial de la válvula (%): ');
Ai=pi*Di^2/4; %Area de la tuberia
ks=input('Ingrese rugosidad de la tuberia ks 0.1(mm): ')/1000;
e=input('Espesor de la tuberia e(mm): ')/1000; % F_I EVAL e
%### CALCULO DE FLUJO ESTACIONARIO f
condic1=0;
while condic1==0
    pre2=input('\nDesea calcular la friccion en tuberia? si(1)/no(0): ');
    if pre2==1 %En este caso se calcula el valor de la friccion, sea el caudal conocido o desconocido
       condic2=0;
       while condic2==0 % Calculamos o ingresamos la celeridad de onda
           pre3=input('El caudal es conocido? si(1)/no(0): ');
           if pre3==1
               Qo=input('Ingrese el caudal inicial Q(m3/s): ');
               vo=Qo/Ai;
               [f,hf,hm]=loss_total_Q_know(Qo,Di,ks,visc,L);
               hfm=hf+hm;
               fprintf('Perdida Total hfm = %5.2f \n',hfm);
               condic2=2;
           elseif pre3==0
               [f,hf,hm,Qo] = loss_total_Q_unknown(Di,ks,Ho,visc,L);
               hfm=hf+hm;
               fprintf('Perdida Total hfm = %5.2f \n',hfm);
               %Estimamos el diametro optimo segun Fahlbusch (1987
               prg4=input('Desea actualizar por el diametro aptimo? si(1)/no(0): ');
               if prg4==1
                   Di_optimo=1.12*Qo^0.45/Ho^0.12;
                   Di=Di_optimo;
                   fprintf('Diametro actualizado Di = %5.2f \n',Di);
                   [f,hf,hm,Qo] = loss_total_Q_unknow(Di,ks,Ho,visc,L);
                   hfm=hf+hm;
                   fprintf('Perdida Total actualizado hfm = %5.2f \n',hfm);
               end
               condic2=2;
           else
               condic2=0;
           end
       end
       condic1=2;
    elseif pre2==0 %Este caso es cuando queremos asumir un valor fijo de la friccion incluyendo el valor 0
        condic1_1=0;
        while condic1_1==0
            pre4=input('El caudal es conocido? si(1)/no(0): ');
            if pre4==1
                Qo=input('Ingrese el caudal inicial Q(m3/s): ');
                f=input('Ingrese friccion o poner 0 (si se desprecia): ');
                vo=Qo/Ai;
                condic1_1=2;
            elseif pre4==0
                f=input('Ingrese friccion o poner 0 (si se desprecia): ');
                prg1=input('Perdidas locales totales(l) o parciales(0): ');
                [km] = coef_local_loss(prg1);
                vo=(2*g*Ho/(1+f*L/Di+km))^0.5; %Falta ingresar hm
                Qo=Ai*vo;
                condic1_1=2;
            else
                condic1_1=0;
            end
        end
        condic1=2;
    else
        condic1=0;
    end
end
%### CALCULO DE LA CELERIDAD DE ONDA
condic3=0;
while condic3==0 % Calculamos o ingresamos la celeridad de onda
    pre5=input('Desea calcular la celeridad de onda? si(1)/no(0): ');
    if pre5==1
        [c]=celeridad(den,bk,E,pois,Di,e);
        fprintf('Celeridad de onda = %5.2f \n',c);
        condic3=2;
    elseif pre5==0
        c=input('Ingrese la celeridad de onda(m/s): ');
        condic3=2;
    else
        condic3=0;
    end
end
%### DATOS DE ENTRADA PARA EL FLUJO TRANSITORIO
fprintf('\nDATOS DE SIMULACION: \n');
tc=input('Tiempo de cierre de la valvula tc(s): ');
N=input('Ingrese numero de tramos N(par): '); % Numero Par
dx=L/N;
ts=input('Ingrese el tiempo de simulacion (1000) ts(s): '); % Tiempo requerido para la simulacion Ej. 1000s
dt=dx/c;
%### COEFICIENTES DEL MOC
B=c/(g*Ai); %Parametro B ecuacion (125)
R=dx*f/(2*g*Di*Ai^2); %Parametro R ecuacion (126)
S=dx*sin(ang)/(c*Ai); %Parametro S ecuacion (127)
%CUANDO EL TIEMPO ES 0
%ESTIMAMOS LOS VALORES DE FRONTERA
t(1)=0;
%### CALCULO DE FLUJOS TRANSITORIOS
for i=1:1:N+1
    Q(1,i)=Qo;
    H(1,i)=Ho-f*(i-1)*(dx/Di)*Qo^2/(2*g*Ai^2);%I_C cotas de fondo variable%%
end
for j=2:1:ts+1 %
    t(j)=(j-1)*dt;
    for i=2:N
        %Para aguas arriba C-
        CM(j-1,i)=H(j-1,i+1)-Q(j-1,i+1)*(B+S);
        BM(j-1,i)=B+R*abs(Q(j-1,i+1));
        %Para aguas abajo C+
        CP(j-1,i)=H(j-1,i-1)+Q(j-1,i-1)*(B-S);
        BP(j-1,i)=B+R*abs(Q(j-1,i-1));
        %Calculo de caudal y Calculo de Carga
        %Nodos Internos - Tiempo 2
        Q(j,i)=(CP(j-1,i)-CM(j-1,i))/(BP(j-1,i)+BM(j-1,i));
        H(j,i)=CM(j-1,i)+BM(j-1,i)*Q(j,i);
    end    
    %Condicion Aguas arriba C-
    CM(j-1,1)=H(j-1,2)-Q(j-1,2)*(B+S);
    BM(j-1,1)=B+R*abs(Q(j-1,2));
    %Calculo de caudal y Calculo de Carga
    %Nodo Aguas arriba - Tiempo 2
    H(j,1)=Ho; %Hconstante
    Q(j,1)=(H(j,1)-CM(j-1,1))/BM(j-1,1);    
    %Condicion Aguas abajo C+
    CP(j-1,N+1)=H(j-1,N)+Q(j-1,N)*(B-S);
    BP(j-1,N+1)=B+R*abs(Q(j-1,N));
    %Calculo de caudal y Calculo de Carga
    %Nodo Aguas abajo - Tiempo 2
    if t(j)<tc
        tiempo=j;
        %INICIA SELECCION DE VALVULAS
        if j==2
            fprintf('Seleccione el tipo de valvula \n')
            fprintf(' 1: Cierre lineal \n')
            fprintf(' 2: Valvula de globo \n')
            fprintf(' 3: Valvula de compuerta circular \n')
            fprintf(' 4: Valvula de compuerta cuadrada \n')
            fprintf(' 5: Valvula de mariposa \n')
            fprintf(' 6: Valvula de bola \n')
            fprintf(' 7: Valvula de cono \n')
            fprintf(' 8: Cierre exponencial \n')
            condicion=0;
            while condicion==0 % Calculamos o ingresamos la celeridad de onda
                pre1=input('Ingrese el que corresponda: ');
                if pre1==1
                    [ttv]=valve_lin(tiempo,tc,dt);
                    condicion=2;
                elseif pre1==2
                    [ttv]=valve_glove(tiempo,tc,dt,p_ov);
                    condicion=2;
                elseif pre1==3
                    [ttv]=valve_cci(tiempo,tc,dt,p_ov);
                    condicion=2;
                elseif pre1==4
                    [ttv]=valve_ccu(tiempo,tc,dt,p_ov);
                    condicion=2;
                elseif pre1==5
                    [ttv]=valve_butterfly(tiempo,tc,dt,p_ov);
                    condicion=2;                
                elseif pre1==6
                    [ttv]=valve_ball(tiempo,tc,dt,p_ov);
                    condicion=2;
                elseif pre1==7
                    [ttv]=valve_cone(tiempo,tc,dt,p_ov);
                    condicion=2;
                elseif pre1==8                    
                    [ttv]=valve_exp(tiempo,tc,dt);
                    condicion=2;
                else
                    condicion=0;
                end
            end
        else
            condicion=0;
            while condicion==0 % Calculamos o ingresamos la celeridad de onda
                if pre1==1
                    [ttv]=valve_lin(tiempo,tc,dt);
                    condicion=2;
                elseif pre1==2
                    [ttv]=valve_glove(tiempo,tc,dt,p_ov);
                    condicion=2;
                elseif pre1==3
                    [ttv]=valve_cci(tiempo,tc,dt,p_ov);
                    condicion=2;
                elseif pre1==4
                    [ttv]=valve_ccu(tiempo,tc,dt,p_ov);
                    condicion=2;
                elseif pre1==5
                    [ttv]=valve_butterfly(tiempo,tc,dt,p_ov);
                    condicion=2;
                elseif pre1==6
                    [ttv]=valve_ball(tiempo,tc,dt,p_ov);                    
                    condicion=2;
                elseif pre1==7
                    [ttv]=valve_cone(tiempo,tc,dt,p_ov);
                    condicion=2;
                elseif pre1==8
                    [ttv]=valve_exp(tiempo,tc,dt);
                    condicion=2;
                else
                    condicion=0;
                end
            end
        end
        %TERMINA SELECCION DE VALVULAS
        Cv=(Qo*ttv)^2/Ho;
        Q(j,N+1)=(-Cv*BP(j-1,N+1)+((Cv*BP(j-1,N+1))^2+4*Cv*CP(j-1,N+1))^0.5)/2;
        H(j,N+1)=CP(j-1,N+1)-BP(j-1,N+1)*Q(j,N+1);
    else
        Q(j,N+1)=0;
        H(j,N+1)=CP(j-1,N+1);
    end
end
%### VALORES MAXIMOS Y MINIMOS DE H(m)
[m,n]=size(H);
for i=1:n
    Hmax(i)=Ho;
    for j=1:m
        if H(j,i)>Hmax(i)
            Hmax(i)=H(j,i);
        else
            Hmax(i)=Hmax(i);
        end
    end
end
Hmaxmax=max(max(Hmax));
for i=1:n
    Hmin(i)=Ho;
    for j=1:m
        if H(j,i)<Hmin(i)
            Hmin(i)=H(j,i);
        else
            Hmin(i)=Hmin(i);
        end
    end
end
Hminmin=min(min(Hmin));
%################ VALORES MAXIMOS Y MINIMOS DE Q
[m,n]=size(Q);
for i=1:n
    Qmax(i)=Qo;
    for j=1:m
        if Q(j,i)>Qmax(i)
            Qmax(i)=Q(j,i);
        else
            Qmax(i)=Qmax(i);
        end
    end
end
Qmaxmax=max(max(Qmax));
for i=1:n
    Qmin(i)=Qo;
    for j=1:m
        if Q(j,i)<Qmin(i)
            Qmin(i)=Q(j,i);
        else
            Qmin(i)=Qmin(i);
        end
    end
end
Qminmin=min(min(Qmin));
%################ GRAFICA CARGA HIDRAULICA H (m)
fig1=figure; %Abre una ventana de figura
fig1=mesh(H,'FaceLighting','gouraud','LineWidth',.40);
axis([1 N+1 0 ts*dt Hminmin-10 Hmaxmax+10]);
title('Carga hidraulica H (m): MOC');
xlabel('(nodos)');
ylabel('ts*dt (s)');
zlabel('H (m)');
colormap('jet');
colorbar;
grid on
print(gcf,'-djpeg','-r600','TGA_UNI4-2_001.jpg');
%################ GRAFICA CAUDAL Q (m3/s)
fig2=figure; %Abre una ventana de figura
fig2=mesh(Q,'FaceLighting','gouraud','LineWidth',.40);
axis([1 N+1 0 ts*dt 1.2*Qminmin 1.2*Qmaxmax]);
title('Caudal Q (m3/s): MOC');
xlabel('(nodos)');
ylabel('ts*dt (s)');
zlabel('Q (m)');
colormap('jet');
colorbar;
grid on
print(gcf,'-djpeg','-r600','TGA_UNI4-2_002.jpg');
%################ GRAFICA HMAX VS HMIN
fig3=figure; %Abre una ventana de figura
fig3=plot(Hmax,'--r','LineWidth',1.5);
for i=1:N+1
    str={Hmax(i)};
    text(i,Hmax(i),str,'FontSize',9,'color','[0 0 0]')
end
axis([1 N+1 Hminmin-10 Hmaxmax+10]);
title('Carga hidraulica Hmax y Hmin (m): MOC');
hold on
fig3=plot(Hmin,'-.','LineWidth',1.5);
for i=1:N+1
    str={Hmin(i)};
    text(i,Hmin(i),str,'FontSize',9,'color','[0 0 0]')
end
xlabel('(nodos)');
ylabel('H (m)');
lgd=legend('Hmax', 'Hmin','Location','southwest');
title(lgd,'Leyenda');
grid on
print(gcf,'-djpeg','-r600','TGA_UNI4-2_003.jpg');
%################ GRAFICA QMAX VS QMIN
fig4=figure; %Abre una ventana de figura
fig4=plot(Qmax,'--r','LineWidth',1.5);
for i=1:N+1    
    str={sprintf('%3.3f',Qmax(i))};
    text(i,Qmax(i),str,'FontSize',9,'color','[0 0 0]')
end
axis([1 N+1 1.2*Qminmin 1.2*Qmaxmax]);
title('Caudal Qmax y Qmin (m3/s): MOC');
hold on
fig4=plot(Qmin,'-.','LineWidth',1.5);
for i=1:N+1
    str={sprintf('%3.3f',Qmin(i))};
    text(i,Qmin(i),str,'FontSize',9,'color','[0 0 0]')
end
xlabel('(nodos)');
ylabel('Q (m)');
lgd=legend('Qmax', 'Qmin','Location','northeast');
title(lgd,'Leyenda');
grid on
print(gcf,'-djpeg','-r600','TGA_UNI4-2_004.jpg');
%################ GUARDAR VALORES EN ARCHIVO TXT
%Cargas Hidraulicas
save Cargahidraulica.txt H -ascii
save Hmax.txt Hmax -ascii
save Hmin.txt Hmin -ascii
%Caudales
save Caudales.txt Q -ascii
save Qmax.txt Qmax -ascii
save Qmin.txt Qmin -ascii
save t(s).txt t -ascii
