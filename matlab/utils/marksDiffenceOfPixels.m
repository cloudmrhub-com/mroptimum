function[N]=marksDiffenceOfPixels(im1,im2,r)
% two images and a roi as index
N=(im1-im2);


imsize=size(N);
%mark difference of pixel with the markdistance
markDistance=[1 1];
%so we need to pad the array in that direction usin nan so nothing enter in
%the nanmean
p_markDistance=padarray(N,markDistance,NaN);
%and then remove the first part of the padding since we are interested oly
%in the positive distance
p_markDistance(1:markDistance(1),:)=[];
p_markDistance(:,1:markDistance(2))=[];
%now th size of p_markDistance is size(s)+markDistance

%for all indexes
N1=0;

for p=1:numel(r)
        theindex=r(p);
        [I,J] = ind2sub(imsize,theindex);
        n=((N(I+markDistance(1),J+markDistance(2))-N(I,J))^2);
        if(~isnan(n))
            N1=N1+n;
        end
end
        
N2=2*numel(r);
N=sqrt(N1/N2);