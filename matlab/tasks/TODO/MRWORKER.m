function [O,OUTPUTCLASS]=MRWORKER(imageReplicas,OUTPUTCLASS)
%imageReplicas of 2Dimages (x,y,z,nrep)  OUTPUTCLASS
%MRWORKER(SS,FA,'you can do it baby!') 
%OUT.SNR
%OUT.SNRFA
%v25022020



try

O.MR=[];
for sl=1:size(imageReplicas,3) %for every slice
    for rep=1:size(imageReplicas,4)
        IM=squeeze(imageReplicas(:,:,sl,rep));
        O.MR=cat(1,O.MR, {CLOUDMR2DMR()});
         O.MR{sl}.add2DImage(double(IM)); 
    end
          O.SNR(:,:,sl)=O.MR{sl}.getSNR();
            O.STD(:,:,sl)=O.MR{sl}.getSTD();
            O.MEAN(:,:,sl)=O.MR{sl}.getMEAN();
end

    OUTPUTCLASS.addToExporter('image2D','SNR Map',fixalo____qui(O.SNR));
    OUTPUTCLASS.addToExporter('image2D','Mean Image ',fixalo____qui(O.MEAN));
    OUTPUTCLASS.addToExporter('image2D','Std Image',fixalo____qui(O.STD));
    
    
    
    
catch
    
end

%write results (Exporter)
    OUTPUTCLASS.exportResults();
   
%export log
    OUTPUTCLASS.logIT('stop calculation','stop');
    OUTPUTCLASS.exportLOG();
    
    
    
    

end

    function O=fixalo____qui(O)
        O(isnan(O))=0;
        O(isinf(O))=0;
    end
