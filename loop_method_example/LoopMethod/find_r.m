function [r]=find_r(D,L,f)
%[r]=find_r(D,L,f)
%r=fL/(2gDA^2)
g=9.81;
A=0.25*pi*D.^2;
r=f.*L./(2.*g.*D.*A.^2);

end