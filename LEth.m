classdef LEth
    %LEth collection of static methods for getting logical indices used in
    %ethological salience expts. 
    %   Pass results table from which the index should be taken. 

    % properties
    %     Property1
    % end

    methods(Static)

        function lCompleted = completed(R)
        %Completed Get logical index for all completed trials in R.
        %   Completed means Started, and a response was recorded.
            lCompleted = R.Started & R.tResp>0 & R.iResp>-1;
        end

        function lCorrect = correct(R)
            %correct(R) Get logical index for all correct trials in R.
            %   Correct means completed AND the response is correct.
            lCorrect = LEth.completed(R) & R.StimChangeTF==R.iResp;
        end

        function lAttendIn = attendIn(R)
        % attendIn(R) Get logical index that identifies attend-in trials in R. 
        %  Attend-in trials are those where the attended-side is also the
        %  one that is tested. (The test may or may NOT be a change/flip)
            lAttendIn = ismember(R.CueSide, [1,2]) & R.CueSide==R.StimTestType;
        end

        function lAttendOut = attendOut(R)
        % attendOut(R) Get logical index that identifies attend-out trials in R. 
        %  Attend-out trials are those where the attended-side IS NOT the
        %  side that is tested. (The test may or may NOT be a change/flip)
            lAttendOut = ismember(R.CueSide, [1,2]) & R.CueSide~=R.StimTestType;
        end

        function subj = bySubject(R)
        % bySubject(R) Finds unique subject IDs, and returns logical index
        % for each. 
        %   Returns a struct with two fields: 'SubjID' is a cell array of
        %   the subject IDs, and 'lSubject' is a logical matrix, each
        %   column of which is a logical array that identifies the trials
        %   for the corresponding subject name in SubjID.
            subjects = unique(R.SubjID);
            z=cellfun(@(x) strcmp(R.SubjID, {x}), subjects', 'UniformOutput', false);
            subj.lSubject = horzcat(z{:});
            subj.SubjID = subjects';
        end

        function ttypes = sciTrialTypes()
            ttypes = {'HH', 'HL', 'LH', 'LL'};
        end

        function clBySciTrialType = bySciTrialType(R)
            clBySciTrialType = cellfun(@(x) strcmp(R.sciTrialType, {x}), LEth.sciTrialTypes(), 'UniformOutput', false);
        end


    end
end