function [envSNR]=CalcSpeckleSNR
% function [envSNR]=CalcSpeckleSNR(rfmat,axmin,axmax)
%
% Calculate the speckle SNR from the sim RF data
% INPUTS:
%   rfmat (string) - rf sim filename
%   axmin (int) - min axial index to compute SNR over
%   axmax (int) - max axial index to computer SNR over
%
% OUTPUT:
%   envSNR (float) - speckle SNR
%
% EXAMPLE: [envSNR] = CalcSpeckleSNR('rf001.mat',2482,2715);
%
% Mark 2010-10-25

disp(sprintf('Loading %s . . . ', rfmat));
load(rfmat);

% compute the envelope for the RF data over the specified axial range
env = abs(hilbert(rf(axmin:axmax,:)));

% get some averages over all of the lateral lines in the RF data
for i=1:size(rf,2),
	envmean(i) = mean(env(:,i));
	envstd(i) = std(env(:,i));
	envSNRa(i) = envmean(i)/envstd(i);
end;

% output the average SNR
envSNR=mean(envSNRa);
