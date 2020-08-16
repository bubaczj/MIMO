%%%%% OdpowiedŸ skokowa modelu zlinearyzowanego wokó³ punktu pracy
%%%%% Edytowaæ wektor step w celu ustawienia ró¿nych wartoœci skoków

close all;
clear;
clc;
warning ('off','all');   % LaTeX interpreter warnings


%% Parametry modelu 
load('data.mat');

[A, B, Bz, X0, U0] = linAB(data.h0, data.T0, data);% Wyznaczenie modelu liniowego wokó³ punktu pracy

%% Parametry symulacji
step = [0.5; 0; 0; 0];                          
step_val = [14, 31, 0, 0]'*[-1,-0.5, 0.5, 1];   
T = [0, 600 ];                                  % Czas symulacji
controlhandle = step .* step_val;               % Obs³uga sterowania
options = odeset('MaxStep', 1, 'Refine', 1);    % Ustawienia solvera



%% Symulacja
control_delay([], [], 0);                       % Reset funkcji realizuj¹cej opóŸnienie
solution1 = ode45(@(t, x)plant_lin(t, x, control_delay(t, controlhandle(:,1)), X0, A, B, Bz), T, X0, options);
[~, t_U1, U1] = control_delay([], [], 1);         % Przebieg sterowania
control_delay([], [], 0);                       % Reset funkcji realizuj¹cej opóŸnienie
solution2 = ode45(@(t, x)plant_lin(t, x, control_delay(t, controlhandle(:,2)), X0, A, B, Bz), T, X0, options);
[~, t_U2, U2] = control_delay([], [], 1);         % Przebieg sterowania
control_delay([], [], 0);                       % Reset funkcji realizuj¹cej opóŸnienie
solution3 = ode45(@(t, x)plant_lin(t, x, control_delay(t, controlhandle(:,3)), X0, A, B, Bz), T, X0, options);
[~, t_U3, U3] = control_delay([], [], 1);         % Przebieg sterowania
control_delay([], [], 0);                       % Reset funkcji realizuj¹cej opóŸnienie
solution4 = ode45(@(t, x)plant_lin(t, x, control_delay(t, controlhandle(:,4)), X0, A, B, Bz), T, X0, options);
[~, t_U4, U4] = control_delay([], [], 1);         % Przebieg sterowania

t = T(1) : T(2);                                % Wektor czasu symulacji
X1 = (deval(solution1, t))';                    % Wektor rozwi¹zañ
X2 = (deval(solution2, t))';
X3 = (deval(solution3, t))';
X4 = (deval(solution4, t))';


%% Wykresy
figure('NumberTitle', 'off', 'Name', 'OdpowiedŸ modelu zlinearyzowanego na skok');
subplot(2,2,1);
plot(t, X1(:,1),t, X2(:,1),t, X3(:,1),t, X4(:,1));
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$h[cm]$', 'interpreter', 'latex');
title('Liquid level', 'interpreter', 'latex');
legend('skok 1','skok 2','skok 3','skok 4', 'location', 'east');
grid on;

subplot(2,2,2);
t = [0 t + tau];
plot(t,[X1(1,2); X1(:,2)],t,[X2(1,2); X2(:,2)],t,[X3(1,2); X3(:,2)],t,[X4(1,2); X4(:,2)]);
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$T[{}^\circ C]$', 'interpreter', 'latex');
title('Temperature', 'interpreter', 'latex');
legend('skok 1','skok 2','skok 3','skok 4', 'location', 'east');
grid on;

t = t(2:end)-tau;

subplot(2,2,3);
U_s = U0(1) * ones(1, T(2) - T(1) + 1);
U_s1 = [U_s(T(1)+1:T(1) + 39),  (U_s(T(1) + 40 : T(2) + 1) + step(1)*step_val(1,1))];
U_s2 = [U_s(T(1)+1:T(1) + 39),  (U_s(T(1) + 40 : T(2) + 1) + step(1)*step_val(1,2))];
U_s3 = [U_s(T(1)+1:T(1) + 39),  (U_s(T(1) + 40 : T(2) + 1) + step(1)*step_val(1,3))];
U_s4 = [U_s(T(1)+1:T(1) + 39),  (U_s(T(1) + 40 : T(2) + 1) + step(1)*step_val(1,4))];
plot(t, U_s1, t, U_s2, t, U_s3, t, U_s4 );                                                          % opóŸnione 
%%plot(t_U1, U0(1) + U1(1,:), t_U2, U0(1) + U2(1,:), t_U3, U0(1) + U3(1,:), t_U4, U0(1) + U4(1,:))  
                                                                                                    % nieopóŸnione
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$F_H[\frac{cm^3}{s}]$', 'interpreter', 'latex');
title('Hot water flaw', 'interpreter', 'latex');
legend('skok 1','skok 2','skok 3','skok 4', 'location', 'east');
grid on;

subplot(2,2,4);
U_s = U0(2) * ones(1, T(2) - T(1) + 1);
U_s1 = [U_s(T(1)+1:T(1) + 1),  (U_s(T(1) + 2 : T(2) + 1) + step(2) * step_val(2,1))];
U_s2 = [U_s(T(1)+1:T(1) + 1),  (U_s(T(1) + 2 : T(2) + 1) + step(2) * step_val(2,2))];
U_s3 = [U_s(T(1)+1:T(1) + 1),  (U_s(T(1) + 2 : T(2) + 1) + step(2) * step_val(2,3))];
U_s4 = [U_s(T(1)+1:T(1) + 1),  (U_s(T(1) + 2 : T(2) + 1) + step(2) * step_val(2,4))];
plot(t, U_s1,t, U_s2,t, U_s3,t, U_s4 );
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$F_H[\frac{cm^3}{s}]$', 'interpreter', 'latex');
title('Cold water flaw', 'interpreter', 'latex');
legend('skok 1','skok 2','skok 3','skok 4', 'location', 'east');
grid on;


