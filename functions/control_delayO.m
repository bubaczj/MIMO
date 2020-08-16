function [U_del, t_hist, U_hist] = control_delayO(t, U, start)

persistent U_val U_time

if nargin > 2
    
    if start == 0
        U_time = [0];
        U_val = [0; 0; 0; 0];
    elseif start == 1
        U_hist = U_val;
        t_hist = U_time;
        U_del = [];
    end
    
else
    
    U_time = [U_time, t];
    U_val = [U_val, U];
    
    U_del = U;
    
end

end

