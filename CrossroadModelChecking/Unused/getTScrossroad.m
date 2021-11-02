function TScrossroad = getTScrossroad(vehDirs)
%GETCROSSROADTS Generate a transition model of a crossroad with the
%directions of the different vehicles.
%   Detailed explanation goes here

arguments
    vehDirs                 (1,:) string    % directions of different vehicles on crossroad
end

% generate a transition system for every vehicle
for i = 1:length(vehDirs)
    TSvehicles(i) = TSvehicle(vehDirs(i));
end

% Parallelize all this vehicle transition systems to one crossroad
% transition system
TScrossroad = TransitionSystem.parallelize(TSvehicles);
end

