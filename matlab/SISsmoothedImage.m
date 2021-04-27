function [noiseimage, smoothedimage]=SISsmoothedImage(im,k)
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

for s=1:size(im,3)

 for ic=1:NC
                    for ir=1:NR
                        pic=kx+ic+[-kx:kx];
                        pir=ky+ir+[-ky:ky];
                        
%                         try
%                             smoothedimage(ic,ir,s)=nansum(reshape(PADDEDIMAGE(pic,pir,s),[],1))/divisor;
%                         catch
%                             
%                         end

                    n=0.0;
                        for ttr=pir
                            
                                                    for ttc=pic
                            n=n+PADDEDIMAGE(ttc,ttr,s);
                        end

                        end
                        
                         smoothedimage(ic,ir,s)=n/divisor;
                    
                    end
 end
 
end 
 
 

 
 
 
noiseimage=im-smoothedimage;
 
 
 
 
 

