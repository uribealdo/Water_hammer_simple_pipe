function [ttv]=valve_exp(tiempo,tc,dt);
%Omega_o=0.9*Omega_o;%En caso el cierre inicial se
r_i=linspace(0,tc,tc/dt+1);
te=(1-r_i/tc).^1.5;
ttv=te(tiempo);
end