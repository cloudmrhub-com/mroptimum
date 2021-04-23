function [SNR] = mroDIPrice(im1,im2,roi,index)
%ndimensional im1, im2 and roi should be of the same dimension
%
%

if nargin<4
r=find(roi);
else
    r=index;
end
vim1=reshape(abs(im1(r)),[],1);
vim2=reshape(abs(im2(r)),[],1);

S=nanmean(nanmean(cat(2,vim1,vim2),2));
N=(sqrt(2)*nanstd(vim1-vim2));
SNR=S./N;

end

