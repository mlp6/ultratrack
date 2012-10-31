function [displace_est,mcc]=xcorr_adaptive_cc(data,k_length,wl,wh);
%
% [displace_est,mcc]=xcorr_adaptive_cc(data,k_length,wl,wh);
%
% Code to (I hope) quickly compute line 1 against all displacement estimates
% via normalized cross-correlation.
%
% data is the rf data, fast time -> row index, slow time -> column
% 
% k_length is the length of the kernel in samples
%
% wl is the furthest left you shift the kernel, wh is the furthest right,
% in samples. So wl=wh=0 would return the zero-lag value.
%
% Coding done assuming small search region and 0 or more overlap between
% search windows (i.e., no gaps between search regions)
%
% Based on original sam_track.m
%
% Mark Palmeri (mlp6)
% 2010-11-09

[r_data,c_data]=size(data);

swin=ones(k_length,1);

m_data=conv2(data,swin,'same'); %m_data=k_length*mean(data) within window

v_data=conv2(data.^2,swin,'same')-(m_data.^2)/k_length;

%Make matrix with m_data col1 repeated in all cols
BM_data=(ones(c_data-1,1)*m_data(:,1)')';

%Make matrix with v_data col1 repeated in all cols
BV_data=(ones(c_data-1,1)*v_data(:,1)')';

cc=zeros(r_data,c_data-1,wh-wl+1);

m=1;
for n=wl:wh,
	ind = mod((0:r_data-1)+n,r_data)+1;
	
	cp_data=(ones(c_data-1,1)*data(ind,1)')'.*data(:,2:c_data);	
	cp_data=conv2(cp_data,swin,'same');

	%BM_data=(ones(c_data-1,1)*m_data(ind,1)')';
	%BM=BM_data(ind,:);
	BV=BV_data(ind,:);	

	cc(:,:,m)=(cp_data-BM_data(ind,:).*m_data(:,2:c_data)/k_length)./...
		  sqrt(  BV_data(ind,:) .* v_data(:,2:c_data) );	
	m=m+1;
	end;

cc=shiftdim(cc,2);

displace_est=zeros(c_data-1,r_data);
mcc=zeros(c_data-1,r_data);

% loop over different time steps
for n=10:c_data-1,

	% find the rough location & value of the correlation peak
	[vm_xc,im_xc]=max(cc(:,:,n));
	
	% OK, that got us the location of the correlation peak to 
	% +/- half a sample.  Now we'll fit a parabola to the 
	% peak point and its neighbors, for every correlation line.
	% This works well only when the data is oversampled

	% make sure there'll be a point on either side of the xcorr peak
	im_xc=max(2,im_xc);
	im_xc=min(wh-wl,im_xc); %wh-wl better be at least 2!!

	% x is defined as the vector indicies (read the matrix columwise)
	% of the correlation maxima detected above.

	x=(0:r_data-1)*(wh-wl+1)+im_xc; 
	scc=cc(:,:,n);

	% So scc(x) gives the values of the peak points
	% scc(x-1) gives the values 'to the left' of the peak, etc
	% If we've three sample points on a parabola, 
	% (x1,y1),(x2,y2),(x3,y3),
	% then the location
	% of the peak or mimimum is x'=(y1-y1)/(2y1-4y2+2y3) 
	% and its value is y'=y2+(-y1^2+2y1y3-y3^2)/(8y1-16y2+8y3)
	% 
	% that's what's calculated below for every correlation line
	
	de=2*(scc(x-1)-2*scc(x)+scc(x+1));
	ne=scc(x-1)-scc(x+1);

	displace_est(n,:)=(ne)./...
		( de ) +...
		im_xc+wl-1; % im_xc+wl-1 - makes up for indexing start at 1
	
        
        mcc(n,:) = (-( ne ).^2)./...
                ( 4 * de )+scc(x);

        ORIGINAL.displace_est = displace_est;
        ORIGINAl.mcc = mcc;

        adaptive.Wmax = 1; % max of weighted Gaussian to multiple by (this could be defined by mcc)
        adaptive.seed = 1; % index to start the adaptive weighting (not itself weighted)
        adaptive.var = 0.5; % width of the Gaussian (samples); to be defined by the running average variance
        adaptive.t = wl:wh;
        adaptive.upsmpl = 500;
        for adapt_i = (adaptive.seed+1):r_data,
            adaptive.disp = displace_est(n,adapt_i-1);
            adaptive.cc = squeeze(cc(:,adapt_i,n));
            [ncc]=adapt(adaptive);
            disp(sprintf('ORIG DISP: %i', displace_est(n,adapt_i)));
            [displace_est(n,adapt_i),mcc(n,adapt_i)]=est_up_disp(ncc,wh*adaptive.upsmpl,wl*adaptive.upsmpl,adaptive);
            disp(sprintf('NEW DISP: %i', displace_est(n,adapt_i)));
        end;

        keyboard;

end; % for n

function [newdisp,newcc]=est_up_disp(cc,wh,wl,adaptive)
if(~isnan(cc)),
    [vm,im]=max(cc);
    disp(sprintf('Max Indices = %i',im));
    im = max(2,im);
    im = min(wh-wl,im);
    newdisp=im+wl-1;
    newdisp = newdisp./adaptive.upsmpl;
    newcc = vm;
else,
    newdisp = nan;
    newcc = nan;
end;

function [ncc]=adapt(adaptive)
tup = interp(adaptive.t,adaptive.upsmpl);
ccup = interp(adaptive.cc,adaptive.upsmpl);
gw(1:length(tup)) = (adaptive.Wmax/sqrt(2*pi*adaptive.var.^2)) .* exp(-(tup-adaptive.disp).^2/(2*adaptive.var.^2));
if(isnan(gw)),
    gw = ones(1,length(gw));
end;
ncc = ccup' .* gw;
debug = 1;
if(~isnan(adaptive.disp) & debug == 1)
    plot(tup,ccup./max(ccup));
    hold on
    plot(tup,gw./max(gw),'r');
    plot(tup,ncc./max(ncc),'k');
    legend('Original CC','Gaussian Weight','Weighted CC','Location','SouthWest');
    legend boxoff
    pause
    clf
else,
    disp(sprintf('no good: %f',adaptive.disp))
end;
