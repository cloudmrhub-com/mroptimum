function [OUT]=mr_optimum_example()
load CONF.mat
somedefine


%addpath(genpath('/home/montie01/Dropbox/offline/toolboxematlab2'))
addpath(genpath('/data/project/mroptimum/MATLABCODE/'))
addpath(genpath('..'))

PT='/data/MYDATA/SNR_rawdata_examples/2018-07-31_BRAINO_scan'; %where you want to store the data

signalname{1}=downloadfromcloudmr(PT,'meas_MID02317_FID373207_AXIAL_2D_GRE_1SL.dat');
signalname{2}=downloadfromcloudmr(PT,'meas_MID02322_FID373212_AXIAL_2D_GRE_1SL_REDO.dat');
noisename=downloadfromcloudmr(PT,'meas_MID02320_FID373210_AXIAL_2D_GRE_1SL_NOISE.dat');

  
%   for m=1:8
            m=2; %rss
      clear o;
      optionname=[];
            o=mro2DReconGetDefaultOptionsForType(METHODS(m).MRtype);
            if ~isempty(METHODS(m).ACCF)
                o.AccelerationP=METHODS(m).ACCF;
                o.Autocalibration=METHODS(m).AC;
            end
            OUT=mr_optimumexample_worker(signalname,noisename,optionname,o,100,9);
            
%   end
        




end





function out=downloadfromcloudmr(PT,filename)
filelink=fullfile('http://cloudmrhub.com/RESOURCES',filename);
out=fullfile(PT,filename);
if(~(exist(out,'file')))
    websave(filename,filelink);
end
    
end