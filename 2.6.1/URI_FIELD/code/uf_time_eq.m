function [out,st]=uf_time_eq(in,start_times,sample_freq);

%
% [out,st]=uf_time_eq(in,start_times,sample_freq);
%
% Takes a matrix of Field echo data (in), a vector of start times
% (start_times), each element of start_times corresponding to a 
% column of (in), and the sampling frequency (sample_freq).
%
% Returns (out), a matrix containing the echo data with each column
% starting at the same time, and (st), a scalar denoting the start time.
%

% 0.9 Stephen McAleavey Feb 4 2004

min_sample=round(min(start_times(:))*sample_freq);
max_sample=round(max(start_times(:))*sample_freq);
[n,m,o]=size(in);
out=zeros(n+max_sample-min_sample,m,o);

for k=1:size(in,2),
   for j = 1:size(in,3),
	v=[zeros(round(start_times(k,j)*sample_freq-min_sample),1); 
           in(1:n,k,j)];
	out(1:max(size(v)),k,j)=v;
   end;
end;

st=min(start_times(:));
			   

