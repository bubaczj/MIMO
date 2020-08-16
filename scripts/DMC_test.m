%%%%% Regulacja obiektu liniowego
%%%%% 


step_resp_model0;
DMCparams0;
clear;
clc;
c = get(gca, 'colororder');
close all;
warning ('off','all');   % LaTeX interpreter warnings


%% Parametry modelu 
load('data.mat');

[A, B, Bz, X0, U0] = linAB(data.h0, data.T0, data);          % Wyznaczenie punktu pocz¹tkowego

%% Parametry symulacji  
T = [0, 400 ];                                  % Czas symulacji
Td = 1;
Fmin = [Fh0, Fc0];
controlhandle = @DMCa;               % Obs³uga sterowania PID/PID_decouple/DMCa/DMCn
controlhandle([],[],[],[],Fmin, 0);
y0 = [3.73; 40.21];
y_step = [0.5 * y0(1); 0.5 * y0(2)];
t_step = 10;


%% Symulacja
control_delayO([], [], 0);                       % Reset funkcji realizuj¹cej opóŸnienie
controlhandle([], [], [], 0);
odeT = T(1) :0.1: T(2); 
solution1 = ode1(@(t, x)test_plant(t, x, control_delayO(t, controlhandle(mystep(t, T(1) + t_step, y0, y_step), output_delayO(t, x), t)), X0, A, B, Bz), odeT, X0);
[~, t_U1, U1] = control_delayO([], [], 1);         % Przebieg sterowania

t = odeT;                               % Wektor czasu symulacji
X1 = solution1;                    % Wektor rozwi¹zañ

stepV = [];
for t_s = T(1):Td:T(2)
    stepV = [stepV, mystep(t_s, t_step, y0, y_step)];
end
t_s = T(1):Td:T(2);

%% Wykresy
figure('NumberTitle', 'off', 'Name', 'OdpowiedŸ modelu nieliniowego na skok');
subplot(2,2,1);
hold on;
plot(t, X1(:,1));
stairs(t_s, stepV(1, :), 'Color', c(1,:), 'LineStyle', '--');
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$h[cm]$', 'interpreter', 'latex');
title('Liquid level', 'interpreter', 'latex');
legend('Output 1', 'Set value 1',  'location', 'east');
grid on;
xlim(T);

subplot(2,2,2);
% t = [0 t + tau];
% plot(t,[X1(1,2); X1(:,2)]);
plot(t, X1(:, 2));
hold on;
stairs(t_s, stepV(2, :), 'Color', c(1,:), 'LineStyle', '--');
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$T[{}^\circ C]$', 'interpreter', 'latex');
title('Temperature', 'interpreter', 'latex');
legend('Output 1', 'Set value 1', 'location', 'east');
grid on;
xlim(T);

t = t(2:end)-tau;

subplot(2,2,3);
plot(t_U1, U1(1,:)+Fh0);
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$F_H[\frac{cm^3}{s}]$', 'interpreter', 'latex');
title('Hot water flow', 'interpreter', 'latex');
legend('Input 1', 'location', 'east');
grid on;
xlim(T);

subplot(2,2,4);
plot(t_U1, U1(2,:)+Fc0);
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$F_C[\frac{cm^3}{s}]$', 'interpreter', 'latex');
title('Cold water flow', 'interpreter', 'latex');
legend('Input 1', 'location', 'east');
grid on;
xlim(T);


