function u = DMCn( y_zad, y, t, start, Fm, dist )

    persistent  Lm PSIm Mm MPm options exec u_temp Uhist lastu Fmin dumax
    if isempty(t)
        t = 0;
    end
    if (isempty(exec) || (t == 0))
        exec = 0;
    end
    if isempty(u_temp) || t == 0
        u_temp = [];
    end
    Ts = 5;
    
if nargin > 5
    %% dist = 1 -- distortion +/- 50%, dist = 0 -- no distortion
    distortion([],dist);
    options = optimoptions('quadprog','Display','off');
    load("DMC.mat");
    Lm = L;
    PSIm = PSI;
    Mm = M;
    MPm = MP;
    lastu = [0; 0];
    Fmin = reshape(Fm, [],1);
    dumax = [0.5;0.5];
elseif nargin > 3
    [~, D] = size(MPm);
     Uhist = zeros(2, D/2);  
else
    if t >= exec
        exec = Ts*(floor(t/Ts) + 1);
        H = 2 *(Mm' * PSIm * Mm + Lm);
        [N, ~] = size(PSIm);
        [Nu, ~] = size(Lm);
        Y0 = MPm * reshape((Uhist),[],1) + repmat(y, N/2, 1);
        f = -2*(Mm'*PSIm * (repmat(y_zad, N/2, 1) - Y0));
        J = tril(repmat(eye(2),Nu/2, Nu/2));
        A = [-J; -Mm];
        b = [repmat((lastu + Fmin), Nu/2, 1); Y0];
        lb = - repmat(dumax, N/2, 1);
        ub = repmat(dumax, N/2, 1);
        ut = quadprog(H, f, A, b,[],[],lb,ub,[], options);
        ut = ut(1:2);
        u  = [lastu + ut; distortion(t)];
        lastu = lastu + ut;
        Uhist = [ut, Uhist(:, 1:end - 1)];
        u_temp = u;
    else
        u = u_temp;
    end
end
end



