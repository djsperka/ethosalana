classdef LEth
    %LEth collection of static methods for getting logical indices used in
    %ethological salience expts. 
    %   Pass results table from which the index should be taken. 

    % properties
    %     Property1
    % end

    methods(Static)

        function lCompleted = completed(R)
            %lCompleted Get logical index for all completed trials.
            %   Completed means Started, and a response was recorded.
            lCompleted = R.Started & R.tResp>0 & R.iResp>-1;
        end

        function lCorrect = correct(R)
            %lCorrect Get logical index for all correct trials.
            %   Completed means Started, and a response was recorded.
            lCorrect = LEth.completed(R) & R.StimChangeTF==R.iResp;
        end

        function lAttendIn = attendIn(R)
            
            lAttendIn = ismember(R.CueSide, [1,2]) & R.CueSide==R.StimTestType;
        end

        function lAttendOut = attendOut(R)

            lAttendOut = ismember(R.CueSide, [1,2]) & R.CueSide~=R.StimTestType;
        end

        function subj = bySubject(R)
            subjects = unique(R.SubjID);
            z=cellfun(@(x) strcmp(R.SubjID, {x}), subjects', 'UniformOutput', false);
            subj.lSubject = (z{:});
            subj.subjID = subjects';
        end

        function ttypes = sciTrialTypes()
            ttypes = {'HH', 'HL', 'LH', 'LL'};
        end

        function clBySciTrialType = bySciTrialType(R)
            clBySciTrialType = cellfun(@(x) strcmp(R.sciTrialType, {x}), LEth.sciTrialTypes(), 'UniformOutput', false);
        end


    end
end