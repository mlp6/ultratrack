function [arfidata, cc] = computeDisplacementsNXCorr(rfdata,par)
% [arfidata, cc] = computeDisplacementsNXCorr(rfdata,par)
%
% this routine computes displacements using the normalized
%   cross-correlation algorithm - see equation (3) of 
%   'Rapid Tracking of Small Displacements with Ultrasound', 
%   IEEE Trans. UFFC, vol 53,  pp1103-1117, June 2006.    
%
% Modification History:
% 04/24/12 - jrd20:  Modified Ned's version to work for S2000 data
% 09/02/13 - sjr6: Copied to make this work with the SC2000 data
% 09/10/13 - sjr6: Finalized version with added flexibility
%               modified searchRange to be in wavelengths
%               added defaults for all parameters except trackFrequency
%               added ability to do both fixed (ABACAD...) and dynamic (ABBCCD...) references
%
%   Inputs:
%       rfdata - radio frequency data
%       par - parameters structure with the following included (or use defaults)
%           c                   % speed of sound (m/s) - default 1540 m/s
%           fs                  % sampling frequency (Hz) - default 40e6 Hz (40MHz)
%           trackFrequency      % track frequency (Hz)
%           refIndex            % which time step to use as the reference - default 1
%                               % set to empty or zero to use dynamic references (ABBCCD... tracking)
%           kernelLength        % kernel length (wavelengths) - default 1.5
%           upsampleFactor      % upsample factor - default 3
%           searchRange         % search range in each direction (wavelengths) - default 0.5
%
%   Outputs:
%       arfidata - displacement magnitude in microns
%       cc - cross-correlation coefficients

if nargin<2
    error('Insufficient number of input arguments');
end

% set up default parameters
if ~isfield(par, 'c'),par.c = 1540;fprintf(1, 'Setting par.c to 1540m/s\n');end
if ~isfield(par, 'fs'),par.fs = 40e6;fprintf(1, 'Setting par.fs to 40e6Hz\n');end
if ~isfield(par, 'trackFrequency'),error('Must specify track frequency in parameters structure');end
if ~isfield(par, 'refIndex'),par.refIndex = 1;fprintf(1, 'Setting par.refIndex to 1\n');end
if ~isfield(par, 'kernelLength'),par.kernelLength = 1.5;fprintf(1, 'Setting par.kernelLength to 1.5\n');end
if ~isfield(par, 'upsampleFactor'),par.upsampleFactor = 1;fprintf(1, 'Setting par.upsampleFactor to 3\n');end
if ~isfield(par, 'searchRange'),par.searchRange = 0.5;fprintf(1, 'Setting par.searchRange to 0.5 wavelengths\n');end

% do some basic checks here
if par.trackFrequency<1e3,fprintf(1, 'Warning: Track frequency entered is less than 1kHz, assuming it is in MHz\n');par.trackFrequency = par.trackFrequency*1e6;end
if par.fs<500,fprintf(1, 'Warning: Track PRF entered is less than 500Hz, assuming it is in MHz\n');par.fs = par.fs*1e6;end
if par.c<500,fprintf(1, 'Warning: c=%0.2f, multiplying by 1000 to modifying to m/s\n', par.c);par.c = par.c*1e3;end
if ndims(rfdata)~=3,error('RF Data does not have 3 dimensions');end

% get the size of the RF data
[ndepths,nlocs,ntimes] = size(rfdata);      % depths x locations x times

% determine kernel length in samples and round kernel to an odd number of samples
kernelLengthSamples = floor(par.kernelLength*par.upsampleFactor*par.fs/par.trackFrequency/2).*2+1;

% allocate some memory for correlation coefficient and displacement shift
mcc      = zeros([ndepths,nlocs,ntimes], 'single');
mccshift = zeros([ndepths,nlocs,ntimes], 'single');

% Determine indices for original and upsampled points
nup = ndepths*par.upsampleFactor;              % number of upsampled points
x = 0:(ndepths-1);                             % indices for original and upsampled samples
xi = (0:(nup-1))/par.upsampleFactor;
origIndices = 1:par.upsampleFactor:nup;        % indices of original (not upsampled) points

% Determine search region in number of samples (after upsampling)
searchRange = round(par.searchRange*par.upsampleFactor*par.fs/par.trackFrequency);
fprintf(1, 'Search range is %0.2fum in each direction\n', par.searchRange*(par.c/2)/par.trackFrequency*1e6);

shifts = (-searchRange:searchRange);        % make shifted indices
nshifts = 2*searchRange+1;
shiftedInd = zeros(nup+2*par.upsampleFactor,nshifts);
for ishift=1:nshifts
    pad1   = zeros(1,par.upsampleFactor)+1;
    padend = zeros(1,par.upsampleFactor)+nup;
    paddedindices = [pad1 (1:nup) padend]';
    shiftedInd(:,ishift) = circshift(paddedindices,shifts(ishift));
end
shiftedInd = shiftedInd(par.upsampleFactor+1:par.upsampleFactor+nup,:);

% allocate space for correlation coefficients
cc = zeros(nup,ntimes,nshifts);
% allocate space for upsampled rf data for each location
rfUp = zeros(nup,ntimes);

% windows to give sum or average in conv2 operation
sumwin = ones(kernelLengthSamples,1);
avgwin = ones(kernelLengthSamples,1)/kernelLengthSamples;

% use last pretrack for reference
refIndex = par.refIndex;
if isempty(refIndex) || refIndex==0
    fprintf(1, 'Using dynamic reference (previous time step for each displacement computation)\n');
else
    fprintf(1, 'Using time step %d as reference for all data\n', refIndex);
end

% Loop over all locations and times
tstart = tic;
for iloc=1:nlocs
    if iloc==1
        fprintf(1, 'Displacement Estimation for Beam %d/%d', iloc, nlocs);
    elseif iloc==nlocs
        tmpS = sprintf('%d/%d', iloc-1, nlocs);
        fprintf(1, repmat('\b', [1 length(tmpS)]));
        fprintf(1, '%d/%d', iloc, nlocs);
        fprintf(1, '\n');
    else
        tmpS = sprintf('%d/%d', iloc-1, nlocs);
        fprintf(1, repmat('\b', [1 length(tmpS)]));
        fprintf(1, '%d/%d', iloc, nlocs);
    end

    for itime=1:ntimes
        if par.upsampleFactor==1                        % get upsampled rf data for this location
            rfUp(:,itime) = rfdata(:,iloc,itime);
        else
            rfUp(:,itime) = upsampleSplineSevalMatlab(ndepths,x,rfdata(:,iloc,itime),xi);                
        end
    end

    meanwin = conv2(rfUp,avgwin,'same');        % rfUp averaged over sliding window, i.e., mean(f)
    diffwin = rfUp - meanwin;                   % f-mean(f)
    SSD = conv2(diffwin.^2,sumwin,'same');      % sum of squared differences, i.e., sum( [f-mean(f)]^2 )

    % if refIndex is either empty or zero, then use dynamic reference 
    if ~isempty(refIndex) && refIndex~=0
        refDiff = repmat(diffwin(:,refIndex),[1 size(diffwin,2)]);
        refSSD = repmat(SSD(:,refIndex), [1 size(diffwin,2)]);
    else
        refDiff = diffwin(:,[1 1:end-1]);
        refSSD = SSD(:,[1 1:end-1]);
    end
    
    % compute cc values for each shift
    for ishift=1:nshifts
        shiftedIndices = shiftedInd(:,ishift);
        numerator = conv2(refDiff.*diffwin(shiftedIndices,:), sumwin,'same');
        cc(:,:,ishift) = numerator ./ sqrt( refSSD .* SSD(shiftedIndices,:) );
    end

    ccOrig = cc(origIndices,:,:);       % extract cc at original (not upsampled) depths
    ccOrig = reshape(ccOrig,ndepths*ntimes,nshifts);    % reshape to (ndepths*ntimes) x nshifts
    
    [maxcc,maxIdx] = max(abs(ccOrig),[],2); % If using (+) and (-) pulses, the 'max' correlation is going to be negative, so use absolute value

    % don't let the shifts be at the edges of the search region
    maxIdx(maxIdx==1)       = 2;              % move maxIdx values at edges (shift=1 or shift=nshifts)
    maxIdx(maxIdx==nshifts) = nshifts-1;      % one step closer to center, i.e., 2 or nshifts-1

    allidx = (1:ndepths*ntimes)';
    y1 = ccOrig( sub2ind(size(ccOrig),allidx,maxIdx-1) );
    y2 = ccOrig( sub2ind(size(ccOrig),allidx,maxIdx)   );
    y3 = ccOrig( sub2ind(size(ccOrig),allidx,maxIdx+1) );

    maxIdx = maxIdx +  (y1-y3)./(y1-2*y2+y3)/2; % perform parabolic interpolation
    
    % don't let the shifts be outside of the search region
    maxIdx(maxIdx<1) = 1;
    maxIdx(maxIdx>nshifts) = nshifts;

    % reshape back to ndepths x ntimes and save
    mcc(:,iloc,:) = reshape( maxcc,ndepths,ntimes);
    mccshift(:,iloc,:) = reshape(maxIdx,ndepths,ntimes);
end
tend = toc(tstart);
fprintf(1, 'Displacement Computation Time: %0.2fs\n', tend);

scale = -par.c/2/par.fs/par.upsampleFactor*1e6;     % scale = depth sample spacing after upsampling, *1e6 for microns

zeroIndex = find(shifts==0);                    % subtract index for zero shift and
arfidata = (mccshift-zeroIndex)*scale;          % scale shifts to get displacements

cc = mcc;
end
