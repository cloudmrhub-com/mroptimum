function [SNR]=MR_worker(reconstack)
%4d matric freq,phase,slice,rep, roi defined on the stack of data

DATA=reconstack;
NREP=size(DATA,4);

DATA(isnan(DATA))=eps;
SNR=mean(DATA,4)./std(DATA,0,4);
SNR(isnan(SNR))=0;
