function [node_loc,X,Y,Z] = read_dot_dyn(fname);

% function [nodes,X,Y,Z] = read_dot_dyn(fname);                     
%
% UPDATE THIS DESCRIPTION!!  
%
% read_dot_dyn reads a .dyn file and returns 4 3D matricies
% nodes is matrix of node numbers
% X,Y,Z are matricies of X, Y, and Z node locations (initial)
%
% These matricies are part of the input to scat_and_disp.m
%
%
% fname is the name of your .dyn file
%
% 
% Builds upon read_dyna_nodes.m
% Last modified 10/18/04 Stephen McAleavey, U. Rochester BME
%
 

endofline=sprintf('\n');
  
% Load grid data
  
% Open file
fid=fopen(fname,'r');
if (fid == -1),
	disp(['Can''t open ' fname]);
	return;
	end;


 
% find last word just before data... 
s=fscanf(fid,'%s',1);
while (~strcmp(s,'*NODE')),
	s=fscanf(fid,'%s',1);
	end;

% Find start of next line...        
c=fscanf(fid,'%c',1);
while(c~=endofline);
	c=fscanf(fid,'%c',1);
	end;
% Suck in data...  
[node_loc,count]=fscanf(fid,'%d %f %f %f',[4,inf]);
node_loc=node_loc';
fclose(fid);

% All beyond here is new to rdn2 vs read_dyna_nodes

% Sort data in prepartion for formation of plaid 3D matricies
%
% This step generates matrix n2 which a "defuzzed" nodeloc
% the X,Y,Z components of X,Y,Z are truncated to TOL places after the 
% decimal.  The reason for this operation is to eliminate the 
% roundoff error differences between node coordinates (e.g. 1.499999
% is really 1.50000).  The "numerical fuzz" left behind by the float to 
% ascii conversion fouls up sorting and confounds the creation of plaid
% 3D matricies 
%

TOL=3; % One might calculate TOL from the data by finding the range of 
% X,Y,Z and selecting a thousandth of that, & TOL is log10 of 1/that

n2=node_loc;
n2(:,2:4)=round((10^TOL)*n2(:,2:4))/(10^TOL);
[n2,I]=sortrows(n2,[4 3 2]);

% node_loc now is sorted into the same order, preserving the orginal 
% (unrounded) values.

node_loc=node_loc(I,:);
node_loc=n2;

% figure out dimensions

zsum=sum(n2(:,4)==n2(1,4));
zdim=size(n2,1)/zsum;
ysum=sum(n2(1:zsum,3)==n2(1,3));
ydim=zsum/ysum;
xsum=sum(n2(1:ysum,2)==n2(1,2));
xdim=ysum/xsum;
                                                                          
% create outputs by reshaping node_loc

X=reshape(node_loc(:,2),xdim,ydim,zdim);
Y=reshape(node_loc(:,3),xdim,ydim,zdim);
Z=reshape(node_loc(:,4),xdim,ydim,zdim);
node_loc=reshape(node_loc(:,1),xdim,ydim,zdim);



