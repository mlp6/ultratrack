function uf_set_vector(Tx,Rx,geometry,beamset,set,vectorx,vectory)
%
%	uf_set_vector(Tx,Rx,beamset,set,vector)
%
%	Takes transmit (Tx) and receive (Rx) aperture pointers, 
%	a beam data structure (beam_struct), and set and vector numbers,
%	and sets up the apertures to match the selected beams.
%
%       The excitation pulse, beam direction, transmit and receive focus
%	are set by this function.   
%
%	Apodization will eventually be set by this function.
%
%	Revisions / Bug Fixes:
%	
%	Feb 6, '04 - fixed half-element displacement error in tx & rx 
%			apodization profiles
%	NOT YET COMPLETE:
%		rx fixed apodization
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Corrected the Tx apodization with the txoffset variable.
% Mark 06/21/05
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% v2.6.0 (MLP, 2012-10-04)
% * added matrix_phased imaging option that avoids resetting xdc_center_focus
% * cleaned up old changes to make more readable
% * incorporated 'linear' and 'phased' imaging modes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2.6.0 (MLP, 2012-10-27)
% Not sure if I need to add an offset_Y into the mix here for the matrix arrays...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SPEED_OF_SOUND = geometry.c;
txoffset = geometry.txoffset;

offset_X=(geometry.width+geometry.kerf_x)*geometry.no_elements_x/2;
% ADD offset_Y for the matrix arrays?! (MLP, 2012-10-27)

%       Settings for transmit aperture:
%
% Tx has been updated for the potential lateral offset of the
% beam from the Rx beam in uf_make_xdc().
% Mark 06/17/05

xdc_excitation(Tx,uf_txp(beamset(set).tx_excitation,geometry.field_sample_freq));  % Transmit pulser waveform

% txoffset (Mark 06/17/05)
% updated to accomodate elevation txoffset (Mark, 2012-10-09)
if(geometry.image_mode == 'linear'),
    xdc_center_focus(Tx,[beamset(set).originx(vector,1)+txoffset(1) beamset(set).originy(vectory,1)+txoffset(2) 0] );
elseif(geometry.image_mode == 'phased'),
    xdc_center_focus(Tx,[0 0 0] );
else,
    error('uf_set_beam: invalid image_mode defined');
end;

% The potential lateral offset of the beam is taken account in
% the xdf_focus() command below.
% Mark 06/17/05
focus_x=beamset(set).tx_focus_range*sin(beamset(set).directionx(vectorx))+beamset(set).originx(vectorx,1);
focus_y=beamset(set).tx_focus_range*cos(beamset(set).directiony(vectory))+beamset(set).originy(vectory,1);
focus_z=beamset(set).tx_focus_range*cos(beamset(set).directionx(vectorx))+beamset(set).tx_focus_range*sin(beamset(set).directiony(vectory));

% txoffset (Mark 06/17/05)
% updated to accomodate elevation txoffset (Mark, 2012-10-09)
xdc_focus(Tx,0,[focus_x+txoffset(1) focus_y+txoffset(2) focus_z]); % Transmit focal point

% Tx Apodization
tx_width=beamset(set).tx_focus_range/beamset(set).tx_f_num(1);
pitch=geometry.width+geometry.kerf_x;
element_position=(0.5+(0:(geometry.no_elements_x-1)))*pitch-offset_X;

% txoffset (Mark 06/21/05)
% specified lateral toffset (Mark, 2012-10-09)
tx_ap_left_limit =-tx_width/2+beamset(set).originx(vectorx,1)+txoffset(1);
tx_ap_right_limit= tx_width/2+beamset(set).originx(vectorx,1)+txoffset(1);
tx_apodization= double((element_position>tx_ap_left_limit) & (element_position<tx_ap_right_limit));
if (beamset(set).tx_apod_type==1) % If using a hamming window for the tx apodization,
    % txoffset (Mark 06/21/05)
    tx_apodization=tx_apodization.*(0.54+0.46*cos(2*pi*(element_position-(beamset(set).originx(vectorx,1)+txoffset(1)))/tx_width));
end;

if(~(strcmp(geometry.probe_type,'matrix'))),
    xdc_apodization(Tx,0,tx_apodization);
else,
    warning('Apodization not supported for matrix probes; no Tx apodization applied.');
end;

% Settings for receive aperture:

if(geometry.image_mode == 'linear'),
    xdc_center_focus(Rx,[beamset(set).origin(vector,1) 0 0] );
elseif(geometry.image_mode == 'phased'),
    xdc_center_focus(Tx,[0 0 0] );
else,
    error('uf_set_beam: invalid image_mode defined');
end;

if (beamset(set).is_dyn_focus),  % If dynamic receive focus mode
    xdc_dynamic_focus(Rx,0,beamset(set).directionx(vectorx),beamset(set).directiony(vectory)); %set dyn foc
%% I STILL NEED TO FIX THE FIXED FOCUS CASE FOR AN ARBITRARY RX FOCUS IN 3D SPACE!!!!
else % otherwise setup the fixed receive focus:
    focus_x=beamset(set).rx_focus_range*sin(beamset(set).direction(vector))+beamset(set).origin(vector,1);
    focus_y=0;
    focus_z=beamset(set).rx_focus_range*cos(beamset(set).direction(vector));

    xdc_focus(Rx,0,[focus_x focus_y focus_z]); % Receive fixed focal point
end; 

% Rx Apodization

pitch=geometry.width+geometry.kerf_x;
element_position=(0.5+(0:(geometry.no_elements_x-1)))*pitch-offset_X;

for n=1:512,
    ap_times(n,1)=2*beamset(set).rx_f_num(1)*pitch*(n-1)/SPEED_OF_SOUND;

    rx_width=n*pitch;

    rx_ap_left_limit =-rx_width/2+beamset(set).originx(vectorx,1);
    rx_ap_right_limit= rx_width/2+beamset(set).originx(vectorx,1);

    rx_apodization(n,:)= double((element_position>rx_ap_left_limit) & ...
        (element_position<rx_ap_right_limit));

    if (beamset(set).rx_apod_type==1) % If using a hamming window
        rx_apodization(n,:)=rx_apodization(n,:).*(0.54+0.46*cos(2*pi*...
            (element_position-beamset(set).originx(vectorx,1))/rx_width));
    end;
end;

if(~(strcmp(geometry.probe_type,'matrix'))),
    xdc_apodization(Rx,ap_times,rx_apodization)
else,
    warning('Apodization not supported for matrix probes; no Rx apodization applied.');
end;
