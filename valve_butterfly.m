function [ttv] = valve_butterfly(tiempo,tc,dt,p_ov)
%Omega_o=0.9*Omega_o;%En caso el cierre inicial se
teta=linspace(0,pi/2*p_ov/100,tc/dt+1);
ov=linspace(p_ov,0,tc/dt+1);
cdo=3E-10*p_ov.^5-5E-08*p_ov.^4+2E-06*p_ov.^3+2E-05*p_ov.^2+0.0032*p_ov-0.0013;
cd=(3E-10*ov.^5-5E-08*ov.^4+2E-06*ov.^3+2E-05*ov.^2+0.0032*ov-0.0013)/cdo;
tm=1-sin(teta);%siempre
ttv=cd(tiempo)*tm(tiempo);
end

