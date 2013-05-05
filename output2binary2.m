function [ out ] = output2binary2( M )
%OUTPUT2BINARY2 Summary of this function goes here
%   Detailed explanation goes here
[n, x] = size(M);
m = max(M');
out = boolean(zeros(n, m));
for i = 1:n
    out(i, M(i)) = true;
end
end

