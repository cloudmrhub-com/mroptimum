%cloudmrclasses
addpath(genpath('/data/PROJECTS/CLOUDMR/CODE/CMRCode/matlab'))
%mroptimum
addpath(genpath('/data/PROJECTS/MROPTIMUM/CODE/MROCode/matlab'))





PT='/data/MYDATA/TestSNR_15Apr2019_multislice/RAWDATA';
themrfile=fullfile(PT,'meas_MID00036_FID188190_Multislice_100_REPLICAS.dat');
%A=cm2DRawDataReader(themrfile);
noisefilename=fullfile(PT,'meas_MID00027_FID188181_Multislice_no_RF.dat');
%N=cm2DRawDataReader(noisefilename);

signalfilename='/data/MYDATA/TestSNR_15Apr2019_multislice/RAWDATA/meas_MID00024_FID188178_Multislice.dat';
%S=cm2DRawDataReader(signalfilename);
