function BEAMPLOT=mp_beamplot(FILENAME,x,y,z,aperture,vector,txapod,rxapod);

%
% BEAMPLOT = mp_beamplot(FILENAME,X,Y,X,APERTURE,VECTOR,TXAPOD,RXAPOD);
%
% Function to produce beamplots from sim'd arfi data sets.
%
% MUST BE PRECEDED BY A CALL TO FIELD_INIT!!
%
% BEAMPLOT is the intensity as calculated by uf_beam_inten.
%
% FILENAME is the name of an arfi-simulation track file, e.g. 'track_TRACK1'
%
% X,Y,Z describe the points at which to calculate the intensity.  These 
% scalers or vectors are passed to meshgrid to create a plaid array of points.
% Field corodinate system is used (x lateral, y out-of-plane, z axial, meters
% for all dimensions)
%
% APERTURE specifies the aperture for which to plot the beam.  0 gives the
% beam from the transmit aperture, 1 gives the 'beam' for the receive aperture,
% and 2 gives the two-way beam intensity.  
% (you get calc_hp(tx or rx) or calc_hhp(tx and rx) sum-squared as the result).
%
% VECTOR is which a-line to calculate for.  
% 
% TXAPOD and RXAPOD are the apodization settings for the transmit and receive
% apertures, respectively.  A value of 0 implies rect-window apodization, 
% while 1 implies hamming window apodization. 
%
% As coded, dynamic receive focusing & apodization are on.
%
% Sorry, no error catching/recovery yet.
%
%
% Example: For file 'track', find the in-plane transmit intensity from 
% -3 to 3 mm lateraly and from 1mm to 3cm axially, in 100 micron increments,
% for the 21st a-line, with hamming apodization on transmit and receive:
%
% x = -3e-3 : 100e-6 : 3e-3;
% y = 0;
% z = 1e-3 : 100e-6 : 3e-2; % Don't get too close to he 'ducer face
%                           % or Field will divide by zero and die
% BEAMPLOT=mp_beamplot('track',x,y,z,0,21,1,1);
% imagesc(x,z,squeeze(BEAMPLOT)');axis image;

% Jan 11, 2005, S. McAleavey, U. Rochester BME

my_data=load(FILENAME);
bsnum=1; % which of multiple beamsets to use if beamset is array

% Get geometrical probe data and create tx/rx apertures in Field
probe=uf_txt_to_probe(my_data.PARAMS.PROBE_NAME);
probe.field_sample_freq=100e6;
[STEVES_OWN_TX,STEVES_OWN_RX]=uf_make_xdc(probe);

% Create the beamset data
% COPIED DIRECTLY FROM DO_DYNA_SCANS.M, added the 'my_data.PARAMS.' prefix
% where appropriate 
beamset.type='B';
beamset.origin=(my_data.PARAMS.XMIN:my_data.PARAMS.XSTEP:my_data.PARAMS.XMAX)';
beamset.no_beams=length(beamset.origin);
beamset.direction=zeros(size(beamset.origin))';
beamset.tx_focus_range=my_data.PARAMS.TX_FOCUS;
beamset.tx_f_num=my_data.PARAMS.TX_F_NUM;
beamset.tx_excitation.f0=my_data.PARAMS.TX_FREQ;
beamset.tx_excitation.num_cycles=my_data.PARAMS.TX_NUM_CYCLES;
beamset.tx_excitation.phase=0;
beamset.tx_excitation.wavetype='Square';
beamset.prf=NaN;
beamset.tx_apod_type=txapod; % 1=Hamming apodization, select 0 for rectangular

beamset.is_dyn_focus = (my_data.PARAMS.RX_FOCUS==0);   % If RX_FOCUS is spec'd zero, use
                                        % dynamic focus
beamset.rx_focus_range=my_data.PARAMS.RX_FOCUS;        % Receive focal point,zero=dynamic
beamset.rx_apod_type=rxapod; % 1=Hamming, 0 = rectangular apodization
beamset.rx_f_num=my_data.PARAMS.RX_F_NUM;
beamset.aperture_growth=my_data.PARAMS.RX_GROW_APERTURE;
beamset.apex=NaN;
beamset.steering_angle=zeros(size(beamset.origin))';

% Set aperture for selected beamset
uf_set_beam(STEVES_OWN_TX,STEVES_OWN_RX,probe,beamset,bsnum,vector);


% Calculate the beamplot
if (aperture==0),
	BEAMPLOT=uf_beam_inten(STEVES_OWN_TX,x,y,z);
elseif (aperture==1),
        BEAMPLOT=uf_beam_inten(STEVES_OWN_RX,x,y,z);
elseif (aperture==2),
	BEAMPLOT=uf_beam_inten(STEVES_OWN_TX,STEVES_OWN_RX,x,y,z);
else
	error('APERTURE must be 0, 1 or 2.');
end;


