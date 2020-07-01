function [ttv]=valve_ball(tiempo,tc,dt,p_ov);
%Omega_o=0.9*Omega_o;%En caso el cierre inicial se
tetha=linspace(0,pi/2*p_ov/100,tc/dt+1);
betha=acos(2^0.5*sin(pi/4+tetha)-1)./(2*2^0.5*sin(tetha/2));
alpha=acos(2^0.5*sin(tetha/2).*sin(betha));
tb=2/pi*(alpha-sin(2*alpha)/2);%siempre
ttv=tb(tiempo);
end