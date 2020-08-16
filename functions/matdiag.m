function [ M ] = matdiag( varargin )
s = 0;
for i = 1 : nargin
    var = cell2mat(varargin(i));
    if size(var, 3) == 1 && size(var, 1) == size(var, 2)
        s = s + size(var, 1); 
    else
        disp('non square mtrx');
        M = false;
        return
    end
end
M = zeros(s);
s = 1;
for i = 1 : nargin
    var = cell2mat(varargin(i));
   M(s:s+size(var) - 1, s:s+size(var) - 1) = var;
   s = s + size(var);
end
end

