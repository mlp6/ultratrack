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


% Set sampling frequency

set_field('fs',geometry.field_sample_freq);

if (strcmp('linear',geometry.probe_type) | strcmp('phased',geometry.probe_type)),

	% Set up a linear or phased array

	% Create transmit and receive apertures with specified geometry

	Tx = xdc_focused_array(geometry.no_elements,geometry.width,geometry.height,geometry.kerf,geometry.elv_focus,geometry.no_sub_x,geometry.no_sub_y, [0 0 geometry.elv_focus]);

	Rx = xdc_focused_array(geometry.no_elements,geometry.width,geometry.height,geometry.kerf,geometry.elv_focus,geometry.no_sub_x,geometry.no_sub_y, [0 0 geometry.elv_focus]);


	% Specify the impulse response of the transducers

	xdc_impulse(Tx,uf_ir(geometry));
	xdc_impulse(Rx,uf_ir(geometry));


elseif strcmp('curvilinear',geometry.probe_type),

	% Set up a curvilinear array

	% Create transmit and receive apertures with specified geometry

	Tx = xdc_focused_array(geometry.no_elements,geometry.width,geometry.height,geometry.kerf,geometry.convex_radius,geometry.elv_focus,geometry.no_sub_x,geometry.no_sub_y, [0 0 geometry.elv_focus]);

	Rx = xdc_focused_array(geometry.no_elements,geometry.width,geometry.height,geometry.kerf,geometry.convex_radius,geometry.elv_focus,geometry.no_sub_x,geometry.no_sub_y, [0 0 geometry.elv_focus]);


	% Specify the impulse response of the transducers

	xdc_impulse(Tx,uf_ir(geometry));
	xdc_impulse(Rx,uf_ir(geometry));

end;




