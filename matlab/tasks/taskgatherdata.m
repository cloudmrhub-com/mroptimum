function[SNR,SNRFA,GF,UGF,SENSITIVITIES,STD]=taskgatherdata(O)

SNR=[];SNRFA=[];GF=[];UGF=[];SENSITIVITIES=[];STD=[];

for (sl=1:numel(O))
        
        if(isfield(O,'SNR'))
            SNR(:,:,sl)=fixalo____qui(O(sl).SNR);
        end
        
        if(isfield(O,'SNRFA'))
            SNRFA(:,:,sl)=fixalo____qui(O(sl).SNRFA);
        end
        
                 if(isfield(O,'STD'))
            STD(:,:,sl)=fixalo____qui(O(sl).STD);
        end
        
        
        
        
        if(isfield(O,'GF'))
            GF(:,:,sl)=fixalo____qui(O(sl).GF);
        end
        
        if(isfield(O,'UGF'))
            UGF(:,:,sl)=fixalo____qui(O(sl).UGF);
        end
        
        if(isfield(O,'S'))
            SENSITIVITIES(:,:,sl,:)=fixalo____qui(O(sl).S);
        end
end
    

end

function O=fixalo____qui(O)
O(isnan(O))=0;
O(isinf(O))=0;
end