function [ column, out ] = takeColumn( M, i )
%TAKECOLUMN Summary of this function goes here
%   Detailed explanation goes here
column = M(:, i);
out = [M(:, 1:i-1) M(:, i+1:end)];
end

