% load big mat file
Y=load('test.mat');
R=Y.output;

% We want the following trials:
% Only images 1-20
% If HH or HL: Subject must have had CORRECT responses for both HH and HL images
% IF LH or LL: Subject must have had CORRECT responses for both LL and LH images
l20 = R.ImagePairIndex>0 & R.ImagePairIndex<21;

% list of subjects
s = LEth.bySubject(R);

% Get plot ready
%figure;
%tiledlayout(4,length(s.SubjID), 'TileIndexing', 'columnmajor');


for i=1:length(s.SubjID)

    % Get set of all completed trials for this subject, and check that it
    % is a complete set.
    Rsub = R(s.lSubject(:,i) & LEth.completed(R), :);
    if LEth.isFullSetGD(Rsub, 20, 60)
        fprintf('%s OK\n', s.SubjID{i});
    else
        fprintf('%s NOT OK\n', s.SubjID{i});
    end        

    % Sort by imagePairIndex, CueSide, FolderKeyColumn, Folder1KeyRow,
    % Folder2KeyRow, StimTestType, StimChangeTF
    % Pairs of trials that are identical in all ways EXCEPT FOR
    % CueSide are adjacent. Since we KNOW that there is a full set of
    % trials, we can use this to test for when both of these trials are
    % correct.
    Rsort = sortrows(Rsub, [6, 25, 7:11]);
    lCorrect=LEth.correct(Rsort);
    lCorrectReshaped = reshape(lCorrect,[2,length(lCorrect)/2])';
    iBoth=find(lCorrectReshaped(:,1)&lCorrectReshaped(:,2));

    % Form a logical array to capture only those trials where both are
    % correct.
    lCorrectBoth = false(size(lCorrect));
    lCorrectBoth((iBoth-1)*2+1) = true;
    lCorrectBoth(iBoth*2) = true;
    Rboth = Rsort(lCorrectBoth,:);

    % Check that all are correct...
    assert(height(Rboth) == sum(LEth.correct(Rboth)));
    



    %% plot_all_subjects_wilcoxon
    % The data for these plots is taken from the _balanced_ portion of the 

        % if (targetrows["sciTrialType"] == "HH").all():
        % select5 = allDt[
        %     (allDt["Prefix"]==tsubject)&
        %     (allDt["ImagePairIndex"] == timagepair) &
        %     (allDt["Type"] == ttype) &
        %     (allDt["StimTestType"] == tstimtesttype) &
        %     (allDt["StimChangeType"] == tstimchangetype) &
        %     (allDt["sciTrialType"] == "HL")
        % ]

    % Select trials for this subject. 
    % Double-check that we have a complete set (quit if not)



    % 
    % % complete/correct responses for ind 1-20, this subject, HH or HL
    % lcompleted20 = LEth.completed(R) & s.lSubject(:,i) & l20 & (LEth.bySciTrialType(R,'HH') | LEth.bySciTrialType(R,'HL'));
    % lcorrect20 = LEth.correct(R) & s.lSubject(:,i) & l20 & (LEth.bySciTrialType(R,'HH') | LEth.bySciTrialType(R,'HL'));
    % Rsub = sortrows(R(lcompleted20,:), [2, 6, 25, 10, 11, 24]);
    % Rsub(:,["ImagePairIndex", "CueSide", "StimTestType", "sciTrialType", "StimChangeTF", "iResp"])
    % 
    % fprintf('%d %s %d\n', i, s.SubjID{i}, height(Rsub));
    % 
    % % correct trials for this subject, attend-in
    % lSubjectCorrectDetectionAttendIn = s.lSubject(:,i) & LEth.completed(R) & LEth.correct(R) & LEth.attendIn(R) & R.StimChangeTF==1;
    % lSubjectCorrectRejectionAttendIn = s.lSubject(:,i) & LEth.completed(R) & LEth.correct(R) & LEth.attendIn(R) & R.StimChangeTF==0;
    % % false alarms, attend-in
    % lSubjectCompletedAttendIn = s.lSubject(:,i) & LEth.completed(R) & LEth.attendIn(R);
    % fprintf('Attend-in correct,incorrect,total %d,%d,%d\n', sum(lSubjectCorrectDetectionAttendIn), sum(lSubjectCorrectRejectionAttendIn), sum(lSubjectCompletedAttendIn));
    % 
    % % correct trials for this subject, attend-out
    % lSubjectCorrectDetectionAttendOut = s.lSubject(:,i) & LEth.completed(R) & LEth.correct(R) & LEth.attendOut(R) & R.StimChangeTF==1;
    % lSubjectCorrectRejectionAttendOut = s.lSubject(:,i) & LEth.completed(R) & LEth.correct(R) & LEth.attendOut(R) & R.StimChangeTF==0;
    % lSubjectCompletedAttendOut = s.lSubject(:,i) & LEth.completed(R) & LEth.attendOut(R);
    % fprintf('Attend-Out correct,incorrect,total %d,%d,%d\n', sum(lSubjectCorrectDetectionAttendOut), sum(lSubjectCorrectRejectionAttendOut), sum(lSubjectCompletedAttendOut));

    % nexttile();
    % plotRTByTrialType(R(lSubjectCorrectDetectionAttendIn, :), title='CD, attend-in', type='bar');
    % nexttile();
    % plotRTByTrialType(R(lSubjectCorrectDetectionAttendOut, :), title='CD, attend-out', type='bar');
    % nexttile();
    % plotRTByTrialType(R(lSubjectCorrectRejectionAttendIn, :), title='CR, attend-in', type='boxchart');
    % nexttile();
    % plotRTByTrialType(R(lSubjectCorrectRejectionAttendOut, :), title='CR, attend-out', type='boxchart');
end