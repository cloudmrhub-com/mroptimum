% I want to understand if the noise that i use for the puclication affect
% the calculated SNR!!

S=load('rss.mat');

noise='/data/MYDATA/TestSNR_15Apr2019_multislice/RAWDATA/meas_MID00027_FID188181_Multislice_no_RF.dat';

%  one noise slice
 image_obj = mapVBVD(noise);
 kdata = image_obj.image();
     noiserawdata=[];
     for which_slice=3
     noiserawdata = cat(2,noiserawdata,permute(squeeze(kdata(:,:,:,:,which_slice,:,:,:,:,:,:,:,:,:,:,:)),[1,3,2])); % [nfreq nphase ncoil]
     end

%my reader;
N=cm2DRawDataReader();
N.setIsSignalFile(0);
N.setFilename(noise);
mynoise=N.getRawDataImageKSpaceSlice(1,1,1,3);


clear a;
%this is with only one slice of noise
a= cm2DKellmanRSS();
a.setSignalKSpace(S.signalrawdata);
% a.setNoiseKSpace(N.getRawDataImageKSpaceSlice(1,1,1,1));
a.setNoiseKSpace(noiserawdata);


clear b;
%this is with only one slice of noise
b= cm2DKellmanRSS();
b.setSignalKSpace(S.signalrawdata);
% a.setNoiseKSpace(N.getRawDataImageKSpaceSlice(1,1,1,1));
b.setNoiseKSpace(mynoise);

a.plotTwoImagesAfterTest(a.getOutput(), b.getOutput(),'mapnoise','mynoise');







% 
% 
% 
% 
% %the results of riccardo test
% 
% 
% 
% 
% NEEDCLASS=mro2DFromType(mro2DReconGetDefaultOptionsForType('rss'));
% NEEDCLASS.setNoiseKSpace(noiserawdata);
% NEEDCLASS.setSignalKSpace(S.signalrawdata);
% a.plotTwoImagesAfterTest(a.getOutput().*S.sensmask,NEEDCLASS.getSNR().*S.sensmask,'Eros'' recon','Riccardo''s recon');
% 
% 
% %% COMPARISON Multiple Replicas
% 
% a= cm2DKellmanRSS();
% a.setSignalKSpace(S.signalrawdata);
% % a.setNoiseKSpace(N.getRawDataImageKSpaceSlice(1,1,1,1));
% a.setNoiseKSpace();
% 
% a.plotTwoImagesAfterTest(a.getOutput().*S.sensmask,S.ac_rss_snr,'Eros'' recon','Riccardo''s recon');
% 
% 
