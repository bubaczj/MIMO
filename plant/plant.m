function [dX] = plant(t, X, U, U0, data)
%X = [h1; h2]
%U = [F1; Fd]

alpha = data.alpha;
r = data.r;
Th = data.Th;
Tc = data.Tc;

h = max(eps, X(1));                                 % zbiornik nie mo�e byc pusty
T = X(2);

V = pi * h^2 * (3 * r - h) / 3;

U = U + U0;                                         % przyrostowe sterowanie, unifikacja z uk�adem zlinearyzownaym



for i = 1 : 3
    U(i) = max(0, U(i));                            % strumienie sterowania i zak�uce� nie mog� by� ujemne
end

Us = U(1:2);                                        % sterowanie [ciep�a, zimna]
Fh = Us(1);
Fc = Us(2);
Ud = U(3:4);                                        % zak��cenie [strumie�, temperatura]
Fd = Ud(1);
Td = Ud(2);

% wysoko�� - h
dh = (Fh + Fc + Fd - alpha*sqrt(h))/(2 * h*pi*r - pi*h^2);

dT = (Fh * Th + Fc * Tc + Fd * Td - T * (Fh + Fc + Fd)) / V;

dX(1, 1) = dh;
dX(2,1) = dT;
end

