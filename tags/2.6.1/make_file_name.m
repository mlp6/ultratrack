function [name]=make_file_name(name_root,PARAMS);

name=name_root;

s=fieldnames(PARAMS);

for n=1:length(s),
	datum=eval(['PARAMS.' s{n}]);
	if isnumeric(datum) 
		name=[name '_' s{n} sprintf('_%g',datum)];
	else
		name=[name '_' s{n} sprintf('_%s',datum)];
	end;
end;



