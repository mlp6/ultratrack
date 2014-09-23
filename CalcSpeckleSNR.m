function [envSNR]=CalcSpeckleSNR(rfmat, axMinIndex, axMaxIndex)
% function [envSNR]=CalcSpeckleSNR
%
% Really crude script to calculate the SNR from rf001.mat at user-specific
% axial indices (around the focus), averaged over all lateral lines that exist.
% If you are expecting elegant code, then look elsewhere!
%
% INPUTS:   rfmat (string) - RF data matlab file (e.g., 'rf001.mat') 
%           axMinIndex (int) - raw rf001.mat axial index (min)
%           axMaxIndex (int)
%
% OUTPUTS:  envSNR (int) - raw SNR of the envelope-detected data
%
% EXAMPLE: [speckle_snr] = CalcSpeckleSNR('rf001.mat', 2500, 2750);
%

load(rfmat);

env = abs(hilbert(rf(axMinIndex:axMaxIndex,:)));

for i = 1:size(rf,2),
	envmean(i) = mean(env(:,i));
	envstd(i) = std(env(:,i));
	envSNRa(i) = envmean(i)/envstd(i);
end;

envSNR = mean(envSNRa);
