%%%%% Porównanie liniowych dyskretnych modeli: równania stanu vs
%%%%% transmitancja

close all;
clear;
clc;
colors = get(groot,'DefaultAxesColorOrder');
mrkS = 4;                % Marker size
lW = 0.001;                % line width
warning ('off','all');   % LaTeX interpreter warnings


%% Parametry modelu 
load('data.mat');
Ts = 5;                  % Okres próbkowania

[A,B,Bs, X0, U0] = linAB(data.h0, data.T0, data);% Wyznaczenie modelu liniowego wokó³ punktu pracy
[Ad, Bd, Bds, C, D, G] = AB2GH(A, B, Bs, Ts);

%% Parametry symulacji
T = [0, 100 ];                                  % Czas symulacji
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
       X(:,i, s) = X0d + plant_lin([],X(:,i-1,s),u,X0d, Ad, Bd, Bds);
       Y(:,i, s) = C * X(:,i, s) + D * u;
    end
end
X = cat(2,X,X(:,end,:));
Y = cat(2,Y,Y(:,end,:));


supU = [ones(2, L+1);zeros(2,L+1)];
y = zeros(L+1, 2, stepsQ);
for s = 1 : stepsQ
    u = (supU.*U(:,s))';
    [y(:,1:2,s),~,~] = lsim(trd, u, t1);
    y(:,1:2,s) = y(:,1:2,s) + Y0';
end
y = permute(y, [2 1 3]);






%% Wykresy
figure();
subplot(2,2,1);
hold on;
p_1 = stairs(t1, Y(1,:,1),'color',colors(1,:));
stairs(t1, Y(1,:,2),'color',colors(2,:));
stairs(t1, Y(1,:,3),'color',colors(3,:));
stairs(t1, Y(1,:,4),'color',colors(4,:));
p_2 = stairs(t1, y(1,:,1),'color',colors(1,:), 'Marker', 'x', 'MarkerSize', mrkS);
stairs(t1, y(1,:,2),'color',colors(2,:), 'Marker', 'x', 'MarkerSize', mrkS);
stairs(t1, y(1,:,3),'color',colors(3,:), 'Marker', 'x', 'MarkerSize', mrkS);
stairs(t1, y(1,:,4),'color',colors(4,:), 'Marker', 'x', 'MarkerSize', mrkS);

grid on;
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$h[cm]$', 'interpreter', 'latex');
title('Liquid level', 'interpreter', 'latex');
legend([p_1, p_2], {'Space-state','Transmittance'}, 'location', 'east');
xlim(T);


subplot(2,2,2);
hold on;
p_1 = stairs(t1, Y(1,:,1) - y(1,:,1),'color',colors(1,:));
stairs(t1, Y(1,:,2) - y(1,:,2),'color',colors(2,:));
stairs(t1, Y(1,:,3) - y(1,:,3),'color',colors(3,:));
stairs(t1, Y(1,:,4) - y(1,:,4),'color',colors(4,:));
grid on;
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$h[cm]$', 'interpreter', 'latex');
title('Liquid level diffrence', 'interpreter', 'latex');
%legend(p_1, {'Diffrence'}, 'location', 'east');
xlim([T(1), T(2)-Ts]);

subplot(2,2,3);
hold on;
p_1 = stairs([0 t1+tau],[Y(2,1,1) Y(2,:,1)],'color',colors(1,:));
stairs([0 t1+tau],[Y(2,1,2) Y(2,:,2)],'color',colors(2,:));
stairs([0 t1+tau],[Y(2,1,3) Y(2,:,3)],'color',colors(3,:));
stairs([0 t1+tau],[Y(2,1,4) Y(2,:,4)],'color',colors(4,:));

p_2 = stairs(t1, y(2,:,1),'color',colors(1,:), 'Marker', 'x', 'MarkerSize', mrkS);
stairs(t1, y(2,:,2),'color',colors(2,:), 'Marker', 'x', 'MarkerSize', mrkS);
stairs(t1, y(2,:,3),'color',colors(3,:), 'Marker', 'x', 'MarkerSize', mrkS);
stairs(t1, y(2,:,4),'color',colors(4,:), 'Marker', 'x', 'MarkerSize', mrkS);


grid on;
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$T[{}^\circ C]$', 'interpreter', 'latex');
title('Temperature', 'interpreter', 'latex');
legend([p_1, p_2], {'Space-state','Transmittance'}, 'location', 'east');
xlim(T);


subplot(2,2,4);
hold on;
Y = cat(2, repmat(Y(:, 1, :), [1 tau/Ts 1]), Y(:,1:end - tau/Ts, :));
p_1 = stairs(t1,Y(2,:,1) - y(2,:,1),'color',colors(1,:));
stairs(t1,Y(2,:,2) - y(2,:,2),'color',colors(2,:));
stairs(t1,Y(2,:,3) - y(2,:,3),'color',colors(3,:));
stairs(t1,Y(2,:,4) - y(2,:,4),'color',colors(4,:));
grid on;
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$T[{}^\circ C]$', 'interpreter', 'latex');
title('Temperature diffrence', 'interpreter', 'latex');
%legend(p_1, {'Diffrence'}, 'location', 'east');
xlim(T);








