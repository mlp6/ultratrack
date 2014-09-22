function [N] = calc_n_scats(scat_density, PPARAMS)
% function [N] = calc_n_scats(scat_density, PPARAMS)
%
% INPUTS:   scat_density - scatterers / cm^3
%           PPARAMS (struct) - phantom parameters 
%
% OUTPUTS:  N (int) - number of scatterers in the model volume

TRACKING_VOLUME =   (PPARAMS.xmax - PPARAMS.xmin) * ...
                    (PPARAMS.ymax - PPARAMS.ymin) * ...
                    (PPARAMS.zmax - PPARAMS.zmin); % cm^3
% number of scatterers to randomly distribute over the tracking volume
N = round(scat_density * TRACKING_VOLUME); 
