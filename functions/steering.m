function [ y_zad ] = steering( t )
y0 = [3.73; 40.21]; 
if t < 50
    y_zad = [1; 1];
elseif t < 600
    y_zad = [1.2; 1];
elseif t < 1200
    y_zad = [1.2; 1.2];
elseif t < 1600
    y_zad = [1; 1];
elseif t < 2200
    y_zad = [1; 0.8];
elseif t < 2800
    y_zad = [0.8; 0.8];
elseif t < 3000
    y_zad = [1; 1];
elseif t < 3400
    y_zad = [1.25; 1.25];
else 
    y_zad = [1; 1];
end
%y_zad = [1.2; 1.2];
y_zad = y_zad .* y0;
end

