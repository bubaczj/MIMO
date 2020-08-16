function [dX] = test_plant(t, X, U, X0, A, B, Bz)


Us = U(1:2);                            % sterowanie
Ud = U(3:4);                            % zak³ócenie

dX = A*(X - X0) + B*Us + Bz*Ud;         % model liniowy


end