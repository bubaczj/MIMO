%%%%% Model transmitacyjny zlinearyzowany z opóŸnieniami

close all;
clear;
clc;
warning ('off','all');   % LaTeX interpreter warnings


%% Parametry modelu 
load('data.mat');

[A,B,Bz, X0, U0] = linAB(data.h0, data.T0, data);% Wyznaczenie modelu liniowego wokó³ punktu pracy

Ts = 5;                                          % Krok dyskretyzacji

%% Transmitancja obiektu ci¹g³ego zlinearyzowanego
C = eye(2);
D = zeros(2,4);
B = [B, Bz];
sys = ss(A, B, C, D);
tr = tf(sys);
tr.IODelay = [tauh, 0, 0, 0; tauh + tau, tau, tau, tau];
tr.InputName = {'Hot water flaw', 'Cold water flaw','Disturbance water flaw','Disturbance water temperature'};
tr.OutputName = {'Liquid level', 'Temperature'};

%% Odkomentowaæ w celu wyœwietlenia transmitancji obiektu ci¹g³ego
% tr
save('data.mat','tr','-append');

%% Macierz wra¿liwoœci, uwarunkowanie i wartoœciw³asne
sens = evalfr(tr, 0)
cond(sens(:, 1:2))
svd(sens(:, 1:2))

%% Transmitancja obiektu dyskretnego zlinearyzowanego
trd = c2d(tr, Ts, 'zoh');
ss_sysd = ss(trd);


%% Odkomentowaæ w celu wyœwietlenia transmitancji obiektu dyskretnego
% trd
save('data.mat','trd','-append');


