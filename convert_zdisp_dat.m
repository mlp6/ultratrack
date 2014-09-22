function []=convert_zdisp_dat(ZDISPFILE)
% function []=convert_zdisp_dat(ZDISPFILE)
%
% Convert zdisp.mat -> zdisp.dat so that individual time step data can be read
% instead of needing to read in all time steps at once (and clobbering
% available RAM).  zdisp.mat is assumed to exist in the CWD.
%
% INPUTS:   ZDISPFILE (string) - full or relative path to zdisp.mat 
%
% OUTPUTS:  zdisp.dat is saved to the same directory in ZDISPFILE
%           All data is float32 with the format:
%               NUM_NODES
%               NUM_DIMS (Node ID, X, Y, Z displacements)
%               NUM_TIMESTEPS
%               The rest of the data are the concatenation of NUM_NODES x
%               NUM_DIMS x NUM_TIMESTEPS.
%
% EXAMPLE: convert_zdisp_dat('/data/mlp6/zdisp.mat')
%
% Mark Palmeri (mlp6)
% mark.palmeri@duke.edu
% 2009-07-08

ZDISPDAT = regexprep(ZDISPFILE,'zdisp.mat','zdisp.dat');

if(exist(ZDISPFILE,'file') == 0),
    error(sprintf('%s does not exist in the CWD.',ZDISPFILE));
else,
    load(ZDISPFILE);
end;

fid=fopen(ZDISPDAT,'w');

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

disp(sprintf('File Created: %s',ZDISPDAT));
