function [impulseResponse t] = makeImpulseResponse(fractionalBandwidth, centerFreq, Fs)
% function impulseResponse = makeImpulseResponse(fractionalBandwidth, centerFreq, Fs)
% 
% Inputs: fractionalBandwidth - the bandwidth of the piston (e.g. 0.7 for
%                               70%)
%         centerFreq - center frequency of the piston in Hz
%         Fs - sampling frequency in Hz

tc = gauspuls('cutoff',centerFreq,fractionalBandwidth,-6,-40);
t = -tc:1/Fs:tc;
% I am concerened that using YI might introduce low-frequency errors in to the
% RF data since it does not enforce a zero-mean constraint; but the quadrature
% component does, so I will try defining the impulse response using Q instead
% of I to see if that makes a difference
[YI,YQ] = gauspuls(t,centerFreq,fractionalBandwidth);
impulseResponse = YQ;
