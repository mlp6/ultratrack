function [envSNR]=CalcSpeckleSNR
% function [envSNR]=CalcSpeckleSNR
% calculate the speckle SNR for our typicaly VF10-5
% configuration (foc 20 mm, F/1, 7 MHz)
%
% Mark 01/07/05

load rf001.mat
env = abs(hilbert(rf(2482:2715,:)));
for i=1:size(rf,2),
	envmean(i) = mean(env(:,i));
	envstd(i) = std(env(:,i));
	envSNRa(i) = envmean(i)/envstd(i);
end;
envSNR=mean(envSNRa);
