%%%%% Porównanie liniowy - dyskretny liniowy

close all;
clear;
clc;
colors = get(groot,'DefaultAxesColorOrder');
warning ('off','all');   % LaTeX interpreter warnings


%% Parametry modelu 
load('data.mat');
Ts = 20;                  % Okres próbkowania

[A,B,Bz, X0, U0] = linAB(data.h0, data.T0, data);% Wyznaczenie modelu liniowego wokó³ punktu pracy
[Ad, Bd, Bdz, C, D, G] = AB2GH(A, B, Bz, Ts);

%% Parametry symulacji
T = [0, 600 ];                                  % Czas symulacji
L = (T(2)-T(1))/Ts;                             % Liczba kroków symulacji
t1 = T(1):Ts:T(2);                               % Wektor chwil czasu  
step = [0.5; 0.5; 0; 0];                          
steps = [-1,-0.5, 0.5, 1];
step_val = [14, 31, 0, 0]'*steps;
controlhandle = step .* step_val;               % Obs³uga sterowania
options = odeset('MaxStep', 1, 'Refine', 1);    % Ustawienia solvera
U = step.*step_val;
[~,stepsQ] = size(steps);


%% Symulacja dyskretna
X0d = G*[X0; 0;0;0;0];
X(:,:,1:stepsQ) = repmat(X0d,1,1,stepsQ);         % Stan
Y0 = C*X0d;
Y(:,:,1:stepsQ) = repmat(Y0,1,1,stepsQ);
for i = 2 : L
    for s = 1 : stepsQ
       u = U(:,s);
       if  Ts*(i-2) < tauh
           u(1) = 0;
       end
       X(:,i, s) = X0d + plant_lin(Ts*i,X(:,i-1,s),u,X0d, Ad, Bd, Bdz);
       Y(:,i, s) = C * X(:,i, s) + D * u;
    end
end
X = cat(2,X,X(:,end,:));
Y = cat(2,Y,Y(:,end,:));


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

t = T(1) : T(2);                                % Wektor czasu symulacji
X1 = (deval(solution1, t))';                    % Wektor rozwi¹zañ
X2 = (deval(solution2, t))';
X3 = (deval(solution3, t))';
X4 = (deval(solution4, t))';


%% Wykresy
figure();
subplot(1,2,1);
hold on;
stairs(t1, Y(1,:,1),'color',colors(1,:));
stairs(t1, Y(1,:,2),'color',colors(2,:));
stairs(t1, Y(1,:,3),'color',colors(3,:));
stairs(t1, Y(1,:,4),'color',colors(4,:));
plot(t, X1(:,1),'color',colors(1,:));
plot(t, X2(:,1),'color',colors(2,:));
plot(t, X3(:,1),'color',colors(3,:));
plot(t, X4(:,1),'color',colors(4,:));
grid on;
p_1 = stairs(t1, Y(1,:,1),'color',colors(1,:));
p_2 = plot(t, X1(:,1),'color',colors(1,:));
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$h[cm]$', 'interpreter', 'latex');
title('Liquid level', 'interpreter', 'latex');
legend([p_1, p_2], {'linearized discrete','linearized continous'}, 'location', 'east');
xlim(T);

subplot(1,2,2);
hold on;
stairs([0 t1+tau],[Y(2,1,1) Y(2,:,1)],'color',colors(1,:));
stairs([0 t1+tau],[Y(2,1,2) Y(2,:,2)],'color',colors(2,:));
stairs([0 t1+tau],[Y(2,1,3) Y(2,:,3)],'color',colors(3,:));
stairs([0 t1+tau],[Y(2,1,4) Y(2,:,4)],'color',colors(4,:));

plot([0 t+tau],[X1(1,2); X1(:,2)],'color',colors(1,:));
plot([0 t+tau],[X2(1,2); X2(:,2)],'color',colors(2,:));
plot([0 t+tau],[X3(1,2); X3(:,2)],'color',colors(3,:));
plot([0 t+tau],[X4(1,2); X4(:,2)],'color',colors(4,:));
grid on;
p_1 = stairs([0 t1+tau],[Y(2,1,1) Y(2,:,1)],'color',colors(1,:));
p_2 = plot([0 t+tau],[X1(1,2); X1(:,2)],'color',colors(1,:));
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$T[{}^\circ C]$', 'interpreter', 'latex');
title('Temperature', 'interpreter', 'latex');
legend([p_1, p_2], {'linearized discrete','linearized continous'}, 'location', 'east');
xlim(T);



