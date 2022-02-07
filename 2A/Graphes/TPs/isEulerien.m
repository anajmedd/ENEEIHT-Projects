function [ ok ] = isEulerien( G )
%ISEULERIEN Determine si un graphe est eulerien
%   Detailed explanation goes here
ordres = sum(G, 2);
impairs = mod(ordres, 2);

ok = sum(impairs) == 0 || sum(impairs) == 2;
end