function [noiseimage, smoothedimage]=SISsmoothedImageMeanconvolution(im,k)
%N=SISsmoothedImage(im,r,k)
%image is a 2d image, r is an array of indexes k is the box side
im=double(im);
%pad the image

h = fspecial('average',(2*k)+1);

 for s=1:size(im,3)
 smoothedimage(:,:,s) = imfilter(im(:,:,s), h, 'replicate'); % Get means. 
 end
 
 noiseimage=im-smoothedimage;
 
 
 
 
 

