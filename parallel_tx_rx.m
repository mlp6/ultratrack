function [PARAMS] = parallel_tx_rx(TX_BEAM_OVERRIDE, PARALLEL_OVERRIDE, PARAMS)
% function [PARAMS] = parallel_tx_rx(TX_BEAM_OVERRIDE, PARALLEL_OVERRIDE, PARAMS)
%
% INPUTS: TX_BEAM_OVERRIDE (logical) - non-uniform Tx beam spacing
%         PARALLEL_OVERRIDE (logical)
%         PARAMS (struct) - Tx/Rx parameters
%
% OUTPUTS: PARAMS (struct) - Tx/Rx parmeters w/ updated fields
%
%% ---------- AUTOMATICALLY CALCULATED PARAMETERS -------------------
% You shouldn't need to change these unless you are using one of the
% override functions to specify non-uniform TX or || RX beam spacings

% ---------------- TRANSMIT OVERRIDE ---------------------------
% Override only if necessary. If you specify your own origins and angles,
% you can set the origins and angles as such:
%   ORIGIN  ANGLE
%   [1x1]   [1x1]   - single TX Beam
%   [1xN]   [1xN]   - specifiy origin and angle for each beam
%   [1xN]   [1x1]   - specify each origin, use same angle
%   [1x1]   [1xN]   - specify each angle, use same origin
%

TX_BEAM_OVERRIDE = logical(0);

if TX_BEAM_OVERRIDE,
    PARAMS.BEAM_ORIGIN_X = 0;
    PARAMS.BEAM_ORIGIN_Y = 0;
    PARAMS.BEAM_ANGLE_X = 0;
    PARAMS.BEAM_ANGLE_Y = 0;
else
    PARAMS.BEAM_ORIGIN_X = PARAMS.XMIN:PARAMS.XSTEP:PARAMS.XMAX;
    PARAMS.BEAM_ORIGIN_Y = PARAMS.YMIN:PARAMS.YSTEP:PARAMS.YMAX;
    PARAMS.BEAM_ANGLE_X = PARAMS.THMIN:PARAMS.THSTEP:PARAMS.THMAX;
    PARAMS.BEAM_ANGLE_Y = PARAMS.PHIMIN:PARAMS.PHISTEP:PARAMS.PHIMAX;
    
    if PARAMS.XSTEP == 0;
        PARAMS.BEAM_ORIGIN_X = (PARAMS.XMIN + PARAMS.XMAX)/2;
    end
    if PARAMS.YSTEP == 0;
        PARAMS.BEAM_ORIGIN_Y = (PARAMS.YMIN + PARAMS.YMAX)/2;
    end
    if PARAMS.THSTEP == 0;
        PARAMS.BEAM_ANGLE_X = (PARAMS.THMIN + PARAMS.THMAX)/2;
    end
    if PARAMS.PHISTEP == 0;
        PARAMS.BEAM_ANGLE_Y = (PARAMS.PHIMIN + PARAMS.PHIMAX)/2;
    end
end

PARAMS.BEAM_ANGLE_X = deg2rad(PARAMS.BEAM_ANGLE_X);
PARAMS.BEAM_ANGLE_Y = deg2rad(PARAMS.BEAM_ANGLE_Y);


if length(PARAMS.BEAM_ANGLE_X) > 1 && ...
    length(PARAMS.BEAM_ORIGIN_X) > 1 && ...
    length(PARAMS.BEAM_ORIGIN_X) ~= ...
    length(PARAMS.BEAM_ANGLE_X);
    error('BEAM_ORIGIN_X and BEAM_ANGLE_X cannot both be vectors and have different lengths.')
end

if length(PARAMS.BEAM_ANGLE_Y) > 1 && ...
    length(PARAMS.BEAM_ORIGIN_Y) > 1 && ...
    length(PARAMS.BEAM_ORIGIN_Y) ~= ...
    length(PARAMS.BEAM_ANGLE_Y);
    error('BEAM_ORIGIN_Y and BEAM_ANGLE_Y cannot both be vectors and have different lengths.')
end

PARAMS.NO_BEAMS_X = max(length(PARAMS.BEAM_ORIGIN_X), length(PARAMS.BEAM_ANGLE_X));
PARAMS.NO_BEAMS_Y = max(length(PARAMS.BEAM_ORIGIN_Y), length(PARAMS.BEAM_ANGLE_Y));


%  ----------------- PARALLEL RX OVERRIDE ---------------------------
% Override if necessary. Default spaces || RX evenly between TX beams. If
% only a single TX beam is used, the step size dictates the spread of the
% || RX beams (Peter, 2012.11.15)

%FULL_PARLLEL_OVERRIDE lets you specify the parallel receive matrix. Each
%row corresponds to a parallel beam. the columns are x-offset (m),
%y-offset(m), x-angle offset (deg) y-angle offset(deg), respectively.
PARALLEL_OVERRIDE = 0;

if PARALLEL_OVERRIDE
    PARAMS.RXOFFSET = [0 0 0 0];
    PARAMS.RXOFFSET(:,3:4) = deg2rad(PARAMS.RXOFFSET(:,3:4));
else
    
    PARALLEL_TH_MIN  = -0.5*PARAMS.THSTEP*PARAMS.PARALLEL_SPACING(1)* (PARAMS.NO_PARALLEL(1)-1)/(PARAMS.NO_PARALLEL(1));
    PARALLEL_TH_MAX  =  0.5*PARAMS.THSTEP*PARAMS.PARALLEL_SPACING(1)* (PARAMS.NO_PARALLEL(1)-1)/(PARAMS.NO_PARALLEL(1));
    PARALLEL_PHI_MIN = -0.5*PARAMS.PHISTEP*PARAMS.PARALLEL_SPACING(2)*(PARAMS.NO_PARALLEL(2)-1)/(PARAMS.NO_PARALLEL(2));
    PARALLEL_PHI_MAX =  0.5*PARAMS.PHISTEP*PARAMS.PARALLEL_SPACING(2)*(PARAMS.NO_PARALLEL(2)-1)/(PARAMS.NO_PARALLEL(2));
    PARALLEL_X_MIN   = -0.5*PARAMS.XSTEP*PARAMS.PARALLEL_SPACING(1)*  (PARAMS.NO_PARALLEL(1)-1)/(PARAMS.NO_PARALLEL(1));
    PARALLEL_X_MAX   =  0.5*PARAMS.XSTEP*PARAMS.PARALLEL_SPACING(1)*  (PARAMS.NO_PARALLEL(1)-1)/(PARAMS.NO_PARALLEL(1));
    PARALLEL_Y_MIN   = -0.5*PARAMS.YSTEP*PARAMS.PARALLEL_SPACING(2)*  (PARAMS.NO_PARALLEL(2)-1)/(PARAMS.NO_PARALLEL(2));
    PARALLEL_Y_MAX   =  0.5*PARAMS.YSTEP*PARAMS.PARALLEL_SPACING(2)*  (PARAMS.NO_PARALLEL(2)-1)/(PARAMS.NO_PARALLEL(2));
    
    PARALLEL_TH_OFFSET0 = deg2rad(linspace(PARALLEL_TH_MIN,PARALLEL_TH_MAX,PARAMS.NO_PARALLEL(1)));    %RADIANS!
    PARALLEL_PHI_OFFSET0 = deg2rad(linspace(PARALLEL_PHI_MIN,PARALLEL_PHI_MAX,PARAMS.NO_PARALLEL(2))); %RADIANS!
    PARALLEL_X_OFFSET0 = linspace(PARALLEL_X_MIN,PARALLEL_X_MAX,PARAMS.NO_PARALLEL(1));
    PARALLEL_Y_OFFSET0 = linspace(PARALLEL_Y_MIN,PARALLEL_Y_MAX,PARAMS.NO_PARALLEL(2));
    
    [PARALLEL_TH_OFFSET PARALLEL_PHI_OFFSET] = meshgrid(PARALLEL_TH_OFFSET0,PARALLEL_PHI_OFFSET0);
    [PARALLEL_X_OFFSET PARALLEL_Y_OFFSET] = meshgrid(PARALLEL_X_OFFSET0,PARALLEL_Y_OFFSET0);
    
    PARAMS.RXOFFSET =  [PARALLEL_X_OFFSET(:) PARALLEL_Y_OFFSET(:) PARALLEL_TH_OFFSET(:) PARALLEL_PHI_OFFSET(:)];
end
