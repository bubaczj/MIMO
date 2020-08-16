%%%%% Regulacja obiektu nieliniowego
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

%% Parametry symulacji
Ts = 5;
step = [0.5; -0.5; 0; 0];                        
step_val = [14, 31, 0, 0]'*[-1,-0.5, 0.5, 1];    
T = [0, 600 ];                                  % Czas symulacji
Fmin = [Fh0, Fc0];
controlhandle = @DMCa;               % Obs³uga sterowania PID/PID_decouple/DMCa/DMCn
controlhandle([],[],[],[],Fmin, 0);
y0 = [3.73; 40.21];
% y_step1 = [-0.1; -0.].*y0;
% y_step2 = [-0.2; -0.].*y0;
% y_step3 = [0.3; 0.] .*y0;
% y_step4 = [0.5; 0.] .*y0;

y_step1 = [-0.; -0.2].*y0;
y_step2 = [-0.; -0.1].*y0;
y_step3 = [0.; 0.3] .*y0;
y_step4 = [0.; 0.5] .*y0;
t_step = 10;
options = odeset('MaxStep', 1, 'Refine', 1);    % Ustawienia solvera


%% Symulacja
control_delay([], [], 0);                       % Reset funkcji realizuj¹cej opóŸnienie
controlhandle([], [], [], 0);
solution1 = ode45(@(t, x)plant(t, x, control_delay(t, controlhandle(mystep(t, T(1) + t_step, y0, y_step1), output_delay(t, x), t)), U0, data), T, X0, options);
[~, t_U1, U1] = control_delay([], [], 1);         % Przebieg sterowania
control_delay([], [], 0);                       % Reset funkcji realizuj¹cej opóŸnienie
controlhandle([], [], [], 0);
solution2 = ode45(@(t, x)plant(t, x, control_delay(t, controlhandle(mystep(t, T(1) + t_step, y0, y_step2), output_delay(t, x), t)), U0, data), T, X0, options);
[~, t_U2, U2] = control_delay([], [], 1);         % Przebieg sterowania
control_delay([], [], 0);                       % Reset funkcji realizuj¹cej opóŸnienie
controlhandle([], [], [], 0);
solution3 = ode45(@(t, x)plant(t, x, control_delay(t, controlhandle(mystep(t, T(1) + t_step, y0, y_step3), output_delay(t, x), t)), U0, data), T, X0, options);
[~, t_U3, U3] = control_delay([], [], 1);         % Przebieg sterowania
control_delay([], [], 0);                       % Reset funkcji realizuj¹cej opóŸnienie
controlhandle([], [], [], 0);
solution4 = ode45(@(t, x)plant(t, x, control_delay(t, controlhandle(mystep(t, T(1) + t_step, y0, y_step4), output_delay(t, x), t)), U0, data), T, X0, options);
[~, t_U4, U4] = control_delay([], [], 1);         % Przebieg sterowania

t = T(1) : T(2);                                % Wektor czasu symulacji
X1 = (deval(solution1, t))';                    % Wektor rozwi¹zañ
X2 = (deval(solution2, t))';
X3 = (deval(solution3, t))';
X4 = (deval(solution4, t))';

st = [];
S1 = [];
S2 = [];
S3 = [];
S4 = [];
for sti = T(1):Ts:T(2)
    st = [st, sti];
    S1 = [S1, mystep(sti, T(1) + t_step, y0, y_step1)];
    S2 = [S2, mystep(sti, T(1) + t_step, y0, y_step2)];
    S3 = [S3, mystep(sti, T(1) + t_step, y0, y_step3)];
    S4 = [S4, mystep(sti, T(1) + t_step, y0, y_step4)];
end


%% Wykresy
figure('NumberTitle', 'off', 'Name', 'OdpowiedŸ modelu nieliniowego na skok');
subplot(2,2,1);
hold on;
plot(t, X1(:,1),t, X2(:,1),t, X3(:,1),t, X4(:,1));
stairs(st, S1(1, :), 'Color', c(1,:), 'LineStyle', '--');
stairs(st, S2(1, :), 'Color', c(2,:), 'LineStyle', '--');
stairs(st, S3(1, :), 'Color', c(3,:), 'LineStyle', '--');
stairs(st, S4(1, :), 'Color', c(4,:), 'LineStyle', '--');
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$h[cm]$', 'interpreter', 'latex');
title('Liquid level', 'interpreter', 'latex');
legend('Step 1','Step 2','Step 3','Step 4', 'location', 'east');
grid on;
xlim(T);

subplot(2,2,2);
t = [0 t + tau];
plot(t,[X1(1,2); X1(:,2)],t,[X2(1,2); X2(:,2)],t,[X3(1,2); X3(:,2)],t,[X4(1,2); X4(:,2)]);
hold on;
stairs(st, S1(2, :), 'Color', c(1,:), 'LineStyle', '--');
stairs(st, S2(2, :), 'Color', c(2,:), 'LineStyle', '--');
stairs(st, S3(2, :), 'Color', c(3,:), 'LineStyle', '--');
stairs(st, S4(2, :), 'Color', c(4,:), 'LineStyle', '--');
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$T[{}^\circ C]$', 'interpreter', 'latex');
title('Temperature', 'interpreter', 'latex');
legend('Step 1','Step 2','Step 3','Step 4', 'location', 'east');
grid on;
xlim(T);

t = t(2:end)-tau;

subplot(2,2,3);
plot(t_U1, U1(1,:)+Fh0,t_U2, U2(1,:)+Fh0,t_U3, U3(1,:)+Fh0,t_U4, U4(1,:)+Fh0);
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$F_H[\frac{cm^3}{s}]$', 'interpreter', 'latex');
title('Hot water flow', 'interpreter', 'latex');
legend('Step 1','Step 2','Step 3','Step 4', 'location', 'east');
grid on;
xlim(T);

subplot(2,2,4);
plot(t_U1, U1(2,:)+Fc0,t_U2, U2(2,:)+Fc0,t_U3, U3(2,:)+Fc0,t_U4, U4(2,:)+Fc0);
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$F_C[\frac{cm^3}{s}]$', 'interpreter', 'latex');
title('Cold water flow', 'interpreter', 'latex');
legend('Step 1','Step 2','Step 3','Step 4', 'location', 'east');
grid on;
xlim(T);


