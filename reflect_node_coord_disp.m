function [Xr, Yr, Zr] = reflect_node_coord_disp(dtype, sym, X, Y, Z, debug);
% function [Xr, Yr, Zr] = reflect_node_coord_disp(dtype, sym, X, Y, Z, debug);
%
% reflect quarter and half symmetry mesh node coordinates for full volume
% scatterer simulations, assuming x = y = 0 at symmetry planes
%
% INPUTS:   dtype (string) - 'coord' or 'disp'; coordinate or displacement data 
%           sym (string) - 'q' (quarter), 'h' (half) symmetry
%           X (3D float) - node X coordinates
%           Y (3D float) - node Y coordinates
%           Z (3D float) - node Z coordinates
%           debug (logical) - generate figures to confirm proper symmetry
%                             reflection
%
% OUTPUTS:  Xr (3D float) - reflected X coordinates
%           Yr (3D float) - reflected Y coordinates
%           Zr (3D float) - reflected Z coordinates
%

if ~exist('debug', 'var'),
    debug = 0;
end;

if debug == 1,
    Xorig = reshape(X, [prod(size(X)), 1]);
    Yorig = reshape(Y, [prod(size(Y)), 1]);
    Zorig = reshape(Z, [prod(size(Z)), 1]);
    figure;
    hold on
    plot3(Xorig, Yorig, Zorig, 'ko');
end

switch dtype
    case 'coord'
        inv_sign = -1;
    case 'disp'
        inv_sign = 1;
end

switch sym
    case 'h'
        % flip in elevation (x, dim 1)
        % x should go neg -> 0, so leave out last entry
        Xr = cat(1, X, inv_sign*flipdim(X(1:end-1,:,:), 1));
        Yr = cat(1, Y, Y(1:end-1,:,:));
        Zr = cat(1, Z, Z(1:end-1,:,:));
    case 'q'
        % flip in elevation first (just like 'h')
        Xr = cat(1, X, inv_sign*flipdim(X(1:end-1,:,:), 1));
        Yr = cat(1, Y, flipdim(Y(1:end-1,:,:),1));
        Zr = cat(1, Z, flipdim(Z(1:end-1,:,:),1));

        % now flip laterally (y, dim 2)
        % y should go 0 -> pos, so leave out first entry
        Xr = cat(2, flipdim(Xr(:,2:end,:), 2), Xr);
        Yr = cat(2, inv_sign*flipdim(Yr(:,2:end,:), 2), Yr);
        Zr = cat(2, flipdim(Zr(:,2:end,:),2), Zr);
end

if debug == 1,
    Xnew = reshape(Xr, [prod(size(Xr)), 1]);
    Ynew = reshape(Yr, [prod(size(Yr)), 1]);
    Znew = reshape(Zr, [prod(size(Zr)), 1]);
    plot3(Xnew, Ynew, Znew, 'rx');
end

