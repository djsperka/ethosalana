function mustBeEthosalResults(R)
%mustBeEthosalResults Validation function for ethosal results. 
%   Use this in an arguments block to test that an input is a table of
%   results from ethosal.
    if ~isa(R, 'table')
        error('Input must be a table');
    else
        expectedFieldnames = { ...
            'tReaction', ...
            'ImagePairIndex',...
            'FolderKeyColumn',...
            'Folder1KeyRow',...
            'Folder2KeyRow',...
            'StimTestType',...
            'StimChangeTF',...
            'sciTrialType',...
            'CueSide',...
            'Started',...
            'trialIndex',...
            'tAon',...
            'tAoff',...
            'tBon',...
            'tBoff',...
            'tResp',...
            'iResp'...
        };
        if ~all(ismember(expectedFieldnames, fieldnames(R)))
            error('Missing expected fieldnames - is this an output table?');
        end
end