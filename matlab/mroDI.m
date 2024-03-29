function [SNR] = mroDI(im1,im2,roi,index)
%ndimensional im1, im2 and roi should be of the same dimension
%
%

if nargin<4
r=find(roi);
else
    r=index;
end
vim1=abs(im1(r));
vim2=abs(im2(r));

S=nanmean(vim1+vim2);
N=(sqrt(2)*nanstd(vim1-vim2));
SNR=S./N;

end

