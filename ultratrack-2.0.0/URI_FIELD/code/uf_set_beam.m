function uf_set_vector(Tx,Rx,geometry,beamset,set,vector,txoffset)
%
%	uf_set_vector(Tx,Rx,beamset,set,vectorm,txoffset)
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
%		xdc_center_focus - not sure what PositionZ represents
%		rx fixed apodization
%
% Added txoffset and a function input to allow for the Tx beam
% to be laterally offset (m) from the Rx beam to simulate
% parallel ARFI.
% Mark 06/17/05
%
% Corrected the Tx apodization with the txoffset variable.
% Mark 06/21/05


SPEED_OF_SOUND=1540;


offset_X=(geometry.width+geometry.kerf)*geometry.no_elements/2;



%
%       Settings for transmit aperture:
%

% Tx has been updated for the potential lateral offset of the
% beam from the Rx beam in uf_make_xdc().
% Mark 06/17/05

xdc_excitation(Tx,uf_txp(beamset(set).tx_excitation,geometry.field_sample_freq));  % Transmit pulser waveform

% Adding a check to see if txoffset exists - if it doesn't, it
% will be set to zero
% Mark 08/17/05
if(exist('txoffset') == 0),
	disp('uf_set_beam: txoffset is not defined (setting txoffset = 0)');
	txoffset = 0;
end;

% Modified to accomodate txoffset.
% Mark 06/17/05
%xdc_center_focus(Tx,[beamset(set).origin(vector,1) 0 0] ); %Fix this!!! 
xdc_center_focus(Tx,[beamset(set).origin(vector,1)+txoffset 0 0] ); %Fix this!!! 

% The potential lateral offset of the beam is taken account in
% the xdf_focus() command below.
% Mark 06/17/05
focus_x=beamset(set).tx_focus_range*sin(beamset(set).direction(vector))+beamset(set).origin(vector,1);
focus_y=0;
focus_z=beamset(set).tx_focus_range*cos(beamset(set).direction(vector));

% Modified to accomodate txoffset.
% Mark 06/17/05
%xdc_focus(Tx,0,[focus_x focus_y focus_z]); % Transmit focal point
xdc_focus(Tx,0,[focus_x+txoffset focus_y focus_z]); % Transmit focal point

%
% 	Tx Apodization
%
tx_width=beamset(set).tx_focus_range/beamset(set).tx_f_num;
pitch=geometry.width+geometry.kerf;
element_position=(0.5+(0:(geometry.no_elements-1)))*pitch-offset_X;

% Corrected to allow for the txoffset
% Mark 06/21/05
%tx_ap_left_limit =-tx_width/2+beamset(set).origin(vector,1);
%tx_ap_right_limit= tx_width/2+beamset(set).origin(vector,1);
tx_ap_left_limit =-tx_width/2+beamset(set).origin(vector,1)+txoffset;
tx_ap_right_limit= tx_width/2+beamset(set).origin(vector,1)+txoffset;
tx_apodization= double((element_position>tx_ap_left_limit) & ...
		(element_position<tx_ap_right_limit));
if (beamset(set).tx_apod_type==1) % If using a hamming window for the tx apodization,
	% Corrected to allow for the txoffset
	% Mark 06/21/05
	%tx_apodization=tx_apodization.*(0.54+0.46*cos(2*pi*(element_position-...
	tx_apodization=tx_apodization.*(0.54+0.46*cos(2*pi*(element_position-...
			(beamset(set).origin(vector,1)+txoffset))/tx_width));
	end;

xdc_apodization(Tx,0,tx_apodization);







%
% 	Settings for receive aperture:
%

xdc_center_focus(Rx,[beamset(set).origin(vector,1) 0 0] ); %Fix this!!! 

if (beamset(set).is_dyn_focus),  % If dynamic receive focus mode

	xdc_dynamic_focus(Rx,0,beamset(set).direction(vector),0); %set dyn foc

else % otherwise setup the fixed receive focus:

	focus_x=beamset(set).rx_focus_range*sin(beamset(set).direction(vector))+beamset(set).origin(vector,1);
	focus_y=0;
	focus_z=beamset(set).rx_focus_range*cos(beamset(set).direction(vector));

	% I'm not sure why Tx was in there instead of Rx, but that
	% has been changed
	% Mark 06/16/05
	%xdc_focus(Tx,0,[focus_x focus_y focus_z]); % Receive fixed focal point
	xdc_focus(Rx,0,[focus_x focus_y focus_z]); % Receive fixed focal point
end; %end if




%
%       Rx Apodization
%

pitch=geometry.width+geometry.kerf;
element_position=(0.5+(0:(geometry.no_elements-1)))*pitch-offset_X;

for n=1:512,
	ap_times(n,1)=2*beamset(set).rx_f_num*pitch*(n-1)/SPEED_OF_SOUND;

	rx_width=n*pitch;

	rx_ap_left_limit =-rx_width/2+beamset(set).origin(vector,1);
	rx_ap_right_limit= rx_width/2+beamset(set).origin(vector,1);

	rx_apodization(n,:)= double((element_position>rx_ap_left_limit) & ...
                	(element_position<rx_ap_right_limit));

		if (beamset(set).rx_apod_type==1) % If using a hamming window
			rx_apodization(n,:)=rx_apodization(n,:).*(0.54+0.46*cos(2*pi*...
			(element_position-beamset(set).origin(vector,1))/rx_width));
		end;

	end;

xdc_apodization(Rx,ap_times,rx_apodization)






