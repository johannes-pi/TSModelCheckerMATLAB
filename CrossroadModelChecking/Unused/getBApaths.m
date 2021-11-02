function [Q, Sig, delta, Q0, F] = getBApaths(crossingPath)
%GETBAPATHS Return a Büchi automata with the crossing paths condition
%   Detailed explanation goes here

arguments
    crossingPath          (1,2) string    % two paths that are crossing each other
end

% States
Q = ["q0" "q1"];

% Symbols Sigma (transition conditions)
% conditions for the transition between states

dir1 = crossingPath(1);
dir2 = crossingPath(2);

Sig = {@(allAPs) (~(allAPs.("p"+dir1) && allAPs.("p"+dir2)) && ~allAPs.("o"+dir1) && ~allAPs.("o"+dir2)) ...
       @(allAPs) (allAPs.("o"+dir1) || allAPs.("o"+dir2)) ...
       @(allAPs) (1)};

% Transitions
delta = {"q0" "q0" Sig{1}; ...
         "q0" "q1" Sig{2}; ... 
         "q1" "q1" Sig{3}};
    
% Initial states
Q0 = ["q0"];

% Final states
F = ["q1"];
end

