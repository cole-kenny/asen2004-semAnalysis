function [isp] = ispCalc(time,data)

% Defining constants
mDot = 1;           % kg
g = 9.81;           % m/s^2

impulse = trapz(time,data);
isp = (impulse)/(mDot * g);
end