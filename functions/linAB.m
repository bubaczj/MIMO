function [A, B, Bs, X0, U0] = linAB(h0, T0, data)
%X = [h; T]
%U = [Fh; Fc; Fd; Td]
r = data.r;
Th = data.Th;
Tc = data.Tc;
alpha = data.alpha;
Fd = data.Fd0;
Td = data.Td0;

temp = [1 1;(Th - T0) (Tc - T0)]\[alpha*sqrt(h0) - Fd; Fd*(T0 - Td)];
Fh0 = temp(1);
Fc0 = temp(2);

X0 = [h0; T0];

U0 = [Fh0; Fc0; Fd; Td];

A(1,1) = ((-alpha /( 2 * sqrt(h0))) * (2 * h0 * pi * r - pi * h0 ^ 2) -  2 * pi * (Fh0 + Fc0 + Fd - alpha * sqrt(h0)) * (r - h0))/ ...
    ((2 * h0 * pi * r - pi * h0 ^ 2)^2);
A(1,2) = 0;
A(2,1) = (-(2 * h0 * pi * r - pi * h0 ^ 2)/((pi * h0 ^ 2 * r - (pi / 3) * h0 ^ 3) ^ 2)) * ...
    (Fh0 * Th + Fc0 * Tc + Fd * Td - T0 * (Fh0 + Fc0 + Fd));
A(2,2) = -( (Fh0 + Fc0 + Fd) / (pi * h0^2 * r - (1/3)*pi*h0^3));

B(1,1) = 1/(2 * pi * h0 * r - pi * h0^2);
B(1,2) = B(1,1);
B(2,1) = (Th - T0)/(pi * h0^2 * r - (1/3) * pi * h0^3);
B(2,2) = (Tc - T0)/(pi * h0^2 * r - (1/3) * pi * h0^3);

Bs(1,1) = 1/(2 * pi * h0 * r - pi * h0^2);
Bs(1,2) = 0;
Bs(2,1) = (Td - T0)/(pi * h0^2 * r - (1/3) * pi * h0^3);
Bs(2,2) = Fd / (pi * h0^2 * r - (1/3) * pi * h0^3);

end

