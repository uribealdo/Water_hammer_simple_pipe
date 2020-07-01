function [ttv]=valve_glove(tiempo,tc,dt,p_ov);
%Omega_o=0.9*Omega_o;%En caso el cierre inicial se
r_o=p_ov/100;
r_i=linspace(p_ov/100,0,tc/dt+1);
ov=linspace(p_ov,0,tc/dt+1);
cdo=2E-10*p_ov.^5-5E-08*p_ov.^4+4E-06*p_ov.^3-9E-05*p_ov.^2+0.003*p_ov+0.0014;
cd=(2E-10*ov.^5-5E-08*ov.^4+4E-06*ov.^3-9E-05*ov.^2+0.003*ov+0.0014)/cdo;
tgl=r_i./r_o;
ttv=cd(tiempo)*tgl(tiempo);
end