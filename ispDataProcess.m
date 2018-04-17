function [time,data] = ispDataProcess(filename)

% Sampling frequency
freq = 1652;        % Hz

%% Loading the data from the text file
dataRaw = load(filename);
data = convforce(dataRaw(:,3),'lbf','N');
% Calculating the total test time
lengthData = length(data);
testTime = (1/freq)*lengthData;
time = linspace(0,testTime,lengthData);

% Plotting the raw data
% figure(1)
% plot(time,data)

%% Cleaning up the data so it only includes the impulse
% Starting from the front for the starting point
for i = 1:lengthData
    if data(i) - (data(i+1)) > 2        %0.1
        first = data(i);
        firstT = time(i);
        break;
    end
end
% Starting from the back for the ending point
for j = lengthData:-1:1
    if data(j) - (data(j-1)) > 0.7         % j-10; 5
        last = data(j);
        lastT = time(j);
        break;
    end
end

% hold on
% plot(firstT,first,'ko')
% plot(lastT,last,'ko')
% title('Raw Data with Impulse Start and End Points')

% Seperating the impulse from the data
data = data(i:j);
time = time(i:j);
% Plotting just the impluse
% figure(2)
% plot(time,data)

%% Drawing the lower limit line (lll)
lengthData = length(data);
lll = linspace(data(1),data(end),lengthData);
% hold on
% figure(2)
% plot(time,lll,'b--')
% title('Processed Data for the Lower Limit Line')

%% Making anything below the lll 'positive'
for i = 1:lengthData
    if data(i) < lll(i)
        diff = lll(i) - data(i);
        data(i) = data(i) + (2*diff);
    end
end

% figure(3)
% hold on
% plot(time,data)
% plot(time,lll,'b--')
% title('Making Everything ''Positive''')

%% Re-Zeroing the bottom axis
for i = 1:lengthData
    data(i) = data(i) + abs(lll(i));
end

% figure(4)
% plot(time,data)
% title('Modified Data to ''Flatten'' the Lower Axis')

end