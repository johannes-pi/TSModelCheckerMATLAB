% Pairs of directions that are crossing at the crossroad ("ne" means
% Nort-East)
crossingPaths = ["ne", "ew";
                 "ne", "wn";
                 "ne", "es";
                 "ne", "sn";
                 "ne", "we";
                 "ne", "se";
                 "ns", "ew";
                 "ns", "sw";
                 "ns", "wn";
                 "ns", "we";
                 "ns", "ws";
                 "ns", "es";
                 "nw", "ew";
                 "nw", "sw";
                 "es", "sn";
                 "es", "sw";
                 "es", "we";
                 "es", "ws";
                 "ew", "sn";
                 "ew", "wn";
                 "ew", "sw";
                 "en", "sn";
                 "en", "wn";
                 "sw", "we";
                 "sw", "wn";
                 "sn", "we";
                 "sn", "wn";
                 "se", "we"];

% Directions of vehicles on crossroad
% 1 vehicle
%dirs = ["ew"];
% 2 vehicle
%dirs = ["ew","wn"];
% 3 vehicle
%dirs = ["ew","wn","nw"];
% 4 vehicle
dirs = ["ew","wn","nw","se"];
% 5 vehicle
%dirs = ["ew","wn","nw","se","es"];
% 6 vehicle
%dirs = ["ew","wn","nw","se","es","sw"];
% 7 vehicle - Takes around 3 minutes
%dirs = ["ew","wn","nw","se","es","sw","ns"];
% 8 vehicle - Takes around 30 mins
%dirs = ["ew","wn","nw","se","es","sw","ns","ws"];


% Generate a transition system for every vehicle
for i = 1:length(dirs)
    TSvehicles(i) = TSvehicle(dirs(i));
end

% Generate a transition system for the crossroad
TS = TScrossroad(TSvehicles);

% Generate the Safety Properties as a Büchi Automatas
for i = 1:size(crossingPaths,1)
    safetyProperties(i) = getSPcrossingPaths(crossingPaths(i,:));    
end


% Synthesize a model that does not contain any states with vehicles
% colliding on crossing paths
TS.synthesizeWithSPs(safetyProperties, crossingPaths);

% Plot the synthesized TS
TS.plot();
