function [SNR] = mroSIS(im,roi,k,type)
%mroSIS(im,roi,k,type)
%type 1 smoothing image is calculated as described in the paper [1]
%type 2 smoothing image is calculated with a convolution with a real
%average filter ones(k)/(k)^2
%image, roi (indexes or mask), k is kenelsize
%%Smoothed Signal Subtraction
%method 6 from:
%[1] A. J. McCann, A. Workman, and C. McGrath, “A quick and robust method for measurement of signal-to-noise ratio in MRI,” Phys. Med. Biol., vol. 58, no. 11, pp. 3775–3790, 2013.
%ndimensional image and roi are the indexes of the foreground, backround is
%a 2d matrix with for each columen the indexes of the background ROI at
%least 4
%%background roi is an arrai of rois
%

if ~exist('type','var')
    type=1;
end

sr=size(roi);
%check if this are indexes or masks
if numel(sr)>1 && sr(2)>1 
    r=find(roi);
else
    r=roi;
end

%background roi counter

%im=abs(im);
S=nanmean(im(r));

switch (type)
    case 1
noiseimage=SISsmoothedImage(im,k);
    case {2}
noiseimage=SISsmoothedImageMeanconvolution(im,k);
end
%no correction apperently
correction=1;

N=nanstd(noiseimage(r));
SNR=correction*S/N;

end

