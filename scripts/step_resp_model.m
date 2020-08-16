%%%%% OdpowiedŸ skokowa modelu zlinearyzowanego dyskretnego wokó³ punktu
%%%%% pracy, wyznaczanie modelu w postaci odpowiedzi skokowej

close all;
clear;
clc;
warning ('off','all');   % LaTeX interpreter warnings


%% Parametry modelu 
load('data.mat');
Ts = 5;                  % Okres próbkowania

[A,B,Bz, X0, U0] = linAB(data.h0, data.T0, data);% Wyznaczenie modelu liniowego wokó³ punktu pracy
[Ad, Bd, Bdz, C, D, G] = AB2GH(A, B, Bz, Ts);

%% Model w postaci odpowiedzi skokowej (wp³yw ka¿dego sterowania na ka¿de wyjœcie)
S = [];


%% Parametry symulacji
T = [0, 605 ];                                  % Czas symulacji
L = (T(2)-T(1))/Ts;                             % Liczba kroków symulacji
t = T(1):Ts:(T(2)-Ts);                               % Wektor chwil czasu  
step = [0.5 * Fh0 0; 0 0.5 * Fc0; 0 0; 0 0];                  % Skoki sterowañ + 25%
stepsQ = 2;

%% symulacja
past = 50;
X0d = G*[X0; 0;0;0;0];                            % inicjalizacja stanem pocz¹tkowym
X(:,:,1:stepsQ) = repmat(X0d,1,past + L,stepsQ);        % Stan
Y0 = C*X0d;                                       % j/w
Y(:,:,1:stepsQ) = repmat(Y0,1,past + L,stepsQ);         % wartoœci wyjœciowe

t = [T(1) - past * Ts : Ts : T(1) - Ts, t];

U = zeros(4, past + L, stepsQ);
                   
for i = 1 : L
   for s = 1 : stepsQ  
       U(:, past + i, s) = step(:, s);      %U1 - woda ciep³a, U2 - woda zimna
       u = U(:, past + i, s);               % X1 - poziom cieczy, X2 - temperatura
       u(1) = U(1, past + i - tauh/Ts, s);
       X(:,past + i, s) = X0d + plant_lin([],X(:,past + i-1,s),u,X0d, Ad, Bd, Bdz);
       Y(:,past + i, s) = [X(1, past + i, s); X(2, past + i - tau/Ts, s)];
   end
end




titles = ["Hot water flow step", "Cold water flow step"];
ylabels = ["$h[cm]$", "$T[{}^\circ C]$"];
figure();
for i = 1 : stepsQ
    for j = 1 : 2
        subplot(2,2,(i - 1) * 2 + j)
        stairs(t, Y( i, : , j)); 
        grid on;
        xlabel('$t[s]$', 'interpreter', 'latex');
        ylabel(ylabels(i), 'interpreter', 'latex');
        title(titles(j), 'interpreter', 'latex');
        axis([t(1), t(end), -inf, inf]);
    end
end


titles = ["Hot water flow, step 1", "Cold water flow, step 1"; ...
    "Hot water flow, step 2", "Cold water flow, step 2"];
U0 = [Fh0, Fc0;Fh0 Fc0];
figure();
for i = 1 : stepsQ
    for j = 1 : 2
        subplot(2,2,(i - 1) * 2 + j);
        stairs(t, U( j, : , i) + U0(j,i)); 
        grid on;
        xlabel('$t[s]$', 'interpreter', 'latex');
        ylabel("$F[\frac{cm^3}{s}]$", 'interpreter', 'latex');
        title(titles(j, i), 'interpreter', 'latex');
        axis([t(1), t(end), -inf, inf]);
    end
end


titles = ["Hot water flow to liquid level", "Cold water flow to liquid level"; ...
    "Hot water flow to temperature", "Cold water flow to temperature"];
figure();
for j = 1 : 2
    for i = 1 : 2
        S(i, j, :) = (Y(i,past + 1:end,j) - Y(i, past + 1, j))/U(j, end, j);
        subplot(2,2,(i - 1) * 2 + j);
        scatter(t(past + 1:end), S(i,j, :),'.');
        xlabel('$t[s]$', 'interpreter', 'latex');
        title(titles(i, j), 'interpreter', 'latex')
        grid on;
    end
end
%S = cat(3, zeros(2,2), S);
save("./data/steprespmodel", "S", "Ts");