% Main script for funning the ISP Standard Error Analysis

clear; close all; clc;

numGroups = 11;
ispData = zeros(1,numGroups*3);

labTimes = ['08am';'10am';'01pm'];
filename1 = 'files/Group';
underscore = '_';
leadingZero = '0';

datasetCounter = 0;

loadingBar = waitbar(0,'Calculating...');

for i = 1:numGroups
    for j = 1:3
        % Setting up a modular filename system
        groupNumber = num2str(i);
        % Adding a leading zero if the group number is only 1 character
        if length(groupNumber) == 1
            groupCode = strcat(leadingZero,groupNumber);
        else
            groupCode = groupNumber;
        end
        % Iterating through the time slots
        timeCode = labTimes(j,:);
        filename2 = '_statictest1.txt';
        % Putting the whole filename together
        filename = strcat(filename1,groupCode,underscore,timeCode,filename2);
        datasetCounter = datasetCounter + 1;

        [time,data] = ispDataProcess(filename);
        ispData(datasetCounter) = ispCalc(time,data);
        
        waitbar((datasetCounter/(numGroups*3)));
    end
end
close(loadingBar);

% Doing the SEM analysis
[n950,n975,n990,answerMatrix,semTheoMat] = semAnalysis(ispData);

fprintf('Trials required for 95%% confidence: %i\n',n950);
fprintf('Trials required for 97.5%% confidence: %i\n',n975);
fprintf('Trials required for 99%% confidence: %i\n',n990);

%% Figuring out the running mean bounds
trials = answerMatrix(1,:);
isp = answerMatrix(2,:);
m = answerMatrix(3,:);
    m(1) = isp(1);
    m(2) = isp(2);
s = answerMatrix(4,:);
sem = answerMatrix(5,:);
err950 = (0.05.*m + m) - (m - 0.05.*m);
err975 = (0.025.*m + m) - (m - 0.025.*m);
err990 = (0.01.*m + m) - (m - 0.01.*m);

%% Plotting ALL the things!!
% Sample thrust curve
[time,data] = ispDataProcess('files/Group05_08am_statictest1.txt');
figure
plot(time,data)
title('Sample Thrust Plot')
xlabel('Time (s)')
ylabel('Thrust (lbs)')
% Mean with 95% confidence
figure
subplot(1,3,1)
errorbar(trials,m,err950)
hold on
plot(trials,isp)
title('95% Confidence in the Mean')
xlabel('Number of Trials')
ylabel('Calculated Isp')
legend('Mean Isp +/- 5%','Calculated Isp')
% Mean with 97.5% confidence
subplot(1,3,2)
errorbar(trials,m,err975)
hold on
plot(trials,isp)
title('97.5% Confidence in the Mean')
xlabel('Number of Trials')
ylabel('Calculated Isp')
legend('Mean Isp +/- 2.5%','Calculated Isp')
% Mean with 99% confidence
subplot(1,3,3)
errorbar(trials,m,err990)
hold on
plot(trials,isp)
title('99% Confidence in the Mean')
xlabel('Number of Trials')
ylabel('Calculated Isp')
legend('Mean Isp +/- 1%','Calculated Isp')
% SEM v. Trials
figure
plot(trials,sem,'o-')
title('Standard Error vs. Number of Trails')
xlabel('Trail Number')
ylabel('Standard Error of the Mean')
% Plotting theoretical SEM if there were more trials
hold on
nTheo = 1:length(semTheoMat);
nTheo(1:trials(end)) = [];
semTheoMat(1:trials(end)) = [];
plot(nTheo,semTheoMat,'o--')
legend('Calculated SEM','Theoretical SEM')