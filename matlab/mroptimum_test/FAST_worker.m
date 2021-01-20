function [SNR]=FAST_worker(thedata,nr,box,RANDOMFLAG)
%4d matric freq,phase,slice,rep, nreplica used and box, number of replicas,
%box


[NC,NR,NSL,REP]=size(thedata);
% BOX=2:92;


if ~exist('RANDOMFLAG','var')
    RANDOMFLAG=true;
end

kx=box;
ky=box;
NOISE=nan(NC,NR,NSL);
        
        
               
            a=tic();
            if RANDOMFLAG
           % thereplicas=datasample([1:REP],nr);
            RR=datasample([1:(REP-1)],1);
            thereplicas=[RR RR+1];
            else
                thereplicas=[1:nr];
            end
                
            %compute noise only
            noiseonly=diff(thedata(:,:,:,thereplicas),1,4);
            
            for sl=1:NSL
                THESLICE=squeeze(noiseonly(:,:,sl,:));
                PADDEDNOISE = padarray(THESLICE,[kx ky],NaN);
                for ic=1:NC
                    for ir=1:NR
                        pic=kx+ic+[-kx:kx];
                        pir=ky+ir+[-ky:ky];
                        try
                            NOISE(ic,ir,sl)=nanstd(reshape(PADDEDNOISE(pic,pir,:),[],1));
                        catch
                            
                        end
                    end
                end
            end
            
            SNR=mean(thedata(:,:,:,thereplicas),4)./NOISE;
            
    
end



