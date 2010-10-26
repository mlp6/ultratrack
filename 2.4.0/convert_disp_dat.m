function []=convert_disp_dat(DISPFILE)
% function []=convert_disp_dat()
%
% Convert disp.mat -> disp.dat so that individual time step data can be read
% instead of needing to read in all time steps at once (and clobbering
% available RAM).  disp.mat is assumed to exist in the CWD.
%
% INPUTS:   DISPFILE (string) - full or relative path to zdisp.mat 
%
% OUTPUTS:  disp.dat is saved to the same directory in DISPFILE
%           All data is float32 with the format:
%               NUM_NODES
%               NUM_DIMS (Node ID, X, Y, Z displacements)
%               NUM_TIMESTEPS
%               The rest of the data are the concatenation of NUM_NODES x NUM_DIMS x NUM_TIMESTEPS.
%
% EXAMPLE: convert_disp_dat('/data/mlp6/disp.mat')
%
% Mark Palmeri (mlp6)
% mark.palmeri@duke.edu
% 2009-07-08
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Updated to used disp.dat, not zdisp.dat
% Mark 2010-05-13
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55

DISPDAT = regexprep(DISPFILE,'zdisp.mat','disp.dat');

if(exist(DISPFILE,'file') == 0),
    error(sprintf('%s does not exist in the CWD.',DISPFILE));
else,
    load(DISPFILE);
end;

fid=fopen(DISPDAT,'w');

numnodes = size(zdisp,1);
numdims = size(zdisp,2);
numtimesteps = size(zdisp,3);

fwrite(fid,numnodes,'float32');
fwrite(fid,numdims,'float32');
fwrite(fid,numtimesteps,'float32');

for t=1:numtimesteps,
    fwrite(fid,squeeze(zdisp(:,:,t)),'float32');
end;

fclose(fid);

disp(sprintf('File Created: %s',DISPDAT));
