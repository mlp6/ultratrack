function varargout=uisave(variables, filename)
%UISAVE GUI Helper function for SAVE
%
%   See also SAVE, LOAD, UILOAD
  
% Copyright 1984-2002 The MathWorks, Inc.
% $Revision: 1.12 $  $Date: 2002/04/09 01:36:15 $

whooutput = evalin('caller','who','');
if isempty(whooutput)
  errordlg('No variables to save')
  return;
end

if nargin == 0
  variables = whooutput;
end

if nargin < 2
  if length(whooutput) > 1
    seed = {'*.mat','MAT-files (*.mat)'};
  else
    seed = {'*.mat','MAT-files (*.mat)'
	    '*.txt','ASCII-files (*.txt)'};
  end
else
  seed = filename;
end

if ~iscellstr(variables) & ~ischar(whooutput) 
  error('VARIABLES argument must be a string or cell array of strings');
end

if iscell(variables)
  variables = sprintf('''%s'',',variables{:});
  variables = variables(1:end - 1);
end

[fn,pn,filterindex] = uiputfile(seed, 'Save Workspace Variables');

if ~all(pn == 0) & ~all(fn == 0)
  try
    fn = strrep(fullfile(pn,fn), '''', '''''');
    sz = size(seed);
    if (filterindex <= sz(1) & findstr(seed{filterindex}, '.mat'))
      evalin('caller',['save(''' fn  ''', ' variables ');'], 'error(lasterr)');
    elseif (filterindex <= sz(1) & findstr(seed{filterindex}, '.txt'))
      evalin('caller',['save(''' fn  ''', ' variables ', ''-ASCII'');'], 'error(lasterr)');
    else
      evalin('caller',['save(''' fn  ''', ' variables ');'], 'error(lasterr)');
    end
  catch
    errordlg(lasterr)
  end
end

if nargout>0,
    varargout{1}=fn;
end;

    