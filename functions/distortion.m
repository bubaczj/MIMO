function Ud = distortion( t, set, arg )
persistent lastT Udhist s
if isempty(lastT)
    lastT = -Inf;
end
if t < lastT
    Udhist = [];
end
if nargin == 3
    Ud = Udhist;
elseif nargin == 2 
    s = set;
else
    Ud = s * [11; 34] .* (rand(2,1) - 0.5);
    Udhist = [Udhist, [Ud;t]];
    lastT = t;
end
end

