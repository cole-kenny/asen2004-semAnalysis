function [n950,n975,n990,answerMatrix,semTheoMat] = semAnalysis(ispData)

%% Flip the order (for testing)
%ispData = flip(ispData);

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
    ispDataSub = ispData(1:i);
    m(i) = mean(ispDataSub);
    s(i) = std(ispDataSub);
    sem(i) = s(i) / sqrt(i);
end

trials = 1:length(sem);

% Removing the first 2 calculated point
    % Since mean, std, and sem are only valid for n > 2
m(1:2) = [];
s(1:2) = [];
sem(1:2) = [];
trials(1:2) = [];

% Plotting running standard deviation
% figure(1)
% plot(trials,s,'o')
% title('Standard Deviation vs. Sample Number')
% xlabel('Number of Samples')
% ylabel('Running Standard Deviation')

% Plotting running SEM
% figure(2)
% plot(trials,sem,'o')
% title('SEM vs. Sample Number')
% xlabel('Number of Samples')
% ylabel('Running SEM')

%% Finding the required trials for defined confidence intervals

% 1.96 x SEM < 0.05*mean -> 95% confidence interval
% 2.24 x SEM < 0.025*mean -> 97.5%
% 2.58 x SEM < 0.01*mean -> 99%

% Initialize n values
n950 = -1;
n975 = -1;
n990 = -1;

% 95% confidence
for i = 2:length(sem)
    semRange = 1.96 * sem(i);
    meanRange = (0.05*m(i));
    if semRange < meanRange
        n950 = i + 2;
        break;
    end
end

% 97.5% confidence
for i = 2:length(sem)
    semRange = 2.24 * sem(i);
    meanRange = (0.025*m(i));
    if semRange < meanRange
        n975 = i + 2;
        break;
    end
end

% 99% confidence
for i = 2:length(sem)
    semRange = 2.58 * sem(i);
    meanRange = (0.01*m(i));
    if semRange < meanRange
        n990 = i + 2;
        break;
    end
end

% Calculating now many trials are necessary to get to 99% confidence
% Assumes mean and std remain the same...
sTheo = s(end);
semTheo = sem(end);
n = trials(end) + 1;
while 2.58 * semTheo > (0.01*m(end))
    semTheo = sTheo / sqrt(n);
    semTheoMat(n) = semTheo;
    n = n+1;
    sem990 = semTheo;
end
% Setting the required n value to the calculated theoretical n
n990 = n;

%% Trying to use polyfit to fit a line to the SEM data
% p = polyfit(trials,sem,5);
% 
% figure
% plot(trials,sem)
% hold on
% trialsPoly = [1:50];
% semPoly = polyval(p,trialsPoly);
% plot(trialsPoly,semPoly)

%% Appending zeros so the matricies are the same length
% m = [0,0,m];
% s = [0,0,s];
% sem = [0,0,sem];
% trials = [0,0,trials];
ispData(1:2) = [];

answerMatrix = [trials;ispData;m;s;sem];

end