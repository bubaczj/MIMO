function [ Ad, Bd, Bdz, C, D, G ] = AB2GH( A, B, Bz, Ts )

    %% z internetu
    %G = expm(A*Ts);
    %H = A\(G - eye(2)) * B ;
    %% Dyskretyzacja jawnym eulerem
    % G = A.*Ts + eye(size(A));
    % H = B.*Ts;
    % Dz = Bz.*Ts;
    %% Dyskretyzacja niejawnym eulerem 
%     Ad = (eye(2) - A.*Ts/2)\(eye(2) + A.*Ts/2);
%     Bd = (eye(2) - A.*Ts/2)\B.*Ts;
%     Bdz = (eye(2) - A.*Ts/2)\Bz.*Ts;

    %% Dyskretyzacje matlabowe
    
    %% Model ciag³y
    tau = 30;
    tauh = 40;
    C = eye(2);
    D = zeros(2,4);
    B = [B, Bz];
    sys = ss(A, B, C, D);
    tr = tf(sys);
    tr.IODelay = [tauh, 0, 0, 0; tauh + tau, tau, tau, tau];
    tr.InputName = {'Hot water flaw', 'Cold water flaw','Disturbance water flaw','Disturbance water temperature'};
    tr.OutputName = {'Liquid level', 'Temperature'};
    
    
    %% 'foh' - firs order hold(trapezy), 'zoh' - zero order hold(prostok¹ty)
    %% 'tustin' - Tustin
    [trd, G] = c2d(sys, Ts, 'zoh');
    ssd = ss(trd,'explicit');
    Ad = ssd.A;
    Bd = ssd.B(:,1:2);
    Bdz = ssd.B(:,3:4);
    C = ssd.C;
    D = ssd.D;
end

