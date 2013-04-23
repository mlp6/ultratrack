function [Tx,Rx]=uf_make_xdc(geometry)
%
% [Tx,Rx]=uf_make_xdc(geometry)
%
% takes a geometry structure (created by uf_parameters) and
% returns transmit (Tx) and receive (Rx) aperture pointers.
%
% Transducers are initialized with geometry information and 
% impulse response
%
%%%% MODIFICATION HISTORY %%%%
% v2.5.0
% * new 'matrix' probe type for the 2D 4Z1c
% Mark Palmeri (mlp6@duke.edu)
% 2012-09-04
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% v2.6.0
% * new 'image_mode' variable - 'linear' or 'phased'
% * 2D TX_FNUM and RX_FNUM variable; 3D TX_FOCUS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set sampling frequency

set_field('fs',geometry.field_sample_freq);

if (strcmp('linear',geometry.probe_type) | strcmp('phased',geometry.probe_type)),

	% Set up a linear or phased array

	% Create transmit and receive apertures with specified geometry

	% Modified to accomodate a lateral offset of the Tx beam (Mark 06/17/05)
	Tx = xdc_focused_array(geometry.no_elements,geometry.width,geometry.height,geometry.kerf,geometry.elv_focus,geometry.no_sub_x,geometry.no_sub_y, [0 0 geometry.elv_focus]);

	Rx = xdc_focused_array(geometry.no_elements,geometry.width,geometry.height,geometry.kerf,geometry.elv_focus,geometry.no_sub_x,geometry.no_sub_y, [0 0 geometry.elv_focus]);


	% Specify the impulse response of the transducers
	xdc_impulse(Tx,uf_ir(geometry));
	xdc_impulse(Rx,uf_ir(geometry));

elseif strcmp('curvilinear',geometry.probe_type),

	% Set up a curvilinear array

	% Create transmit and receive apertures with specified geometry

	% Modified to accomodate a lateral offset of the Tx beam (Mark 06/17/05)
	Tx = xdc_convex_focused_array(geometry.no_elements,geometry.width,geometry.height,geometry.kerf,geometry.convex_radius,geometry.elv_focus,geometry.no_sub_x,geometry.no_sub_y, [geometry.txoffset(1) geometry.txoffset(2) geometry.elv_focus]);

	Rx = xdc_convex_focused_array(geometry.no_elements,geometry.width,geometry.height,geometry.kerf,geometry.convex_radius,geometry.elv_focus,geometry.no_sub_x,geometry.no_sub_y, [0 0 geometry.elv_focus]);


	% Specify the impulse response of the transducers
	xdc_impulse(Tx,uf_ir(geometry));
	xdc_impulse(Rx,uf_ir(geometry));

% v2.5.0 - matrix probe additions
% Mark Palmeri (mlp6@duke.edu)
% 2012-09-04
elseif strcmp('matrix',geometry.probe_type),
        % the 'focus' variable gets set if uf_set_beam.m, so I am just making
        % it [0 0 10] for now (this is completely arbitrary)
        Tx = xdc_2d_array(geometry.no_elements_x,geometry.no_elements_y,geometry.width,geometry.height,geometry.kerf_x,geometry.kerf_y,geometry.tx_enabled,geometry.no_sub_x,geometry.no_sub_y,[0 0 10]);
	xdc_impulse(Tx,uf_ir(geometry));
        Rx = xdc_2d_array(geometry.no_elements_x,geometry.no_elements_y,geometry.width,geometry.height,geometry.kerf_x,geometry.kerf_y,geometry.rx_enabled,geometry.no_sub_x,geometry.no_sub_y,[0 0 10]);
	xdc_impulse(Rx,uf_ir(geometry));
end
