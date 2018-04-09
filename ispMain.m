% Main scriptfor funning the ISP Standard Error Analysis

clear; close all; clc;

numGroups = 11;
ispData = zeros(1,numGroups*3);

labTimes = ['08am';'10am';'01pm'];
filename1 = 'files/Group';
underscore = '_';
leadingZero = '0';

datasetCounter = 0;

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
    end
end

% SEM = s/(sqrt(n)) where s is std.dev. and n is trials

% 1.96 x SEM -> 95% confidence interval
% 2.24 x SEM -> 97.5%
% 2.58 x SEM -> 99%