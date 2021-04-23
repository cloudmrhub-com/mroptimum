function N=SISsmoothedImage(im,r,k)
%N=SISsmoothedImage(im,r,k)
%image is a 2d image, r is an array of indexes k is the box side
im=double(im);
%pad the image
PADDEDIMAGE = padarray(im,[k k],NaN);

divisor=(((2*k)+1))^2;
imsize=size(im);
NC=imsize(1);
NR=imsize(2);
N=0;

kx=k;
ky=k;

 for ic=1:NC
                    for ir=1:NR
                        pic=kx+ic+[-kx:kx];
                        pir=ky+ir+[-ky:ky];
                        try
                            smoothedimage(ic,ir)=nansum(reshape(PADDEDIMAGE(pic,pir),[],1))/divisor;
                        catch
                            
                        end
                    end
 end
 
 
 
 

 
 
 
 noise=im-smoothedimage;
 
N=nanstd(noise(r));
 
 
 
 

