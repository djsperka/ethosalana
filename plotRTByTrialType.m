function  plotRTByTrialType(R, options)
%plotRTByTrialType For the trials given, plot reaction time by trial type.
%   Detailed explanation goes here

    arguments
        R table {mustBeEthosalResults},
        options.axes (1,1) {mustBeAxesOrZero} = 0,
        options.title {mustBeNonzeroLengthText} = 'Reaction time vs trial type',
        options.type {mustBeNonzeroLengthText} = 'bar'
    end


    clBySciTrialType = LEth.bySciTrialType(R);
    rxTimes = cellfun(@(x) R.tReaction(x), clBySciTrialType, UniformOutput=false);

    if isa(options.axes, 'matlab.graphics.axis.Axes')
        axes(options.axes);
    end
    if strcmp(options.type, 'bar')
        rxTimesMean = cellfun(@(x) mean(x, 'omitmissing'), rxTimes);
        bar(categorical(LEth.sciTrialTypes()), rxTimesMean);
        title(options.title);
        xlabel('Trial Type');
        ylabel('Reaction time (s)');
        ylim([0, 2]);
    elseif strcmp(options.type, 'boxchart')
        boxchart(categorical(R.sciTrialType, LEth.sciTrialTypes), R.tReaction)
        title(options.title);
        xlabel('Trial Type');
        ylabel('Reaction time (s)');
        ylim([0, 2]);
    end

end

function mustBeAxesOrZero(x)
    if ~isa(x, 'matlab.graphics.axis.Axes') && ~(isscalar(x) && isnumeric(x))
        error('axes arg must be ''matlab.graphics.axis.Axes'' object.');
    end
end
