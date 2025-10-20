function [FileKeys] = getBalancedKeysThisBlock(trials, rangeToUse)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

lBalIndex = trials.ImagePairIndex>=rangeToUse(1) & trials.ImagePairIndex<=rangeToUse(2);

FileKeys = unique(trials.File1Key(lBalIndex));

end