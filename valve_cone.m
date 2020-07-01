function [ttv]=valve_cone(tiempo,tc,dt,p_ov);
%Omega_o=0.9*Omega_o;%En caso el cierre inicial se
r_i=linspace(0,p_ov/100,tc/dt+1);
ov=linspace(p_ov,0,tc/dt+1);
cdo=-1E-09*p_ov.^5+2E-07*p_ov.^4-2E-05*p_ov.^3+0.0005*p_ov.^2-0.0004*p_ov+0.0005;
cd=(-1E-09*ov.^5+2E-07*ov.^4-2E-05*ov.^3+0.0005*ov.^2-0.0004*ov+0.0005)/cdo;
tcn=.99*(1-(r_i).^2);
ttv=cd(tiempo)*tcn(tiempo);
end