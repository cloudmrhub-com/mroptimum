function OUTPUTCLASS=  MRtask(signalfilename,noisefilename,jop,resultfilename,logfilename,QSRVR)
%signal name its an array of data
%v25022020
warning('off');
addpath(genpath('../MATLABCODE/'));

[TMP,~,~]=fileparts(resultfilename);


%this will bethe output class
OUTPUTCLASS=cmOutput();
OUTPUTCLASS.setTypeOutput('MR');

try
    %%read options and instantiate the output class
    %    signalfilename is set to empty because we are going to set the kspace data for each replicas
    [S,o,RECONCLASS,KSN,SOURCESENS,FA]=taskdataloader([],noisefilename, jop,QSRVR);
    %this call of taskdataloader has 2 differences:
    % the outclass is called reconclass
    %the signal is set to empty
    if (isempty(SOURCESENS))
        isbodycoil=0;
    else
        isbodycoil=1;
    end
    
    
    
    %for all the images in the array, recontruct the images for every rep and every slice
    thenumberofreplicas=0;
    for ks=1:numel(signalfilename)
        
        
        %this is to get the correct starting point of the imagestack
        %everytime i am putting a new slice/repetitions from different
        %files
        if exist('theimagestack','var')
            thenumberofreplicas=size(theimagestack,4);
        end
        %that's the file we are workking on
        thefilename=signalfilename{ks};
        
        %         clear and instantiate the reader class
        clear S;
        
        if ischar(thefilename)
            S=cm2DRawDataReader(thefilename);
            %for log porpuses
            [oo,oi,op]=fileparts(thefilename);
            RECONCLASS.logIt([' image ' oi op ' is going to be processed'] ,'ok');
        else
            S=cm2DRawDataReader();
            S.setcm2DRawDataReaderImageKSpaceFrom2DSlice(thefilename,1,1,1);
        end
        
        
        
        
        
        
        %for all the slices
        for sl=1:S.getNumberImageSlices()
            
            rep=S.getNumberRepetition();
            startreplicas=thenumberofreplicas;
            
            for r=1:rep
                %this is a 2D kspace
                KSS=S.getRawDataImageKSpaceSlice('avg',1,r,sl);
                
                
                
                if RECONCLASS.needsSensitivity()
                    
                    if isbodycoil
                        
                        try
                            %get from the replica otherwise take from the first replica
                            KSENS=SOURCESENS.getKSpaceImageSlice('avg',1,r,sl);
                        catch
                            KSENS=SOURCESENS.getKSpaceImageSlice('avg',1,1,sl);
                        end
                    else
                        KSENS=SOURCESENS.getRawDataImageKSpaceSlice('avg',1,1,sl);
                        
                    end
                else
                    KSENS=[];
                end
                
                
                
                
                [O, reconworkerclass]=RECONWORKER(KSS,KSN,o,KSENS,FA,['slice number # ' num2str(sl) ' rep number # ' num2str(startreplicas+r)]);
                OUTPUTCLASS.appendLog(reconworkerclass.getLog());
                theimagestack(:,:,sl,startreplicas+r)=O.Image;
            end
            %             actually get the image
            
            
        end
    end
    OUTPUTCLASS.setOutputFileName(resultfilename);
    OUTPUTCLASS.setOutputLogFileName(logfilename);
    
    [O,OUTPUTCLASS]=MRWORKER(theimagestack,OUTPUTCLASS);
    
    %data are exported inside the worer
    
    fprintf(1,'done!\n\n');
catch
    
    if ~exist('OUTPUTCLASS','var')
        OUTPUTCLASS=CLOUDMROutput();
    end
    OUTPUTCLASS.outputError(logfilename);
    
    
    
    
end

end

% 
% function O=fixalo____qui(O)
% O(isnan(O))=0;
% O(isinf(O))=0;
% end
