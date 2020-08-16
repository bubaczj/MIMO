close all;
clear;
clc;
warning ('off','all');   % LaTeX interpreter warnings

load('data.mat');

[Fh, Fc] = meshgrid(0.5 * Fh0:1:1.5 * Fh0, 0.5 * Fc0:1:1.5 * Fc0);

H = ((Fh + Fc + Fd0)/alpha).^2;
T = (Fh * Th + Fc * Tc + Fd0 * Td0)./(Fh + Fc + Fd0);
figure();
surf(Fh, Fc, H);
grid on;
xlabel('$Fh[\frac{cm^3}{s}]$', 'interpreter', 'latex');
ylabel('$Fc[\frac{cm^3}{s}]$', 'interpreter', 'latex');
zlabel('$h[cm]$', 'interpreter', 'latex');
title('Static characteristic of water level', 'interpreter', 'latex');
figure();
surf(Fh, Fc, T);
grid on;
xlabel('$Fh[\frac{cm^3}{s}]$', 'interpreter', 'latex');
ylabel('$Fc[\frac{cm^3}{s}]$', 'interpreter', 'latex');
zlabel('$T[{}^{\circ}C]$', 'interpreter', 'latex');
title('Static characteristic of temperature', 'interpreter', 'latex');