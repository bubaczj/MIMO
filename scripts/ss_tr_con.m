%%%%% Porównanie liniowy - dyskretny liniowy

close all;
clear;
clc;
colors = get(groot,'DefaultAxesColorOrder');
warning ('off','all');   % LaTeX interpreter warnings


%% Parametry modelu 
load('data.mat');
Ts = 1;                  % Okres próbkowania

[A,B,Bz, X0, U0] = linAB(data.h0, data.T0, data);% Wyznaczenie modelu liniowego wokó³ punktu pracy
[Ad, Bd, Bdz, C, D, G] = AB2GH(A, B, Bz, Ts);

%% Parametry symulacji
T = [0, 100 ];                                  % Czas symulacji
L = (T(2)-T(1))/Ts;                             % Liczba kroków symulacji
t1 = T(1):Ts:T(2);                               % Wektor chwil czasu  
step = [0.5; 0.5; 0; 0];                          
steps = [-1,-0.5, 0.5, 1];
step_val = [14, 31, 0, 0]'*steps;
controlhandle = step .* step_val;               % Obs³uga sterowania
options = odeset('MaxStep', 0.1, 'Refine', 1);    % Ustawienia solvera
U = step.*step_val;
[~,stepsQ] = size(steps);


%% Symulacja transmitancj¹
%X0d = G*[X0; 0;0;0;0];
%Y0 = C*X0d;
Y0 = [h0; T0];
supU = [ones(2, L+1);zeros(2,L+1)];
y = zeros(L+1, 2, stepsQ);
for s = 1 : stepsQ
    u = (supU.*U(:,s))';
    [y(:,1:2,s),~,~] = lsim(tr, u, t1);
    y(:,1:2,s) = y(:,1:2,s) + Y0';
end
y = permute(y, [2 1 3]);


%% Symulacja ci¹g³a
control_delay([], [], 0);                       % Reset funkcji realizuj¹cej opóŸnienie
solution1 = ode45(@(t, x)plant_lin(t, x, control_delay(t, controlhandle(:,1)), X0, A, B, Bdz), T, X0, options);
[~, t_U1, U1] = control_delay([], [], 1);         % Przebieg sterowania
control_delay([], [], 0);                       % Reset funkcji realizuj¹cej opóŸnienie
solution2 = ode45(@(t, x)plant_lin(t, x, control_delay(t, controlhandle(:,2)), X0, A, B, Bdz), T, X0, options);
[~, t_U2, U2] = control_delay([], [], 1);         % Przebieg sterowania
control_delay([], [], 0);                       % Reset funkcji realizuj¹cej opóŸnienie
solution3 = ode45(@(t, x)plant_lin(t, x, control_delay(t, controlhandle(:,3)), X0, A, B, Bdz), T, X0, options);
[~, t_U3, U3] = control_delay([], [], 1);         % Przebieg sterowania
control_delay([], [], 0);                       % Reset funkcji realizuj¹cej opóŸnienie
solution4 = ode45(@(t, x)plant_lin(t, x, control_delay(t, controlhandle(:,4)), X0, A, B, Bdz), T, X0, options);
[~, t_U4, U4] = control_delay([], [], 1);         % Przebieg sterowania

t = t1;                                         % Wektor czasu symulacji
X1 = (deval(solution1, t))';                    % Wektor rozwi¹zañ
X2 = (deval(solution2, t))';
X3 = (deval(solution3, t))';
X4 = (deval(solution4, t))';


%% Wykresy
figure();
subplot(2,2,1);
hold on;
p_1 = plot(t1, y(1,:,1),'color',colors(1,:));
plot(t1, y(1,:,2),'color',colors(2,:));
plot(t1, y(1,:,3),'color',colors(3,:));
plot(t1, y(1,:,4),'color',colors(4,:));
p_2 = plot(t, X1(:,1),'color',colors(1,:));
plot(t, X2(:,1),'color',colors(2,:));
plot(t, X3(:,1),'color',colors(3,:));
plot(t, X4(:,1),'color',colors(4,:));
grid on;
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$h[cm]$', 'interpreter', 'latex');
title('Liquid level', 'interpreter', 'latex');
legend([p_1, p_2], {'Transmittance','State-space'}, 'location', 'east');
xlim(T);



subplot(2,2,2);
hold on;
p_1 = plot(t1, (y(1,:,1) - X1(:,1)'),'color',colors(1,:));
plot(t1, (y(1,:,2) - X2(:,1)'),'color',colors(2,:));
plot(t1, (y(1,:,3) - X3(:,1)'),'color',colors(3,:));
plot(t1, (y(1,:,4) - X4(:,1)'),'color',colors(4,:));
grid on;
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$\Delta h[cm]$', 'interpreter', 'latex');
title('Liquid level diffrence', 'interpreter', 'latex');
%legend(p_1, {'Diffrence'}, 'location', 'east');
xlim(T);






subplot(2,2,3);
hold on;
p_1 = plot(t1, y(2,:,1),'color',colors(1,:));
plot(t1, y(2,:,2),'color',colors(2,:));
plot(t1, y(2,:,3),'color',colors(3,:));
plot(t1, y(2,:,4),'color',colors(4,:));

p_2 = plot([0 t+tau],[X1(1,2); X1(:,2)],'color',colors(1,:));
plot([0 t+tau],[X2(1,2); X2(:,2)],'color',colors(2,:));
plot([0 t+tau],[X3(1,2); X3(:,2)],'color',colors(3,:));
plot([0 t+tau],[X4(1,2); X4(:,2)],'color',colors(4,:));
grid on;
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$T[{}^\circ C]$', 'interpreter', 'latex');
title('Temperature', 'interpreter', 'latex');
legend([p_1, p_2], {'Transmittance','State-space'}, 'location', 'east');
xlim(T);




subplot(2,2,4);
hold on;
X1 = cat(1, repmat(X1(1, :), [tau/Ts 1]), X1(1:end - tau/Ts, :));
X2 = cat(1, repmat(X2(1, :), [tau/Ts 1]), X2(1:end - tau/Ts, :));
X3 = cat(1, repmat(X3(1, :), [tau/Ts 1]), X3(1:end - tau/Ts, :));
X4 = cat(1, repmat(X4(1, :), [tau/Ts 1]), X4(1:end - tau/Ts, :));
p_1 = plot(t1, y(2,:,1) - X1(:,2)','color',colors(1,:));
plot(t1, y(2,:,2) - X2(:,2)','color',colors(2,:));
plot(t1, y(2,:,3) - X3(:,2)','color',colors(3,:));
plot(t1, y(2,:,4) - X4(:,2)','color',colors(4,:));
grid on;
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$\Delta T[{}^\circ C]$', 'interpreter', 'latex');
title('Temperature diffrence', 'interpreter', 'latex');
%legend(p_1, {'Diffrence'}, 'location', 'east');
xlim(T);





