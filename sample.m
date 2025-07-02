% load big file
Y=load('/home/dan/work/cclab/ethosal/ana/test.mat');
R = Y.output;

% logical indices for all completed trials and all correct trials
lCompleted = R.Started & R.tResp>0 & R.iResp>-1;
lCorrect  = lCompleted & R.StimChangeTF==R.iResp;

% logical indices for each block number
% lBlockNumberInd is the same HEIGHT as the table. Each column is a logical
% index for that particular block number: lBlockNumberInd(:,1) corresponds to all
% trials from block 1
%
% Block numbers are useful here for counting trials for completeness. For
% analysis we'd most likely ignore block numbers entirely.
blockNumbers=unique(R.BlockNum);
lBlockNumberInd = R.BlockNum==blockNumbers';

% attention - attend-in and attend-out
lAttendIn = ismember(R.CueSide, [1,2]) & R.CueSide==R.StimTestType;
lAttendOut = ismember(R.CueSide, [1,2]) & R.CueSide~=R.StimTestType;

% left/right cue - use this for counting trials by block below.
lCueLeft = R.CueSide==1;
lCueRight = R.CueSide==2;

% loop over unique subject names.
subjects = unique(R.SubjID);
fprintf('There are %d subjects in the data set\n', length(subjects));
fprintf(' %s\n', subjects{:});
for i=1:length(subjects)

    % logindex for all this subject's trials
    % Each string in the SubjID column is stored as a cell (which contains
    % a string). That means this fails because you can't use "==" on cells.
    %lSubject = R.SubjID==subjects{i};
    % Instead, this works
    lSubject = strcmp(R.SubjID, subjects{i});

    % count complete trials
    nCompleted = sum(lSubject&lCompleted);

    % Count complete trials per block
    % blockNumbers should be 1:8 for this data set. It comes as a column
    % vector below. When its used for the log index, we turn it on its
    % side. The log index lBlockNumberInd has the same height as the table
    % 'R', and each column identifies the trials from that block for this
    % subject.
    nCompletedByBlock = sum(lSubject & lCompleted & lBlockNumberInd);
    nCompletedByBlockCueLeft = sum(lSubject & lCompleted & lCueLeft & lBlockNumberInd);
    nCompletedByBlockCueRight = sum(lSubject & lCompleted & lCueRight & lBlockNumberInd);

    nAttendIn = sum(lSubject & lCompleted & lAttendIn);
    nAttendOut = sum(lSubject & lCompleted & lAttendOut);
    %fprintf('in %d out %d\n', nAttendIn, nAttendOut);

    % Did subject complete all trials?
    % Expecting 1600 total, 100 per block. Attend-In=1280, attend-out=320
    if nCompleted ~= 1600 || ~all(nCompletedByBlockCueLeft==100 & nCompletedByBlockCueRight==100) || nAttendIn~= 1280 || nAttendOut ~= 320
        fprintf('Subject: %s  MISSING TRIALS: \n # completed: %d (expecting 1600), by block: \n', subjects{i}, nCompleted);
        fprintf([' Left : ', repmat('%d ',1,length(nCompletedByBlockCueLeft)), '\n'], nCompletedByBlockCueLeft);
        fprintf([' Right: ', repmat('%d ',1,length(nCompletedByBlockCueRight)), '\n'], nCompletedByBlockCueRight);
        fprintf('Attend-in: %d Attend-out: %d\n', nAttendIn, nAttendOut);
    else
        fprintf('Subject: %s OK\n', subjects{i});
    end    


end

