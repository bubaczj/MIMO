function u = PID(y_zad, y, t, start, Fm, dist)

    persistent  e1 e2 wind Fmin exec u_temp R1 R2 R0 Ra Ts
    if isempty(t)
        t = 0;
    end
    if (isempty(exec) || (t == 0))
        exec = 0;
    end
    if isempty(u_temp) || t == 0
        u_temp = [0 0 0 0]';
    end
if nargin > 5
    %% dist = 1 -- distortion +/- 50%, dist = 0 -- no distortion
     Ts = 5;
    conn = aeye(2); % eye : 1-1/2-2; aeye : 1-2/2-1
    %% tuning PID
    Kp = [0.3 * 0.6 * 273         0.7 * 0.6 * 0.6 * 2.2];   
    Ti = [15  * 0.5 * 10     0.7 * 1 * 0.5 * 115];
    Td = [0.3 * 10/8       0.4 * 1.7 * 115/8];
    Tv = [8       5.5]';
    Tp = Ts;
    r0 = Kp.*(1 + Tp./(2*Ti) + Td./Tp);
    r1 = Kp.*(Tp./(2*Ti) - 2 * Td./Tp - 1);
    r2 = Kp.*Td./Tp;
    ra = Tp./Tv;
    R0 = r0.* conn;
    R1 = r1  .* conn;
    R2 = r2 .* conn;
    Ra = eye(2) * ra;
    
    distortion([],dist);
    Fmin = Fm;
elseif nargin > 3
        e1 = [0; 0];
        e2 = [0; 0];
        u_temp = [0 0 0 0]';
        wind = [0; 0];   
else
    if t >= exec
        exec = Ts*(floor(t/Ts) + 1);
        e  = y_zad - y(1:2);
        u = u_temp + [R0 * e + R1 * e1 + R2 * e2 + Ra .* wind; distortion(t)];
        if (u(1) + Fmin(1)) < 0 
            wind(1) = u(1) + Fmin(1);
            u(1) = -Fmin(1);
        else
            wind(1) = 0;
        end
        if (u(2) + Fmin(2)) < 0
            wind(2) = u(2) + Fmin(2);
            u(2) = - Fmin(2);
        else
            wind(2) = 0;
        end
        e2 = e1;
        e1 = e;
        u_temp = u;
    else
        u = u_temp;
    end
end
end

