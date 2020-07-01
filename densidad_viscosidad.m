function [den,visc] = densidad_viscosidad(Temp_C)
den=-1E-7*Temp_C^4 + 4E-5*Temp_C^3 - 0.0078*Temp_C^2 + 0.0596*Temp_C + 999.88;
visc=3E-14*Temp_C^4 - 9E-12*Temp_C^3 + 1E-09*Temp_C^2 - 5E-08*Temp_C + 2E-06;
end