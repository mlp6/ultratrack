function [displace_est,mcc]=kasai_track(data,k_length);
% function [displace_est,mcc]=kasai_track(data,k_length);
%
% INPUTS:
% 	data is the rf data, fast time -> row index, slow time -> column
% 	k_length is the length of the kernel in samples
%
% 	Coding done assuming small search region and 0 or more overlap between
% 	search windows (i.e., no gaps between search regions)

% OUTPUTS:
%		displace_est - displacement estimates (D)
%		mcc - filler matrix for what is CC in NCC alg (C)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is based on sam_track_auto.m, but cleaned up since
% Steve's version still had the CC inputs and other straglers
% from sam_track.m that weren't appropriate.
% Mark 11/20/06
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data=hilbert(data);
[r_data,c_data]=size(data);

swin=ones(k_length,1);

c1_data=(ones(c_data-1,1)*data(:,1)')';

nu=imag(data(:,2:c_data)).*real(c1_data)-real(data(:,2:c_data)).*imag(c1_data);
de=real(data(:,2:c_data)).*real(c1_data)+imag(data(:,2:c_data)).*imag(c1_data);

nu=conv2(nu,swin,'same');
de=conv2(de,swin,'same');

displace_est=atan2(nu,de)';
mcc=ones(size(displace_est));
