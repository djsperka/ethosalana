function  plotRTByTrialType(R, options)
%plotRTByTrialType For the trials given, plot reaction time by trial type.
%   Detailed explanation goes here

    arguments
        R table {mustBeEthosalResults},
        options.axes (1,1) {mustBeAxesOrZero} = 0,
        options.title {mustBeNonzeroLengthText} = 'Reaction time vs trial type',
    end


    clBySciTrialType = LEth.bySciTrialType(R);
    rxTimes = cellfun(@(x) R.tReaction(x), clBySciTrialType, UniformOutput=false);

    rxTimesMean = cellfun(@(x) mean(x, 'omitmissing'), rxTimes)  
    if isa(options.axes, 'matlab.graphics.axis.Axes')
        axes(options.axes);
    end
    bar(categorical(LEth.sciTrialTypes()), rxTimesMean);
    title(options.title);
    xlabel('Trial Type');
    ylabel('Reaction time (s)');
    ylim([0, 1]);
    

end

function mustBeAxesOrZero(x)
    if ~isa(x, 'matlab.graphics.axis.Axes') && ~(isscalar(x) && isnumeric(x))
        error('axes arg must be ''matlab.graphics.axis.Axes'' object.');
    end
end
