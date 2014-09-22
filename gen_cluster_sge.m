function sgefilename = gen_cluster_sge(Function_Name, Max_Index, UniqueID, Memory_Limit)
% function sgefilename = gen_cluster_sge(Function_Name, Max_Index, UniqueID, Memory_Limit)

fid = fopen('cluster_template.sge', 'rt');
s = fread(fid);
fclose(fid);

if ~exist('UniqueID','var'),
    [pth UniqueID] = fileparts(tempname('.'));
end

if ~exist('Memory_Limit','var'),
    Memory_Limit = 8; % GB
end

s1 = strrep(char(s'),'MAX_INDEX',num2str(Max_Index));
s1 = strrep(s1,'MEMORY_LIMIT',num2str(Memory_Limit));
s1 = strrep(s1,'UNIQUEID',UniqueID);
s1 = strrep(s1,'FUNCTION_NAME',Function_Name);

s2 = double(s1)';
sgefilename = sprintf('%s_SGE.sge',UniqueID);
fid = fopen(sgefilename,'wt');
fwrite(fid,s2);
fclose(fid);
