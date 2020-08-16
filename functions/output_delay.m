function y_out = output_delay(t, y)

persistent Y
if isempty(Y) || t < Y(2,end)
    Y = [];
end
Y = [Y, [y(2);t]];
y_out = y;
y_out(2) = 40.21; %% Default
if t > 30      %% Default
    y_out(2) = Y(1, find(abs(Y(2,:)-t)<eps, 1, 'last'));
end
end

