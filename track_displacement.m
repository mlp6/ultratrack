%TRACK_DIR=[make_file_name([RF_DIR 'track'],TRACKPARAMS) '/'];
%mkdir(TRACK_DIR); %matlab 7

%% load all RF into a big matrix
%n=1;

%while ~isempty(dir(sprintf('%s%03d.mat',RF_FILE,n)))
%    load(sprintf('%s%03d.mat',RF_FILE,n));
%    % some rf*.mat files are off by one axial index; allowing for some PARAMS.YSTEPnamic
%    % assignment of bigRF matrix
%    % bigRF(:,:,n)=rf;
%    bigRF(1:size(rf,1),:,n)=rf;
%    n=n+1;
%end;

%% track the displacements
%%[D,C]=estimate_disp(bigRF,TRACKPARAMS.TRACK_ALG,TRACKPARAMS.KERNEL_SAMPLES);
%[D,C]=estimate_disp(bigRF,TRACKPARAMS);

%% save res_tracksim.mat (same format as experimental res*.mat files)
%track_save_path = pwd;
%createtrackres(C,D,PARAMS,PPARAMS,PHANTOM_FILE,RF_FILE,TRACKPARAMS,TRACK_DIR);
