function u = PID_decouple(y_zad, y, t, start, Fm, dist)

    persistent  e1 e2 wind Fmin exec u_temp u_out R1 R2 R0 Ra Ts P1 P2
    if isempty(t)
        t = 0;
    end
    if (isempty(exec) || (t == 0))
        exec = 0;
    end
    if isempty(u_temp) || t == 0
        u_temp = [0 0 0 0]';
        u_out = u_temp;
    end

if nargin > 5
    %% dist = 1 -- distortion +/- 50%, dist = 0 -- no distortion
    distortion([],dist);
    Fmin = Fm;
    
    conn = aeye(2);
    Ts = 5;
    %% PID tuning
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
    
    %% Decoupler
    load('data.mat', 'tr');
    del = tr.IODelay;
    tr.IODelay = zeros(2, 4);
    
    if(sum(sum(conn == eye(2))) > 0)
        Gd1 = -tr(1,2)/tr(1,1);
        Gd1.IODelay = max(0, del(1,2)-del(1,1));
        Gd1 = c2d(Gd1, Ts, 'zoh');
        [A1, B1, C1, D1] = tf2ss(cell2mat(Gd1.Numerator), cell2mat(Gd1.Denominator));
        del1 = Gd1.IODelay;
        Gd2 = -tr(2,1)/tr(2,2);
        Gd2.IODelay = max(0, del(2,1)-del(2,2));
        Gd2 = c2d(Gd2, Ts, 'zoh');
        [A2, B2, C2, D2] = tf2ss(cell2mat(Gd2.Numerator), cell2mat(Gd2.Denominator));
        del2 = Gd2.IODelay;
    else
        Gd1 = -tr(2,2)/tr(2,1);
        Gd1.IODelay = max(0, del(2,2)-del(2,1))/Ts;
        Gd1 = c2d(Gd1, Ts, 'zoh');
        [A1, B1, C1, D1] = tf2ss(cell2mat(Gd1.Numerator), cell2mat(Gd1.Denominator));
        del1 = Gd1.IODelay;
        Gd2 = -tr(1,1)/tr(1,2);
        Gd2.IODelay = max(0, del(1,1)-del(1,2))/Ts;
        Gd2 = c2d(Gd2, Ts, 'zoh');
        [A2, B2, C2, D2] = tf2ss(cell2mat(Gd2.Numerator), cell2mat(Gd2.Denominator));
        del2 = Gd2.IODelay;
    end 
    if isempty(A1), A1 = 0;end
    if isempty(B1), B1 = 0;end
    if isempty(C1), C1 = 0;end
    if isempty(D1), D1 = 0;end
    if isempty(A2), A2 = 0;end
    if isempty(B2), B2 = 0;end
    if isempty(C2), C2 = 0;end
    if isempty(D2), D2 = 0;end
    
    P1 = [A1, B1, C1, D1, del1];
    P2 = [A2, B2, C2, D2, del2];
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
        u_temp = u;
        dec1 = decoupler(t, P1(1), P1(2), P1(3), P1(4), u(2), 1, P1(5));
        dec2 = decoupler(t, P2(1), P2(2), P2(3), P2(4), u(1), 2, P2(5));
        u = u + [0*dec1; dec2; 0; 0];
        if (u(1) + Fmin(1)) < 0 
            wind(1) = wind(1) + Fmin(1);
            u(1) = -Fmin(1);
        end
        if (u(2) + Fmin(2)) < 0
            wind(2) = wind(2) + Fmin(2);
            u(2) = - Fmin(2);
        end
        e2 = e1;
        e1 = e;
        u_out = u;
    else
        u = u_out;
    end
end
end

