%%%%% Regulacja
%%%%% 


step_resp_model;
DMCparams;
clear;
clc;
c = get(gca, 'colororder');
close all;
warning ('off','all');   % LaTeX interpreter warnings


%% Parametry modelu 
load('data.mat');

[~,~,~, X0, U0] = linAB(data.h0, data.T0, data);          % Wyznaczenie punktu pocz¹tkowego
Ts = 5;

%% Parametry symulacji
step = [0.5; -0.5; 0; 0];                        
step_val = [14, 31, 0, 0]'*[-1,-0.5, 0.5, 1];    
T = [0, 3500 ];                                  % Czas symulacji
Fmin = [Fh0, Fc0];
controlhandle1 = @DMCa;               % Obs³uga sterowania
controlhandle2 = @DMCn;
controlhandle1([],[],[],[],Fmin, 0);
options = odeset('MaxStep', 1, 'Refine', 1);    % Ustawienia solvera


%% Symulacja
control_delay([], [], 0);                       % Reset funkcji realizuj¹cej opóŸnienie
controlhandle1([], [], [], 0);
solution1 = ode45(@(t, x)plant(t, x, control_delay(t, controlhandle1(steering(t), output_delay(t, x), t)), U0, data), T, X0, options);
[~, t_U1, U1] = control_delay([], [], 1);         % Przebieg sterowania
control_delay([], [], 0);                       % Reset funkcji realizuj¹cej opóŸnienie

controlhandle2([],[],[],[],Fmin, 0);

controlhandle2([], [], [], 0);
solution2 = ode45(@(t, x)plant(t, x, control_delay(t, controlhandle2(steering(t), output_delay(t, x), t)), U0, data), T, X0, options);
[~, t_U2, U2] = control_delay([], [], 1);         % Przebieg sterowania

t = T(1) : T(2);                                % Wektor czasu symulacji
X1 = (deval(solution1, t))';                    % Wektor rozwi¹zañ
X2 = (deval(solution2, t))'; 

ZAD = [];

for ts = T(1):Ts:T(2)
   ZAD = [ZAD, steering(ts)]; 
end
ts = T(1) : Ts : T(2);

%% Wykresy
figure('NumberTitle', 'off', 'Name', 'OdpowiedŸ modelu nieliniowego na skok');
subplot(2,2,1);
hold on;
plot(t, X1(:,1), t, X2(:,1));
plot(ts, ZAD(1, :), 'LineStyle', '--');
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$h[cm]$', 'interpreter', 'latex');
title('Liquid level', 'interpreter', 'latex');
legend('DMCa','DMCn', 'Set point',  'location', 'east');
grid on;
xlim(T);

subplot(2,2,2);
t = [0 t + tau];
plot(t,[X1(1,2); X1(:,2)], t,[X2(1,2); X2(:,2)]);
hold on;
plot(ts, ZAD(2, :), 'LineStyle', '--');
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$T[{}^\circ C]$', 'interpreter', 'latex');
title('Temperature', 'interpreter', 'latex');
legend('DMCa','DMCn', 'Set point', 'location', 'east');
grid on;
xlim(T);

t = t(2:end)-tau;

subplot(2,2,3);
plot(t_U1, U1(1,:)+Fh0, t_U2, U2(1,:)+Fh0);
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$F_H[\frac{cm^3}{s}]$', 'interpreter', 'latex');
title('Hot water flow', 'interpreter', 'latex');
legend('DMCa', 'DMCn', 'location', 'east');
grid on;
xlim(T);

subplot(2,2,4);
plot(t_U1, U1(2,:)+Fc0, t_U2, U2(2,:)+Fc0);
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$F_C[\frac{cm^3}{s}]$', 'interpreter', 'latex');
title('Cold water flow', 'interpreter', 'latex');
legend('DMCa', 'DMCn', 'location', 'east');
grid on;
xlim(T);


