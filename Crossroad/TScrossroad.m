classdef TScrossroad < TransitionSystem
    %TSCROSSROAD Transition sytem of the whole crossroad including all
    %vehicles.
    %   Detailed explanation goes here
    
    methods
        function obj = TScrossroad(TSvehicles)
            %TSCROSSROAD Generate a crossroad transition system with
            %transition systems from all vehicles on crossroad.
            %   Detailed explanation goes here
            arguments
                TSvehicles                 (1,:) TSvehicle    % transition systems from all the vehicles on crossroad
            end
            
            % Parallelize all this vehicle transition systems to one crossroad
            % transition system
            TSp = TransitionSystem.parallelize(TSvehicles);
            % Construct transition system
            obj@TransitionSystem(TSp.states, TSp.actions, TSp.transitions, TSp.initialStates, TSp.atomicProps, TSp.labels);
        end
        
        function synthesizeWithSPs(obj, safetyProperties, crossingDirections)
            %SYNTHESISWITHSPS Synthesize with safety property to exclude
            %states that does not meet the safety property. The safety
            %property is generated from the crossing directions.
            arguments
                obj                 (1,1) TransitionSystem % the transition system to check and modify
                safetyProperties    (:,1) BuchiAutomata % the safety properties used to check the transition system
                crossingDirections  (:,2) string % contains string pairs that show crossing paths at crossroad 
                %(must be the same that are used for generation of the safety properties)
            end
            
            % Make a safety property for every crossing directions pair and
            % synthesize them with the transition system
            for i = 1:length(safetyProperties)

                % Synthesize only directions that affect the transition system
                if all(contains(crossingDirections(i,:), extractAfter(obj.atomicProps,1)))
                    % Verify the TS with BA
                    obj.synthesizeWithBA(safetyProperties(i));
                end
            end
            
        end
    end
    
    methods(Static)
        function verified = verifyModel(atInput, atPassing,crossingPaths)
            %VERIFYMODEL Verify the selected directions with model checking
            %   Detailed explanation goes here
            arguments
                atInput         (1,:) string % contains directions from vehicles at input nodes that want to pass the crossroad
                atPassing       (1,:) string % contains directions from vehicles passing the crossroad
                crossingPaths   (:,2) string % contains string pairs that show crossing paths at crossroad
            end
            
            if isempty(atInput) && isempty(atPassing)
                % no vehicle on crossroad
                verified = true;
                return;
            end
            % Get current state and directions from atInput and atPassing
            directions = strings(0,0);
            currentState = strings(1);
            if ~isempty(atInput)
                directions = atInput;
                currentState = join(repmat("i",1,length(atInput)),"");
            end
            if ~isempty(atPassing)
                directions(end+1:end+length(atPassing)) = atPassing;
                currentState = currentState + join(repmat("p",1,length(atPassing)),"");
            end
            
            % Generate a transition system for every vehicle
            for i = 1:length(directions)
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
            
            % check if state exists
            if any(currentState == TS.states)
                % get all actions that should be done
                currentActions = TS.actions(contains(TS.actions,directions(1,:)));
                % check all actions
                for i=1:length(currentActions)
                    if any(all([currentState currentActions(i)] == TS.transitions(:,[1 3]),2))
                        % action exists!! :)
                        % go to state corresponding to this action
                        currentState = TS.transitions(all([currentState currentActions(i)] == TS.transitions(:,[1 3]),2),2);
                    else
                        verified = false;
                        return
                    end
                end
                % all actions are possible
                verified = true;
            else
                verified = false;
            end  
            
        end
    end
end

