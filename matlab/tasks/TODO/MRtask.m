function OUTPUTCLASS=  MRtask(signalfilename,jop,resultfilename,logfilename,QSRVR)
%signal name its an array of data
%v25022020
warning('off');
addpath(genpath('../MATLABCODE/'));

[TMP,~,~]=fileparts(resultfilename);



OUTPUTCLASS=CLOUDMROutput();
OUTPUTCLASS.Type='MR';



try
    %%read options and instantiate the output class
    o=webread(jop);
    RECONCLASS=CLOUDMRgetclassfromOptions(o);
    
    try
        RECONCLASS.setConf(o);
    catch
        RECONCLASS.logIT(['problem with the conf' jop ],'ko');
    end
    
    isbodycoil=false;
    %% get the  BC if needed
    if (RECONCLASS.needsSensitivity())
        switch(lower(o.SensitivityCalculationMethod))
            case {'bodycoil'}
                temp =  java.util.UUID.randomUUID;
                myuuid = temp.toString;
                ID=o.SourceCoilSensitivityMap;
                a=webread([QSRVR '/getMROPTDATAinfoByIdGET.php?ID=' num2str(ID)]);
                [~,~,ext]=fileparts(a.response.externalfilename);
                bc=fullfile(TMP,[char(myuuid) ext]);
                urlwrite(a.response.externalfilename,bc);
                BC=CLOUDMRRD();
                BC.setFilename(bc);
                SOURCESENS=BC;
                %                 read it before deleting otherwise i'm loosing the file:)
                SOURCESENS.getKSpaceImageSlice(1,1,1,1);
                delete(bc);
                clear bc;
                isbodycoil=true;
                %             otherwise
                %                 SOURCESENS=S;
        end
        
        
    end
    
    
    %% FA?
    try
        if (RECONCLASS.faCorrection)
            temp =  java.util.UUID.randomUUID;
            myuuid = temp.toString;
            ID=OUTPUT.getFlipAngleMap();
            a=webread([QSRVR '/getMROPTDATAinfoByIdGET.php?ID=' num2str(ID)]);
            [~,~,ext]=fileparts(a.response.externalfilename);
            FAN=fullfile(TMP,[char(myuuid) ext]);
            urlwrite(a.response.externalfilename,FAN)
            
            switch(lower(ext))
                case{'.ima','.dcm'}
                    FA=dicomread(FAN);
                case{'.jpg','.jpeg','.bmp','.tiff'}
                    FA=imread(FAN);
            end
            
            delete(FAN);
            
            FA=sin(deg2rad(double(FA)));
            
            
            RECONCLASS.logIT('ohh i see we have a FA','ok');
            
        else
            FA=[];
        end
    catch
        RECONCLASS.logIT('some problems with FA','ko');
    end
    
    
    
    
    
    
    %% noise kspace
    KN=CLOUDMRRD();
    if isempty(RECONCLASS.NoiseFileType)
        KSN=[];
        
    else
        
        switch(RECONCLASS.NoiseFileType)
            case {'noiseFile'} %otherwise we provide an image
                
                temp =  java.util.UUID.randomUUID;
                myuuid = temp.toString;
                ID=o.NoiseID;
                a=webread([QSRVR '/getMROPTDATAinfoByIdGET.php?ID=' num2str(ID)]);
                [~,~,ext]=fileparts(a.response.externalfilename);
                noisefilename=fullfile(TMP,[char(myuuid) ext]);
                urlwrite(a.response.externalfilename, noisefilename);
                KN.setFilename(noisefilename);
                ln='user set that the noise map should be in a separated file';
                noisefile=true;
                RECONCLASS.logIT(ln,'ok');
                
                KSN=CLOUDMRSpreadthenoiseinto2DKSpace(KN,noisefile);
                
            case {'selfMulti','selfSingle'}
                ln='user set that the noise map should be embedded in the file';
                noisefile=false;
                for ns=1:numel(signalfilename)
                    try
                        clear tempT
                        tempT=CLOUDMRRD(signalfilename{ns});
                        KSN=CLOUDMRSpreadthenoiseinto2DKSpace(tempT,noisefile);
                    catch
                        KSN=[];
                    end
                end
                
                RECONCLASS.logIT(ln,'ok');
                
                
            otherwise
                ln='no noise information file';
                noisefile=true;
                
                KSN=[];
                
                
                
                RECONCLASS.logIT(ln,'ok');
        end
        
    end
    
    
    
    
    
    
    %for all the images in the array, recontruct the images for every rep and every slice
    thenumberofreplicas=0;
    for ks=1:numel(signalfilename)
        
        if exist('theimagestack','var')
            thenumberofreplicas=size(theimagestack,4);
        end
        %that's the file we are workking on
        thefilename=signalfilename{ks};
        
        %         clear and instantiate the reader class
        clear S;
        S=CLOUDMRRD(thefilename);
        
        
        %for log porpuses
        [oo,oi,op]=fileparts(thefilename);
        RECONCLASS.logIT([' image ' oi op ' is going to be processed'] ,'ok');
        
        %for all the slices
            for sl=1:S.getNumberImageSlices()
            
            rep=S.getNumberRepetition();
            startreplicas=thenumberofreplicas;
            
            for r=1:rep
                %this is a 2D kspace
                KSS=S.getKSpaceImageSlice(1,1,r,sl);
                
                if RECONCLASS.isAccelerated()
                    KSS=undersamplemSense2D(KSS,o.AccelerationF,o.AccelerationP,o.Autocalibration);
                end
                
                
                
                
                if RECONCLASS.needsSensitivity()
                    
                    if isbodycoil
                        
                        try
                            %get from the replica otherwise take from the first replica
                            SS=SOURCESENS.getKSpaceImageSlice('avg',1,r,sl);
                        catch
                            SS=SOURCESENS.getKSpaceImageSlice('avg',1,1,sl);
                        end
                    else
                        SS=S.getKSpaceImageSlice(1,1,r,sl);
                    end
                    
                    
                    
                    if RECONCLASS.isAccelerated()
                        KSENS=undersamplemSense2D(SS,o.AccelerationF,o.AccelerationP,o.Autocalibration);
                    else
                        KSENS=SS;
                    end
                else
                    KSENS=[];
                end
                
                
                [O, reconworkerclass]=RECONWORKER(KSS,KSN,o,KSENS,FA,['slice number # ' num2str(sl) ' rep number # ' num2str(startreplicas+r)]);
                OUTPUTCLASS.appendLOG(reconworkerclass.getLOG());
                theimagestack(:,:,sl,startreplicas+r)=O.Image;
            end
            %             actually get the image
            
            
        end
    end
    OUTPUTCLASS.setOutputFileName(resultfilename);
    OUTPUTCLASS.setOutputLogFileName(logfilename);
    
    MRWORKER(theimagestack,OUTPUTCLASS);
    fprintf(1,'done!\n\n');
catch
    
    if ~exist('OUTPUTCLASS','var')
        OUTPUTCLASS=CLOUDMROutput();
    end
    OUTPUTCLASS.outputError(logfilename);
    
    
    
    
end

end


function O=fixalo____qui(O)
O(isnan(O))=0;
O(isinf(O))=0;
end
