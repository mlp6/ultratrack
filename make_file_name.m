function [name]=make_file_name(type, name_root, PARAMS);
% function [name]=make_file_name(type, name_root, PARAMS);
% 
% INPUTS:   type (string) - 'phantom', 'rf'
%           name_root (string)
%           PARAMS (struct) - type-specific parameters
%
% OUTPUTS:  name (string) - sim-specific directory name
%

name=name_root;

switch type
    case 'phantom'
        P = rmfield(PARAMS,{'TIMESTEP'});
        if isfield(PARAMS,'pointscatterers'),
            P = rmfield(P,'pointscatterers');
        end
        P.X = sprintf('%g_%g',10*P.ymin,10*P.ymax);
        P.Y = sprintf('%g_%g',10*P.xmin,10*P.xmax);
        P.Z = sprintf('%g_%g',-10*P.zmax,-10*P.zmin);
        P = rmfield(P,{'xmin','xmax','ymin','ymax','zmin','zmax'});
    case 'rf'
        P = rmfield(PARAMS,{'RXOFFSET','BEAM_ORIGIN_X','BEAM_ORIGIN_Y','BEAM_ANGLE_X','BEAM_ANGLE_Y','COMPUTATIONMETHOD'});
        P.X = sprintf('%g_%g_%g',1e3*P.XMIN,1e3*P.XSTEP,1e3*P.XMAX);
        P.Y = sprintf('%g_%g_%g',1e3*P.YMIN,1e3*P.YSTEP,1e3*P.YMAX);
        P.PHI = sprintf('%g_%g_%g',P.PHIMIN,P.PHISTEP,P.PHIMAX);
        P.THETA = sprintf('%g_%g_%g',P.THMIN,P.THSTEP,P.THMAX);
        P = rmfield(P,{'XMIN','XMAX','XSTEP','YMIN','YMAX','YSTEP','PHIMIN','PHIMAX','PHISTEP','THMIN','THSTEP','THMAX'});
        P.NO_BEAMS = sprintf('%g_%g',P.NO_BEAMS_X,P.NO_BEAMS_Y);
        P = rmfield(P,{'NO_BEAMS_X','NO_BEAMS_Y'});
        P.NPAR = sprintf('%g_%g',P.NO_PARALLEL(1),P.NO_PARALLEL(2));
        P.PSPACE = sprintf('%g_%g',P.PARALLEL_SPACING(1),P.PARALLEL_SPACING(2));
        P = rmfield(P,{'NO_PARALLEL','PARALLEL_SPACING'});
        P.APEX = sprintf('%g',1e3*P.APEX);
        P.TX_FOCUS = sprintf('%g',1e3*P.TX_FOCUS);
        P.TX_FREQ = sprintf('%g',1e-6*P.TX_FREQ);
        P.FS = sprintf('%g',1e-6*P.field_sample_freq);
        P = rmfield(P,'field_sample_freq');
        P.RX_FOCUS = sprintf('%g',1e3*P.RX_FOCUS);
        P.TX_F_NUM = sprintf('%g_%g',P.TX_F_NUM(1),P.TX_F_NUM(2));
        P.RX_F_NUM = sprintf('%g_%g',P.RX_F_NUM(1),P.RX_F_NUM(2));
        P.GRID = sprintf('%g_%g_%g',1e3*P.GRIDSPACING(1),1e3*P.GRIDSPACING(2),1e3*P.GRIDSPACING(3));
        P = rmfield(P,'GRIDSPACING');
end

s=fieldnames(P);

for n=1:length(s),
	datum=eval(['P.' s{n}]);
	if isnumeric(datum) 
		name=[name '_' s{n} sprintf('_%g',datum)];
	else
		name=[name '_' s{n} sprintf('_%s',datum)];
	end;
end;
