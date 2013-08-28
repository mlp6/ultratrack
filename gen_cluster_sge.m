function sgefilename = gen_cluster_sge(Function_Name,Scratch_Dir,Ultratrack_Path,Max_Index,UniqueID,Memory_Limit)

fid = fopen('cluster_template.sge','rt');
s = fread(fid);
fclose(fid);
if ~exist('UniqueID','var')
[pth UniqueID] = fileparts(tempname('.'));
end
if ~exist('Memory_Limit','var')
Memory_Limit = 1048576;
end
s1 = strrep(char(s'),'MAX_INDEX',num2str(Max_Index));
s1 = strrep(s1,'MEMORY_LIMIT',num2str(Memory_Limit));
s1 = strrep(s1,'UNIQUEID',UniqueID);
s1 = strrep(s1,'FUNCTION_NAME',Function_Name);
%s1 = strrep(s1,'SCRATCHDIR',Scratch_Dir);
s1 = strrep(s1,'ULTRATRACK',Ultratrack_Path);

s2 = double(s1)';
sgefilename = sprintf('%s_SGE.sge',UniqueID);
fid = fopen(sgefilename,'wt');
fwrite(fid,s2);
fclose(fid);
