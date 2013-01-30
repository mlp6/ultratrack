%
% scan_demo
%
% demonstrates use of URI-Field II tools to simulate scanning
%

% Start Field II
%
field_init(0);


% Read URI file
%
[rf,head]=readFile;
pause(0);


% Extract probe and beam sequence data from header
%
[geometry,beamset]=uf_parameters(head);


% create transmit and receive apertures
%
[tx,rx]=uf_make_xdc(geometry);


% create a phantom
%
phantom=uf_phantom_grid(0.005,0.03,0.005,0,0.03,0.005);


% Pick the beamset you want to simulate
% 
n_set=1;

% Select each vector in the beamset and calculate echo signal
%
for n_vector=1:beamset(n_set).no_beams,
	disp(sprintf('Processing Vector %d of %d',n_vector,beamset(n_set).no_beams));
	uf_set_beam(tx,rx,geometry,beamset,n_set,n_vector);
	[v,t1]=calc_scat(tx,rx,phantom.position,phantom.amplitude);
    
	rfdata(1:length(v),n_vector)=v;
	start_times(n_vector)=t1;
	end;
	
% Create rf with equal t0's from rfdata 
%
[rf,t0]=uf_time_eq(rfdata,start_times,geometry.field_sample_freq);
td=length(geometry.impulse_response)*2/geometry.field_sample_freq;

% Close Field
%
field_end;
	

% Create envelope-detected, log-compressed dataset
%
envdb=uf_envelope(rf);


% Scan convert and create axes
%
[sc_img,ax,lat]=uf_scan_convert(envdb,geometry,beamset(n_set),t0-td);


% Display the image
%
imagesc(lat,ax,sc_img,[-40 0]);axis image; colormap(gray);

