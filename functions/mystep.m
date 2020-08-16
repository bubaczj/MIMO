function [ y_zad ] = mystep( t, t_step, y0, y_step )
y_zad = y0;
if t >= t_step
    y_zad = y_zad + y_step;
end
end

