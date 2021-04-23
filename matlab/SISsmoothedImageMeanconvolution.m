function N=SISsmoothedImageMeanconvolution(im,r,k)
%N=SISsmoothedImage(im,r,k)
%image is a 2d image, r is an array of indexes k is the box side
im=double(im);
%pad the image

 kernel = ones(k)/(K^2); % Create averaging window.

 smoothedimage = conv2(im, kernel, 'same'); % Get means. 
  
 noise=im-smoothedimage;
 
N=nanstd(noise(r));
 
 
 
 

