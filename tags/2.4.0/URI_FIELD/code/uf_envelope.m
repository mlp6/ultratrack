function [envdb]=uf_envelope(rf);

%
% [envdb]=uf_envelope(rf);
%
% uf_envelope finds the envelope of the columnwise rf data
% presented in (rf).  The envelope data is returned on a 
% decibel scale, with a peak of 0dB
%
% Using the grayscale limit feature of imagesc, the envelope 
% data can be displayed with any desired dynamic range.  For
% example, to display an image with a 60 dB dynamic range, 
% one would type
%
% envdb=uf_envelope(rf);
% imagesc(envdb,[-60 0]);
%

% Version 1.0 Stephen McAleavey Feb 4 2004


envdb=abs(hilbert(rf));
envdb=envdb/max(envdb(:));
envdb=20*log10(envdb);
