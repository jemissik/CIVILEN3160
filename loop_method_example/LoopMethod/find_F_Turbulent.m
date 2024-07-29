function [f]=find_F_Turbulent(k,D)
%[f]=find_F_Turbulent(k,D)
%assume fully turbulent friction equation 
%1/sqrt(f) = -2log10(k/D/3.7)
f= 1./((-2*log10(k./D./3.7)).^2);
end