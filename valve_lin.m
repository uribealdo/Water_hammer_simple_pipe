function [ttv]=valve_lin(tiempo,tc,dt);
%Omega_o=0.9*Omega_o;%En caso el cierre inicial se
r_o=1;
r_i=linspace(1,0,tc/dt+1);
tg=r_i/r_o;
ttv=tg(tiempo);
end