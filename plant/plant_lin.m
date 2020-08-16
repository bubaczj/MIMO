function [dX] = plant_lin(t, X, U, X0, A, B, Bz)


Us = U(1:2);                            % sterowanie
Ud = U(3:4);                            % zak³ócenie

dX = A*(X - X0) + B*Us + Bz*Ud;         % model liniowy

if X(1) <= 0                            % pusty zbiornik nie mo¿e siê opró¿niaæ
    dX(1, 1) = max(dX(1,1), 0);
end

end

