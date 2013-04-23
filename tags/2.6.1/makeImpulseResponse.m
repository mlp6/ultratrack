function [impulseResponse t] = makeImpulseResponse(fractionalBandwidth, centerFreq, Fs)
% function impulseResponse = makeImpulseResponse(fractionalBandwidth, centerFreq, Fs)
% 
% Inputs: fractionalBandwidth - the bandwidth of the piston (e.g. 0.7 for
%                               70%)
%         centerFreq - center frequency of the piston in Hz
%         Fs - sampling frequency in Hz

tc = gauspuls('cutoff',centerFreq,fractionalBandwidth,-6,-40);
t = -tc:1/Fs:tc;
impulseResponse =gauspuls(t,centerFreq,fractionalBandwidth);