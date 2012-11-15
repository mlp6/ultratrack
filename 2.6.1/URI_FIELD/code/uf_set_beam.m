function toffset = uf_set_beam(Tx,Rx,geometry,beamset,idx,vectorx,vectory,vectorp)
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
% 2.6.1
% Added parallel receive indexing
% PJH7 2012.11.2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
debug_fig = 0;

SPEED_OF_SOUND = geometry.c;
%txoffset = geometry.txoffset;

offset_X=(geometry.width+geometry.kerf_x)*geometry.no_elements_x/2;
offset_Y=(geometry.width+geometry.kerf_y)*geometry.no_elements_y/2;

pitch=geometry.width+geometry.kerf_x;
element_position_x=(0.5+(0:(geometry.no_elements_x-1)))*pitch-offset_X;
element_position_y=(0.5+(0:(geometry.no_elements_y-1)))*pitch-offset_Y;

% ADD offset_Y for the matrix arrays?! (MLP, 2012-10-27)

%       Settings for transmit aperture:
%
% Tx has been updated for the potential lateral offset of the
% beam from the Rx beam in uf_make_xdc().
% Mark 06/17/05

xdc_excitation(Tx,uf_txp(beamset(idx).tx_excitation,geometry.field_sample_freq));  % Transmit pulser waveform

x0t = beamset(idx).originx(vectorx)-beamset(idx).apex*(tan(beamset(idx).directionx(vectorx)));
y0t = beamset(idx).originy(vectory)-beamset(idx).apex*(tan(beamset(idx).directiony(vectory)));
z0t = beamset(idx).apex;

% txoffset (Mark 06/17/05)
% updated to accomodate elevation txoffset (Mark, 2012-10-09)
% 2012.11.2 removed txoffset functionality and puts in rxoffsets and
% combined linear and phased modes. (Pete)

xdc_center_focus(Tx,[x0t,y0t,z0t]);
%xdc_center_focus(Tx,[0 0 0]);

% The potential lateral offset of the beam is taken account in
% the xdf_focus() command below.
% Mark 06/17/05

focus_x= beamset(idx).tx_focus_range*sin(beamset(idx).directionx(vectorx))+x0t;
focus_y= beamset(idx).tx_focus_range*sin(beamset(idx).directiony(vectory))+y0t;
focus_z= beamset(idx).tx_focus_range*cos(beamset(idx).directionx(vectorx))*cos(beamset(idx).directiony(vectory));

xdc_focus(Tx,0,[focus_x focus_y focus_z]);

[position_x position_y] = meshgrid(element_position_x,element_position_y);

dly = (1/geometry.c)*sqrt((focus_x-position_x).^2 + (focus_y-position_y).^2 + focus_z.^2);
dly = dly + (1/geometry.c)*sqrt((focus_x-x0t).^2+(focus_y-y0t).^2+(focus_z-z0t).^2);
dly = (-1).^(beamset(idx).tx_focus_range>0).*dly;
if beamset(idx).tx_focus_range>0
toffset = max(dly(:));
%dly = dly-max(dly(:));
else
toffset = min(dly(:));
%dly = dly-min(dly(:));
end

xdc_times_focus(Tx,-inf,reshape(dly',1,[]));


% txoffset (Mark 06/17/05)
% updated to accomodate elevation txoffset (Mark, 2012-10-09)
% updated to remove elevation txoffset (Pete, 2012.11.2)
%xdc_focus(Tx,-inf,[focus_x focus_y focus_z]); % Transmit focal point


% Tx Apodization
tx_width=abs(beamset(idx).tx_focus_range)/beamset(idx).tx_f_num(1);

% txoffset (Mark 06/21/05)
% specified lateral toffset (Mark, 2012-10-09)
% removed lateral txoffset (Pete, 2012.11.2)
tx_ap_left_limit =-tx_width/2+x0t;
tx_ap_right_limit= tx_width/2+x0t;
tx_apodization_x= double((element_position_x>tx_ap_left_limit) & (element_position_x<tx_ap_right_limit));
if (beamset(idx).tx_apod_type==1) % If using a hamming window for the tx apodization,
    % txoffset (Mark 06/21/05)
    tx_apodization_x=tx_apodization_x.*(0.54+0.46*cos(2*pi*(element_position_x-x0t)/tx_width));
end;

if length(beamset(idx).tx_f_num) == 1
    beamset(idx).tx_f_num(2) = beamset(idx).tx_f_num(1);
end

tx_height=abs(beamset(idx).tx_focus_range)/beamset(idx).tx_f_num(2);

% Pete (2012.11.14)
tx_ap_bottom_limit =-tx_height/2+y0t;
tx_ap_top_limit= tx_height/2+y0t;
tx_apodization_y= double((element_position_y>tx_ap_bottom_limit) & (element_position_y<tx_ap_top_limit));
if (beamset(idx).tx_apod_type==1) % If using a hamming window for the tx apodization,
    % txoffset (Mark 06/21/05)
    tx_apodization_y=tx_apodization_y.*(0.54+0.46*cos(2*pi*(element_position_y-y0t)/tx_height));
end;

[Apx Apy] = meshgrid(tx_apodization_x,tx_apodization_y);
tx_apodization = Apx.*Apy;

if(~(strcmp(geometry.probe_type,'matrix'))),
    xdc_apodization(Tx,0,tx_apodization);
else,
    warning('Apodization not supported for matrix probes; no Tx apodization applied.');
end;

% Settings for receive aperture:
if ~exist('pvector','var')
    pvector = 1;
end

%Removed image mode check. Linear and Phased modes shouldn't differ as 
%beams are explicitly specified by apex, origin, and angle(Pete 2012.11.2)

x0r = beamset(idx).originx(vectorx)+beamset(idx).rx_offset(vectorp,1)-beamset(idx).apex*(tan(beamset(idx).directionx(vectorx)+beamset(idx).rx_offset(vectorp,3)));
y0r = beamset(idx).originy(vectory)+beamset(idx).rx_offset(vectorp,2)-beamset(idx).apex*(tan(beamset(idx).directiony(vectory)+beamset(idx).rx_offset(vectorp,4)));
z0r = 0;
theta =  beamset(idx).directionx(vectorx)+beamset(idx).rx_offset(vectorp,3);
phi = beamset(idx).directiony(vectory)+beamset(idx).rx_offset(vectorp,4);

xdc_center_focus(Rx,[x0r y0r z0r]);
    
% Added || RX offset functionality (Pete 2012.11.2)
if (beamset(idx).is_dyn_focus),  % If dynamic receive focus mode
       xdc_dynamic_focus(Rx,-inf,theta,phi); %set dyn foc
else % otherwise setup the fixed receive focus:
    focus_x = x0r+beamset(idx).rx_focus_range*sin(theta)+beamset(idx).rx_offset(vectorp,1);
    focus_y = y0r+beamset(idx).rx_focus_range*sin(phi)+beamset(idx).rx_offset(vectorp,4);
    focus_z = beamset(idx).rx_focus_range*cos(theta)*cos(phi);
    xdc_focus(Rx,-inf,[focus_x focus_y focus_z]); % Receive fixed focal point
end; 

if debug_fig
 figure(3);
 if vectorx==1 && vectory==1 && vectorp==1
   clf;hold all
    for ii = 1:geometry.no_elements_x
        for jj = 1:geometry.no_elements_y
            p(jj,ii) = patch(1e3*(element_position_x(ii) + [-0.5 0.5 0.5 -0.5]*geometry.width_x),[0 0 0 0],1e3*(element_position_y(jj) + [-0.5 -0.5 0.5 0.5]*geometry.width_y),'m','edgecolor','none');
        end
    end 
    xlabel('x (mm)')
    ylabel('z (mm)')
    zlabel('y (mm)')    
    axis image
    axis ij
    hold all
    plot3(0,1e3*beamset.apex,0,'b*','MarkerSize',10)
    end
k = get(gca,'children');
k = k(end-[0:geometry.no_elements_x*geometry.no_elements_y-1]);
k = reshape(k,geometry.no_elements_y,geometry.no_elements_x);
jett = jet(256);
for ii = 1:geometry.no_elements_x
        for jj = 1:geometry.no_elements_y
            set(k(jj,ii),'FaceColor',jett(floor(tx_apodization(jj,ii)*255)+1,:));
        end
end 
if beamset(idx).rx_focus_range>0
    rvec = [0:10e-3:beamset(idx).rx_focus_range];
elseif beamset(idx).tx_focus_range>0
    rvec = [0:10e-3:1.5*beamset(idx).tx_focus_range];
else
    rvec = [0:10e-3:40e-3];
end
plot3(1e3*[focus_x x0r + rvec*sin(theta)],1e3*[focus_z z0r+rvec*cos(theta)*cos(phi)],1e3*[focus_y y0r+rvec*sin(phi)],'o-');
axis image
view(3);
drawnow;
end

% Rx Apodization

% pitch=geometry.width+geometry.kerf_x;
% element_position_x=(0.5+(0:(geometry.no_elements_x-1)))*pitch-offset_X;

for n=1:512,
    ap_times(n,1)=2*beamset(idx).rx_f_num(1)*pitch*(n-1)/SPEED_OF_SOUND;

    rx_width=n*pitch;
    
%Added lateral || rx offset (Pete, 2012.11.2)
    rx_ap_left_limit =-rx_width/2+x0r;
    rx_ap_right_limit= rx_width/2+x0r;;

    rx_apodization(n,:)= double((element_position_x>=rx_ap_left_limit) & ...
        (element_position_x<=rx_ap_right_limit));
    if ~any(rx_apodization(n,:))
        if rx_ap_left_limit>element_position_x(end)
        rx_apodization(n,end) = 1;
        elseif rx_ap_right_limit<element_position_x(1)
        rx_apodization(n,1) = 1;
        end
    end

    if (beamset(idx).rx_apod_type==1) % If using a hamming window
        rx_apodization(n,:)=rx_apodization(n,:).*(0.54+0.46*cos(2*pi*...
            (element_position_x-x0r)/rx_width));
    end;
end;

if(~(strcmp(geometry.probe_type,'matrix'))),
    xdc_apodization(Rx,ap_times,rx_apodization)
else,
    warning('Apodization not supported for matrix probes; no Rx apodization applied.');
end;
