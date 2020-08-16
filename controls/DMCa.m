function u = DMCa( y_zad, y, t, start, Fm, dist )

    persistent  KE KU Fmin exec u_temp Uhist lastu Ts wind
    if isempty(t)
        t = 0;
    end
    if (isempty(exec) || (t == 0))
        exec = 0;
    end
    if isempty(u_temp) || t == 0
        u_temp = [];
    end
    
if nargin > 5
    %% dist = 1 -- distortion +/- 50%, dist = 0 -- no distortion
    distortion([],dist);
    Fmin = Fm;
    load("DMC.mat", 'Ke', 'Ku', 'ts');
    KE = Ke;
    KU = Ku;
    lastu = [0; 0];
    Ts = ts;
elseif nargin > 3
    [~, D] = size(KU);
     Uhist = zeros(2, D/2);  
     wind = [0; 0];
else
    if t >= exec
        exec = Ts*(floor(t/Ts) + 1);
        e  = y_zad - y(1:2);
        [~, D] = size(KU);
        ku = [0; 0];
        for i = 1 : D/2
           ku = ku + KU(:, 2 * i - 1 : 2 * i) * Uhist(:, i); 
        end
        ut = KE * e - ku + wind;
        if (ut(1) + lastu(1) + Fmin(1)) < 0 
            wind(1) = wind(1) - (ut(1) + lastu(1) + Fmin(1));
            ut(1) = - Fmin(1) - lastu(1);
        else
            wind(1) = 0;
        end
        if (ut(2) + lastu(2) + Fmin(2)) < 0
            wind(2) = wind(2) - (ut(2) + lastu(2) + Fmin(2));
            ut(2) = - Fmin(2) - lastu(2);
        else
            wind(2) = 0;
        end
        u  = [lastu + ut; distortion(t)];
        lastu = lastu + ut;
        Uhist = [ut, Uhist(:, 1:end - 1)];
        u_temp = u;
    else
        u = u_temp;
    end
end
end

