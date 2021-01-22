function [O,OUTPUTCLASS]=MRWORKER(imageReplicas,OUTPUTCLASS)
%imageReplicas of 2Dimages (x,y,z,nrep)  OUTPUTCLASS
%MRWORKER(SS,FA) 
%v25022020



try

for sl=1:size(imageReplicas,3) %for every slice
  
        IM=squeeze(imageReplicas(:,:,sl,:));
        MR=cm2DSignalToNoiseRatioMultipleReplicas(IM);
        O.SNR(:,:,sl)=MR.getSNR();
        O.STD(:,:,sl)=MR.getSTD();
        O.MEAN(:,:,sl)=MR.getMEAN();
end

 
        
catch
    
end

   OUTPUTCLASS.add2DImagetoExport(fixalo____qui(O.SNR),'SNR Map');
    OUTPUTCLASS.add2DImagetoExport(fixalo____qui(O.MEAN),'Mean Image');
    OUTPUTCLASS.add2DImagetoExport(fixalo____qui(O.STD),'Std Image');

%write results (Exporter)
    OUTPUTCLASS.exportResults();
   
%export log
    OUTPUTCLASS.logIt('stop calculation','stop');
    OUTPUTCLASS.exportLog();
       
    
    

end

    function O=fixalo____qui(O)
        O(isnan(O))=0;
        O(isinf(O))=0;
    end
