function [SNR] = mroDITIC(im1,im2,roi,index)
%2D im1, im2 and roi should be of the same dimension expect that will be
%ordered freq,phase
%3D to do
%ROi is a 0 in the background and one in the foreground 

if nargin<4
r=find(roi);
else
    r=index;
end


im1=abs(im1);
im2=abs(im2);

vim1=reshape(im1(r),[],1);
vim2=reshape(im2(r),[],1);

S=nanmean(nanmean(cat(2,vim1,vim2),2));

N=marksDiffenceofPixels(im1,im2,r);

SNR=sqrt(2)*S/N;


end

