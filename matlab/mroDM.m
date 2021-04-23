function [SNR] = mroDM(im,roi,backgroundroi)
%Direct measurement
%method 4 from:
%[1] A. J. McCann, A. Workman, and C. McGrath, “A quick and robust method for measurement of signal-to-noise ratio in MRI,” Phys. Med. Biol., vol. 58, no. 11, pp. 3775–3790, 2013.
%ndimensional image and roi are the indexes of the foreground, backround is
%a 2d matrix with for each columen the indexes of the background ROI at
%least 4
%%background roi is an arrai of rois
%

%check if this are indexes or masks
if numel(size(roi))>1
    r=find(roi);
else
    r=roi;
end

%background roi counter


im=abs(im);
S=nanmean(im(r));


for b=[1:size(backgroundroi,2)]
    br=backgroundroi(:,b);
n(b)=nanstd(im(br));
end

%correction factor (≈0.655) for background noise (Rician distribution).
% from [1] A. J. McCann, A. Workman, and C. McGrath, “A quick and robust method for measurement of signal-to-noise ratio in MRI,” Phys. Med. Biol., vol. 58, no. 11, pp. 3775–3790, 2013.
correction=0.655;

SNR=correction*S/nanmean(n);











S=nanmean(vim1);



end

