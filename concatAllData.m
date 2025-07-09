% Concatenate all tables found in the 'folder', defined below. Creates a
% single table in the workspace named 'output'. Any existing value of
% 'output' is overwritten.
%
% Load mat files from a single folder. The files are assumed to be results 
% from ethosal, named with this scheme:
%
%   date_subjID_filebase_blkN
%
%   1 date in format YYYY-mm-dd-HHMM
%   2 subjID is the subjectID entered at time of data collection
%   3 filebase is the basename of the input data file (the mat file)
%   4 N is the block number
%
% Add columns to each results table to denote the subject ID, input file
% base, block number, and the date/time data was collected. 
% Also compute the reaction time (NaN where there was none) and add a
% column for it.
% Column names added (and type):
% DateTime (str)
% SubjID (str)
% InfileBase (str)
% BlockNum (numeric)
% tReaction (numeric, NaN if no response for this trial)


% Folder with all the mat files.
folder='/home/dan/work/cclab/ethdata/EthologicalSalience/Ethdata/Interaction';

% 'list' will be a struct representing all '*.mat' files in 'folder'. Elements
% of struct: name, folder, date, bytes, isdir, datenum. All useful, but
% here we only use folder and name to load each file - we can use 
% 'fullfile(list(i).folder, list(i).name)' to get us the filename for
% loading.
list = dir(fullfile(folder, '*.mat'));

% output initially empty, vertcat onto this.
output = [];

% load each file, append extra columns, vertcat to output
for i=1:length(list)

    Y=load(fullfile(list(i).folder, list(i).name));
    results = Y.results;


    % parse filename for parts
    % regex relies on the filename format:  
    % 
    % date_subjID_filebase_blkN
    %
    % 1 date in format YYYY-mm-dd-HHMM
    % 2 subjID is the subjectID entered at time of data collection
    % 3 filebase is the basename of the input data file (the mat file)
    % 4 N is the block number
    % 

    r=regexp(list(i).name, '^(\d{4}-\d{2}-\d{2}-\d{4})_([^_]+)_(.*)_blk(\d+)\.mat', 'tokens');

    % 'tokens' gets us the subgroups, returned as a cell array. 
    % A subgroup is the part of the match contained in parentheses. The
    % subgroups are, in order, date/time (e.g. 2025-07-02-1422), month,
    % day, time (e.g. 1425).
    %
    % There should only be a single match, and we expect each filename to
    % match!
    % The first match (entire pattern) is r{1}{1}. The subgroups follow:
    % the first subgroup (the part in the first pair of parentheses)
    fprintf('%d: %s %s %s\n', i, r{1}{2}, r{1}{3}, r{1}{4});

    % make a column vector, same height as the results table we just
    % loaded, with the values we just extracted from the filename.
    % DateTime, SubjID, InfileBase, BlockNum (numeric), reaction time (NaN
    % if no response for this trial)
    clear('DateTime', 'SubjID', 'InfileBase', 'BlockNum', 'tReaction');
    DateTime(1:height(results), 1) = {r{1}(1)};
    SubjID(1:height(results), 1) = repmat(r{1}(2), height(results), 1);     %{r{1}(2)};
    InfileBase(1:height(results), 1) = {r{1}(3)};
    BlockNum(1:height(results), 1) = str2num(r{1}{4});
    tReaction(1:height(results), 1) = results.tResp - results.tBon;
    tReaction(results.tResp<0) = NaN;

    Z = addvars(results, DateTime, SubjID, InfileBase, BlockNum, tReaction, 'Before','ImagePairIndex');
    output = [output; Z];
end

% Now save the table in a file. When loading the file, it will contain a
% single thing - the table called 'output'.
[fname, loc] = uiputfile('','Save filename');
fprintf('saving %s\n', fullfile(loc, fname));
save(fullfile(loc, fname), "output", "-mat");