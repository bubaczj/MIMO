function y = decoupler(t, A, B, C, D, U, i, del)
persistent X Y1 Y2 lastT
if isempty(t)
    t = 0;
    lastT = -1;
end
if isempty(X) || isempty(Y1) || isempty(Y2) || t < lastT
    X = [0 0];
    if i == 1
        Y1 = zeros(1, del + 1);
    end
    if i == 2
        Y2 = zeros(1, del + 1);
    end
end
X(i) = A*X(i) + B*U;
if i == 1
    Y1 = [Y1, C*X(i) + D*U];
    y = Y1(end - del);
elseif i == 2
    Y2 = [Y2, C*X(i) + D*U];
    y = Y2(end - del);
end
lastT = t;
end

