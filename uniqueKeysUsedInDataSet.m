% should have Y (input file with blocksets) in workspace
% Will gather the filekeys used for trials with ImagePairIndex in the
% lowRange (inclusive) and otherRange. Results are cell arrays 'allLow' and 
% 'allOther' with unique FileKeys (does NOT include folder key, so no 
% salience/type specific info)


lowRange=[1,20];
otherRange=[21,50];

allLow = {};
allOther = {};
for i=1:length(Y.blocks)
    A=getBalancedKeysThisBlock(Y.blocks{i}, lowRange);
    allLow = vertcat(allLow, A);
    B=getBalancedKeysThisBlock(Y.blocks{i}, otherRange);
    allOther = vertcat(allOther, B);
end

allLow = unique(allLow);
allOther = unique(allOther);