%%%%% OdpowiedŸ skokowa modelu zlinearyzowanego dyskretnego wokó³ punktu pracy

close all;
clear;
clc;
warning ('off','all');   % LaTeX interpreter warnings


%% Parametry modelu 
load('data.mat');
Ts = 5;                  % Okres próbkowania

[A,B,Bz, X0, U0] = linAB(data.h0, data.T0, data);% Wyznaczenie modelu liniowego wokó³ punktu pracy
[Ad, Bd, Bdz, C, D, G] = AB2GH(A, B, Bz, Ts);

%% Parametry symulacji
T = [0, 600 ];                                  % Czas symulacji
L = (T(2)-T(1))/Ts;                             % Liczba kroków symulacji
t = T(1):Ts:T(2);                               % Wektor chwil czasu  
step = [0.5; 0; 0; 0];                          
steps = [-1,-0.5, 0.5, 1];
step_val = [14, 31, 0, 0]'*steps;
U = step.*step_val;
[~,stepsQ] = size(steps);


%% symulacja
X0d = G*[X0; 0;0;0;0];
X(:,:,1:stepsQ) = repmat(X0d,1,1,stepsQ);         % Stan
Y0 = C*X0d;
Y(:,:,1:stepsQ) = repmat(Y0,1,1,stepsQ);

for i = 2 : L
    for s = 1 : stepsQ
       u = U(:,s);
       if  Ts*i < tauh
           u(1) = 0;
       end
       X(:,i, s) = X0d + plant_lin([],X(:,i-1,s),u,X0d, Ad, Bd, Bdz);
       Y(:,i, s) = C * X(:,i, s) + D * u;
    end
end
X = cat(2,X(:,1,:),X);
Y = cat(2,Y,Y(:,end,:));



%% Wykresy
figure();
subplot(1,2,1);
hold on;
for i = 1 : stepsQ
    stairs(t, X(1,:,i));
end
grid on;
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$h[cm]$', 'interpreter', 'latex');
title('Liquid level', 'interpreter', 'latex');
legend('skok 1','skok 2','skok 3','skok 4', 'location', 'east');

subplot(1,2,2);
hold on;
for i = 1 : stepsQ
    stairs([0 t+tau],[X(2,1,i) X(2,:,i)]);
end
grid on;
xlabel('$t[s]$', 'interpreter', 'latex');
ylabel('$T[{}^\circ C]$', 'interpreter', 'latex');
title('Temperature', 'interpreter', 'latex');
legend('skok 1','skok 2','skok 3','skok 4', 'location', 'east');



