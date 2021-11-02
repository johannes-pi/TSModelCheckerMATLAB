
% Directions of vehicles
% 1 vehicle
%dirs = ["ew"];
% 2 vehicle
dirs = ["ew","wn"];
% 3 vehicle
%dirs = ["ew","wn","nw"];
% 4 vehicle
%dirs = ["ew","wn","nw","se"];

% Generate Transition System for the crossroad
TS = TScrossroad(dirs);

% Plot the crossroad TS
%TS.plotTS();

% array with list of two paths that are crossing on the crossroad     
             
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

% Generate a  Transition System that does not contain crossing paths
TS.synthesizeWithSPs(crossingPaths);
% Plot the verified TS
TS.plotTS();
