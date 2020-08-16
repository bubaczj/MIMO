%%%%% Porównanie odpowiedzi modelu i zlinearyzowanego obiektu
%%%%% Edytowaæ wektor step w celu ustawienia ró¿nych wartoœci skoków

close all;
clear;
clc;
warning ('off','all');   % LaTeX interpreter warnings


%% Parametry modelu 
load('data.mat');

[A,B,Bz, X0, U0] = linAB(data.h0, data.T0, data);% Wyznaczenie modelu liniowego wokó³ punktu pracy

%% Parametry symulacji
step = [0.5; -0.5; 0; 0];                        
step_val = [14, 31, 0, 0]'*[-1,-0.5, 0.5, 1];   
T = [0, 600 ];                                  % Czas symulacji
controlhandle = step .* step_val;               % Obs³uga sterowania
options = odeset('MaxStep', 1, 'Refine', 1);    % Ustawienia solvera


%% Symulacja
% Obiekt nieliniowy
control_delay([], [], 0);                         % Reset funkcji realizuj¹cej opóŸnienie
solution1_nl = ode45(@(t, x)plant(t, x, control_delay(t, controlhandle(:,1)), U0, data), T, X0, options);
[~, t_U1_nl, U1_nl] = control_delay([], [], 1);         % Przebieg sterowania
control_delay([], [], 0);                         % Reset funkcji realizuj¹cej opóŸnienie
solution2_nl = ode45(@(t, x)plant(t, x, control_delay(t, controlhandle(:,2)), U0, data), T, X0, options);
[~, t_U2_nl, U2_nl] = control_delay([], [], 1);         % Przebieg sterowania
control_delay([], [], 0);                         % Reset funkcji realizuj¹cej opóŸnienie
solution3_nl = ode45(@(t, x)plant(t, x, control_delay(t, controlhandle(:,3)), U0, data), T, X0, options);
[~, t_U3_nl, U3_nl] = control_delay([], [], 1);         % Przebieg sterowania
control_delay([], [], 0);                         % Reset funkcji realizuj¹cej opóŸnienie
solution4_nl = ode45(@(t, x)plant(t, x, control_delay(t, controlhandle(:,4)), U0, data), T, X0, options);
[~, t_U4_nl, U4_nl] = control_delay([], [], 1);         % Przebieg sterowania


% Obiekt zlinearyowany
control_delay([], [], 0);                       % Reset funkcji realizuj¹cej opóŸnienie
solution1_l = ode45(@(t, x)plant_lin(t, x, control_delay(t, controlhandle(:,1)), X0, A, B, Bz), T, X0, options);
[~, t_U1_l, U1_l] = control_delay([], [], 1);         % Przebieg sterowania
control_delay([], [], 0);                       % Reset funkcji realizuj¹cej opóŸnienie
solution2_l = ode45(@(t, x)plant_lin(t, x, control_delay(t, controlhandle(:,2)), X0, A, B, Bz), T, X0, options);
[~, t_U2_l, U2_l] = control_delay([], [], 1);         % Przebieg sterowania
control_delay([], [], 0);                       % Reset funkcji realizuj¹cej opóŸnienie
solution3_l = ode45(@(t, x)plant_lin(t, x, control_delay(t, controlhandle(:,3)), X0, A, B, Bz), T, X0, options);
[~, t_U3_l, U3_l] = control_delay([], [], 1);         % Przebieg sterowania
control_delay([], [], 0);                       % Reset funkcji realizuj¹cej opóŸnienie
solution4_l = ode45(@(t, x)plant_lin(t, x, control_delay(t, controlhandle(:,4)), X0, A, B, Bz), T, X0, options);
[~, t_U4_l, U4_l] = control_delay([], [], 1);         % Przebieg sterowania






t = T(1) : T(2);                                % Wektor czasu symulacji
X1_nl = (deval(solution1_nl, t))';              % Wektor rozwi¹zañ obiektu nieliniowego
X2_nl = (deval(solution2_nl, t))';
X3_nl = (deval(solution3_nl, t))';
X4_nl = (deval(solution4_nl, t))';

X1_l = (deval(solution1_l, t))';              % Wektor rozwi¹zañ obiektu zlinearyzowanego
X2_l = (deval(solution2_l, t))';
X3_l = (deval(solution3_l, t))';
X4_l = (deval(solution4_l, t))';

%% Wykresy
figure('NumberTitle', 'off', 'Name', 'Porównanie odpowiedzi na skok obiektu liniowego z nieliniowym');
subplot(1,2,1);
plot(t, X1_l(:,1),'-.b',t, X2_l(:,1),'-.r',t, X3_l(:,1),'-.c',t, X4_l(:,1),'-.m',...
    t, X1_nl(:,1),  'b',t, X2_nl(:,1), 'r',t, X3_nl(:,1), 'c',t, X4_nl(:,1), 'm');
hold on;
p_1 = plot(t, X1_l(:,1),'-.b');
p_2 = plot(t, X1_nl(:,1),'b');
legend([p_1, p_2],{'Obiekt liniowy', 'Obiekt nieliniowy'});
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$h[cm]$', 'interpreter', 'latex');
title('Liquid level', 'interpreter', 'latex');
xlim(T);

% legend('skok 1, obiekt liniowy','skok 2, obiekt liniowy','skok 3, obiekt liniowy','skok 4, obiekt liniowy',...
%     'skok 1, obiekt nieliniowy','skok 2, obiekt nieliniowy','skok 3, obiekt nieliniowy','skok 4, nieobiekt liniowy',...
%     'location', 'east');
grid on;

subplot(1,2,2);
t = [0 t+ tau];
plot(t,[X1_l(1,2); X1_l(:,2)],'-.b',t, [X2_l(1,2); X2_l(:,2)],'-.r',t, [X3_l(1,2); X3_l(:,2)],'-.c',t, [X4_l(1,2); X4_l(:,2)],'-.m',...
    t, [X1_nl(1,2); X1_nl(:,2)],  'b',t, [X2_nl(1,2); X2_nl(:,2)], 'r',t, [X3_nl(1,2); X3_nl(:,2)], 'c',t, [X4_nl(1,2); X4_nl(:,2)], 'm');
hold on;
p_1 = plot(t, [X1_l(1,2); X1_l(:,2)],'-.b');
p_2 = plot(t, [X1_nl(1,2); X1_nl(:,2)],'b');
legend([p_1, p_2],{'Obiekt liniowy', 'Obiekt nieliniowy'});
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$T[{}^\circ C]$', 'interpreter', 'latex');
title('Temperature', 'interpreter', 'latex');
% legend('skok 1, obiekt liniowy','skok 2, obiekt liniowy','skok 3, obiekt liniowy','skok 4, obiekt liniowy',...
%     'skok 1, obiekt nieliniowy','skok 2, obiekt nieliniowy','skok 3, obiekt nieliniowy','skok 4, obiekt nieliniowy',...
%     'location', 'east');
grid on;
xlim(T);
