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
        % bySciTrialType(R) Returns the sci trial types.
            ttypes = {'HH', 'HL', 'LH', 'LL'};
        end

        function lBySciTrialType = bySciTrialType(R,varargin)
        % bySciTrialType(R) Returns logical array(s) corresponding to sci
        % trial types.
        %  If a results table alone is passed, then a cell array is
        %  returned. Each element of the array is itself a logical array
        %  corresponding to the sciTrialTypes retuirned from
        %  LEth.sciTrialTypes().
        %  If a results table AND a trial type string (e.g. 'HH'), then a
        %  single logical array is returned. 
            if nargin==1
                lBySciTrialType = cellfun(@(x) strcmp(R.sciTrialType, {x}), LEth.sciTrialTypes(), 'UniformOutput', false);
            else
                lBySciTrialType = strcmp(R.sciTrialType, varargin{1});
            end
        end

        function lHHHL = HHHL(R)
        % HHHL(R) Returns a logical array corresponding to trials which are
        %  'HH' or 'HL'. This is equivalent to asking for sciType HH and HL.
            lHHHL = (R.StimTestType==1 & R.Folder1KeyRow==1) | (R.StimTestType==2 & R.Folder2KeyRow==1);
        end

        function lLLLH = LLLH(R)
        % LLLH(R) Returns a logical array corresponding to trials which are
        %  'LL' or 'LH'. This is equivalent to asking for sciType LL and LH.
            lLLLH = (R.StimTestType==1 & R.Folder1KeyRow==2) | (R.StimTestType==2 & R.Folder2KeyRow==2);
        end

        function tf = isFullSetGD(R, nBoth, nGD, varargin)
        % isFullSetGD checks trials given and verifies that it is a
        %  complete set of goal-directed trials generated using the number of
        %  both,left-only, and right-only image pairs. Pass a set of
        %  completed() trials here! 

            if nargin>3
                bVerbose = varargin{1};
            else
                bVerbose = false;
            end
            
            % count by (ImagePairIndex,CueSide) pairs
            %
            % 'both'-type images will have 16 trials for each CueSide
            % 'GD' (goal-directed) images will have just 8 trials for each
            % CueSide.

            [counts, groups, ~] = groupcounts(horzcat(R.ImagePairIndex, R.CueSide));

            % groups will be a 1x2 cell
            % groups{1} and groups{2} are lists of ImagePairIndex and
            % CueSide, respectively, that correspond to 'counts'.
            % Each time the count is 16, the ImagePairIndex should appear
            % twice (for cases CueSide = 1 and 2)
            tf = all(groupcounts(groups{1}(counts==16)==2));
            if ~tf
                warning('Expecting 16 trials for each CueSide for neutral images');
                return;
            end
            tf = all(groupcounts(groups{1}(counts==8)==2));
            if ~tf
                warning('Expecting 8 trials for each CueSide for GD images');
                return;
            end

            % Count image pair indices for each CueSide
            tf = all(sum(counts==16 & groups{2}==[1,2])==nBoth);
            if ~tf
                warning('Expecting %d neutral trials for each CueSide', nBoth);
                return;
            end

            tf = all(sum(counts==8 & groups{2}==[1,2])==nGD);
            if ~tf
                warning('Expecting %d goal-directed trials for each CueSide', nGD);
                return;
            end

        end
    end
end