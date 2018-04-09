function [n950,n975,n990,answerMatrix] = semAnalysis(ispData)

%% Throw out really bad data
i = 1;
while i <= length(ispData)
    if ispData(i) > 2.5 || ispData(i) < 0.75
        ispData(i) = [];
    end
    i = i+1;
end

%% Start the actual calculations
s = zeros(1,length(ispData));
m = s;
sem = s;
for i = 1:length(ispData)
    s(i) = std(ispData(1:i));
    m(i) = mean(ispData(1:i));
    sem(i) = s(i) / sqrt(i);
end

% Plotting running standard deviation
trials = 1:length(ispData);
figure(1)
plot(trials,s)
title('Standard Deviation vs. Sample Number')
xlabel('Number of Samples')
ylabel('Running Standard Deviation')

% Plotting running SEM
figure(2)
plot(trials,sem)
title('SEM vs. Sample Number')
xlabel('Number of Samples')
ylabel('Running SEM')

%% Finding the required trials for defined confidence intervals

% 1.96 x SEM < 0.05*mean -> 95% confidence interval
% 2.24 x SEM < 0.025*mean -> 97.5%
% 2.58 x SEM < 0.01*mean -> 99%

% 95% confidence
for i = 2:length(sem)
    semRange = 1.96 * sem(i);
    meanRange = (0.05*m(i));
    if semRange < meanRange
        n950 = i;
        break;
    end
end

% 97.5% confidence
for i = 2:length(sem)
    semRange = 2.24 * sem(i);
    meanRange = (0.025*m(i));
    if semRange < meanRange
        n975 = i;
        break;
    end
end

% 99% confidence
for i = 2:length(sem)
    semRange = 2.58 * sem(i);
    meanRange = (0.01*m(i));
    if semRange < meanRange
        n990 = i;
        break;
    end
end

answerMatrix = [trials;ispData;m;s;sem];

end