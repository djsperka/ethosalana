% load big mat file
Y=load('test.mat');
R=Y.output;

% list of subjects
s = LEth.bySubject(R);

% Get plot ready
figure;
tiledlayout(4,length(s.SubjID), 'TileIndexing', 'columnmajor');


for i=1:length(s.SubjID)
    fprintf('%d %s\n', i, s.SubjID{i});

    % correct trials for this subject, attend-in
    lSubjectCorrectDetectionAttendIn = s.lSubject(:,i) & LEth.completed(R) & LEth.correct(R) & LEth.attendIn(R) & R.StimChangeTF==1;
    lSubjectCorrectRejectionAttendIn = s.lSubject(:,i) & LEth.completed(R) & LEth.correct(R) & LEth.attendIn(R) & R.StimChangeTF==0;
    lSubjectCompletedAttendIn = s.lSubject(:,i) & LEth.completed(R) & LEth.attendIn(R);
    fprintf('Attend-in correct,incorrect,total %d,%d,%d\n', sum(lSubjectCorrectDetectionAttendIn), sum(lSubjectCorrectRejectionAttendIn), sum(lSubjectCompletedAttendIn));

    % correct trials for this subject, attend-out
    lSubjectCorrectDetectionAttendOut = s.lSubject(:,i) & LEth.completed(R) & LEth.correct(R) & LEth.attendOut(R) & R.StimChangeTF==1;
    lSubjectCorrectRejectionAttendOut = s.lSubject(:,i) & LEth.completed(R) & LEth.correct(R) & LEth.attendOut(R) & R.StimChangeTF==0;
    lSubjectCompletedAttendOut = s.lSubject(:,i) & LEth.completed(R) & LEth.attendOut(R);
    fprintf('Attend-Out correct,incorrect,total %d,%d,%d\n', sum(lSubjectCorrectDetectionAttendOut), sum(lSubjectCorrectRejectionAttendOut), sum(lSubjectCompletedAttendOut));

    nexttile();
    plotRTByTrialType(R(lSubjectCorrectDetectionAttendIn, :), title='CD, attend-in', type='bar');
    nexttile();
    plotRTByTrialType(R(lSubjectCorrectDetectionAttendOut, :), title='CD, attend-out', type='bar');
    nexttile();
    plotRTByTrialType(R(lSubjectCorrectRejectionAttendIn, :), title='CR, attend-in', type='boxchart');
    nexttile();
    plotRTByTrialType(R(lSubjectCorrectRejectionAttendOut, :), title='CR, attend-out', type='boxchart');
end