function y_out = output_delayO(t, y)

persistent Y
if isempty(Y) || t < Y(2,end)
    Y = [];
end
Y = [Y, [y(2);t]];
y_out = y;
end

