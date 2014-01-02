function [D,C]=estimate_disp(rfdata,TRACKPARAMS)
% function [D,C]=estimate_disp(rfdata,TRACKPARAMS)
% 
% SUMMARY: Estimate displacement from the tracking simulations using a variety
% of tracking algorithms.
%
% INPUTS:
%   rfdata (float) - matrix of RF data [axial x lat x t]
%   TRACKPARAMS (struct):
%       TRACK_ALG (string) - tracking algorithm 
%           'samtrack' - Steve McAleavey's cross correlator
%           'samauto' - Steve McAleavey's Kasai algorithm (auto correlator)
%           'ncorr' - Stephen Rosenzweig's updated ncorr algorithm
%           'loupas' - Gianmarco's Loupas algorithm (auto correlator)
%       KERNEL_SAMPLES (int) - size of the tracking kernel
%
% OUTPUTS:
%   D (float) - displacement estimates (um)
%   C (float) - normalized correlation coefficients

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MODIFICATION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Originally written
% Mark 03/31/08
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2009-07-09 (mlp6)
% Reduce the parameter inputs to a single TRACKPARAMS struct
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% extract variables from the input TRACKPARAMS struct
alg = TRACKPARAMS.TRACK_ALG;

% make sure that rfdata is double precision
rfdata = double(rfdata);

switch alg
    case 'samtrack',
        disp('Displacement tracking algorithm: samtrack');
        for n=1:size(rfdata,2)
        % MODIFIED THE CODE TO HAVE A VARIABLE KERNEL SIZE AS A FUNCTION OF
        % FREQUENCY TO MAINTAIN A CONSTANT 2.5 CYCLES / KERNEL
        % MARK 01/24/05
        %[D(:,:,n),C(:,:,n)]=sam_track(squeeze(bigRF(:,n,:)),35,-5,5);
                    %
                    % Allow for variable kernel sizes
                    %
        %[D(:,:,n),C(:,:,n)]=sam_track(squeeze(bigRF(:,n,:)),35*7/Freq,-5,5);
        [D(:,:,n),C(:,:,n)]=sam_track(squeeze(rfdata(:,n,:)),TRACKPARAMS.KERNEL_SAMPLES,-5,5);
        end;

    case 'xcorr_adaptive_cc',
        disp('Displacement tracking algorithm: xcorr_adaptive_cc');
        for n=1:size(rfdata,2)
            disp(sprintf('. . . n = %i of %i',n,size(rfdata,2)))
            [D(:,:,n),C(:,:,n)]=xcorr_adaptive_cc(squeeze(rfdata(:,n,:)),TRACKPARAMS.KERNEL_SAMPLES,-5,5);
        end;
    case 'samauto',
        error('samauto tracking has not been integrated yet');
    case 'ncorr',
        [D, C] = computeDisplacementsNXCorr(rfdata,TRACKPARAMS);
    case 'loupas',
        error('loupas tracking has not been integrated yet');
    otherwise,
        error(sprintf('%s cannot be found as a tracking algorithm',TRACKPARAMS.TRACK));
end;
