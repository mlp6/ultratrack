functionDir = fileparts(which(mfilename));
probesPath = fullfile(functionDir, 'probes/ultratrack');
check_add_probes(probesPath);
codePath = fullfile(functionDir, 'code');
check_add_probes(codePath);

