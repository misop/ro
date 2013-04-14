function [ out ] = output2binary( M )
%OUTPUT2BINARY Summary of this function goes here
%   Detailed explanation goes here
m = max(M');
nBits = 1;
num = 1;
while m > num
    nBits = nBits + 1;
    num = num * 2;
end
nBits;
[h, w] = size(M);
for i = 1:h
    out(i, :) = binary2vector(M(i), nBits);
end
end

