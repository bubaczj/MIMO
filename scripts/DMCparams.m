clear;
close all;
clc;

load("steprespmodel.mat");

[ny, nu, T] = size(S);
Gs = S(:,:,end);

D = T;                      % horyzont dynamiki, domyœlnie d³ugoœci zapisanych danych
% N = 40;                      % horyzont predykcji, domyœlnie d³ugoœci horyzontu dynamiki
N = 70;
% Nu = 5;                    % horyzont sterowania
Nu = 1;
%lambda = 3 * abs(Gs.^(-1));        % parametr lambda (taki sam, dla wszystkich predykowanych chwil)
% lambda = 100*[0.01 0; 0 0.1];
lambda = 0.1 * diag([1, 5]);
                            % (wartoœci z diagonali ustalaj¹ stosunek sterowañ)
% psi = [1 0;0 1];            % parametr psi (j/w)
% psi = 1.5 * diag([1, 0]);
psi = 7 * diag([15, 1]);

%psi = [5 1; 1 1];
%lambda = 5*eye(2);
%lambda = [5 2; 2 5];


M = zeros(N * ny, Nu * nu);
Si = reshape(permute(S, [1, 3, 2]), [], 2);
for i = 1 : Nu
   M(:, 2 * i - 1 : 2 * i) = [zeros(2 * (i - 1), 2); Si(1: 2*N - 2*(i-1), :) ];
end
MP = zeros(N * ny,(D - 1)  * nu);
for i = 1 : N
   for j = 1 : D-1 
      MPij = S(:,:, min(i + j, T)) - S(:,:, j);
      MP(2 * i - 1 : 2 * i,2 * j - 1 : 2 * j) =  MPij;
   end
end


L = [];
for i = 1 : Nu
    l = lambda;
    if Ts * i < 85
        l = diag([0.1*lambda(1,1), lambda(2,2)]);
    end
    L = matdiag(L, l);
end
PSI = [];
for i = 1 : N
    p = psi;
    if Ts * i < 85
         p = diag([psi(1,1), 0.1*psi(2,2)]);
    end
    PSI = matdiag(PSI, p);
end


%% cond safe
sL = sqrt(L);
sP = sqrt(PSI);
A = [sP * M; sL];
[Q, R] = qr(A,0);
invR = rref([R eye(size(R))]);
invR = invR(:, size(R) + 1 : 2 * size(R));
Pw = invR * Q';
K = Pw(:, 1: N*ny) * sP;

%% cond risky
% K = (M' * PSI * M + L)\M' * PSI;

K1 = K(1:2, :);
Ke = sum(reshape(K1, 2, 2, []), 3);
Ku = K1 * MP;

ts = Ts;
save("./data/DMC", "Ke", "Ku", "M", "MP", "L", "PSI", "ts");


