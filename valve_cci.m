function [ttv]=valve_cci(tiempo,tc,dt,p_ov);
%Omega_o=0.9*Omega_o;%En caso el cierre inicial se
r_o=p_ov/100;
r_i=linspace(p_ov/100,0,tc/dt+1);
alpha=acos(r_i/r_o);
tcci=1-2/pi*(alpha-0.5*sin(2*alpha));
ttv=tcci(tiempo);
end