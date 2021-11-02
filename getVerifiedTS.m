function transitionSystem = getVerifiedTS(transitionSystem, crossingDirections)
%CHECKALLSP Check all safety properties at transition system and remove
%invalid states.
%   Detailed explanation goes here
arguments
    transitionSystem    (1,1) TransitionSystem % the transition system to check and modify
    crossingDirections  (:,2) string % contains string pairs that show crossing paths at crossroad
end

% Check which parts of TS are still valid with A
for i = 1:size(crossingDirections,1)
    % Check only if all directions are part of the transition system
    if all(contains(crossingDirections(i,:), extractAfter(transitionSystem.atomicProps,1)))
        % Generate the Safety Property as a Büchi Automata
        safetyProperty = SafetyProperty(crossingDirections(i,:));
        % Verify the TS with BA
        transitionSystem.synthesizeWithBA(safetyProperty);
    end
end

end

