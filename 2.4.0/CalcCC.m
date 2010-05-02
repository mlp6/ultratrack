function [CCmean,CCstd]=CalcCC
% function [CCmean]=CalcCC
% calculate the mean correlation coefficient in the focal zone
%
% Mark 01/23/05

load track.mat
CCmean = mean(C(2,2534:2664,3));
CCstd = std(C(2,2534:2664,3));
%CCmean = mean(C(2,200:3300,3));
%CCstd = std(C(2,200:3300,3));
