function [D,C]=estimate_disp(rfdata,alg,kernelsize)
% function [D,C]=estimate_disp(rfdata,alg,kernelsize)
% 
% SUMMARY: Estimate displacement from the tracking simulations using a variety
% of tracking algorithms.
%
% INPUTS:
%   rfdata (float) - matrix of RF data [axial x lat x t]
%   alg (string) - tracking algorithm 
%       'samtrack' - Steve McAleavey's cross correlator
%       'samauto' - Steve McAleavey's Kasai algorithm (auto correlator)
%       'ncorr' - Gianmarco's cross correlator
%       'loupas' - Gianmarco's Loupas algorithm (auto correlator)
%   kernelsize (int) - number of samples in the tracking kernel
%
% OUTPUTS:
%   D (float) - displacement estimates (um)
%   C (float) - correlation coefficients (normalized)
%
% EXAMPLE:
%
% Mark 03/31/08

switch alg
    case 'samtrack',
        for n=1:size(rfdata,2)
        % MODIFIED THE CODE TO HAVE A VARIABLE KERNEL
        % SIZE AS A FUNCTION OF FREQUENCY TO MAINTAIN A
        % CONSTANT 2.5 CYCLES / KERNEL
        % MARK 01/24/05
        %[D(:,:,n),C(:,:,n)]=sam_track(squeeze(bigRF(:,n,:)),35,-5,5);
                    %
                    % Allow for variable kernel sizes
                    %
        %[D(:,:,n),C(:,:,n)]=sam_track(squeeze(bigRF(:,n,:)),35*7/Freq,-5,5);
        [D(:,:,n),C(:,:,n)]=sam_track(squeeze(rfdata(:,n,:)),kernelsize,-5,5);
        end;

    case 'samauto',
        error('samauto tracking has not been intengrated yet');
    case 'ncorr',
        error('ncorr tracking has not been intengrated yet');
    case 'loupas',
        error('loupas tracking has not been intengrated yet');
    otherwise,
        error(sprintf('%s cannot be found as a tracking algorithm',TRACKPARAMS.TRACK));
end;
