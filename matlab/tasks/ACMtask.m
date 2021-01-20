function OUTCLASS=  ACMtask(signalfilename,noisefilename,jop,resultfilename,logfilename,QSRVR)
warning('off');




[TMP,~,~]=fileparts(resultfilename);

try
    %%read options and instantiate the output class
    
    %if the options file is a struct, no need to do much:
    if(isstruct(jop))
        
        o=jop;
    else
        %probably is a link or a json string
        [a,b,c]=fileparts(jop);
        %if it's a link download it
        if ~isempty(regexp(a,'^htt'))
            o=webread(jop);
        else
            o = jsondecode(fileread(jop));
        end
    end
    
    OUTCLASS=mro2DFromType(o);
    
    try
        OUTCLASS.setConf(o);
    catch
        OUTCLASS.logIt(['problem with the conf' jop ],'ko');
    end
    
    %% the signal rd
    S=cm2DRawDataReader(signalfilename);
    
    %% noise kspace
    KN=cm2DRawDataReader();
    switch(OUTCLASS.Config.NoiseFileType)
        case {'noiseFile'} %otherwise we provide an image
            KN.setFilename(noisefilename);
            ln='user set that the noise map should be in a separated file';
            noisefile=true;
        case {'selfMulti','selfSingle'}
            ln='user set that the noise map should be embedded in the file';
            KN.setFilename(signalfilename);
            noisefile=false;
        otherwise
            ln='user set that the noise map should be embedded in the file';
            KN.setFilename(signalfilename);
            noisefile=true;
    end
    
    OUTCLASS.logIt(ln,'ok');
    
    KSN=spread2DRawDataKSpaceNoiseInChannels(KN,noisefile);
    
    
    
    %% get the  BC if needed
    if (OUTCLASS.needsSensitivity())
        switch(o.SensitivityCalculationMethod)
            case {'BodyCoil'}
                temp =  java.util.UUID.randomUUID;
                myuuid = temp.toString;
                ID=o.SourceCoilSensitivityMap;
                a=webread([QSRVR '/getMROPTDATAinfoByIdGET.php?ID=' num2str(ID)]);
                [~,~,ext]=fileparts(a.response.externalfilename);
                bc=fullfile(TMP,[char(myuuid) ext]);
                urlwrite(a.response.externalfilename,bc);
                BC=cm2DRawDataReader();
                BC.setFilename(bc);
                SOURCESENS=BC;
                %                 read it before deleting otherwise i'm loosing the file:)
                SOURCESENS.getRawDataImageKSpaceSlice(1,1,1,1);
                delete(bc);
                clear bc;
            otherwise
                SOURCESENS=S;
        end
        
        
    end
    
    
    %% FA?
    try
        if (OUTCLASS.faCorrection)
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
            
            
            OUTCLASS.logIt('ohh i see we have a FA','ok');
            
        else
            FA=[];
        end
    catch
        OUTCLASS.logIt('some problems with FA','ko');
    end
    
    
    %% SNR calculation
    
    
    %     S=cm2DRawDataReader(signalfilename);
    
    
    for sl=1:S.getNumberImageSlices()
        KSS=S.getRawDataImageKSpaceSlice('avg',1,1,sl);
        
%         if OUTCLASS.isAccelerated()
%             KSS=undersamplemSense2D(KSS,o.AccelerationF,o.AccelerationP,o.Autocalibration);
%         end
        
        
        
        if OUTCLASS.needsSensitivity()
            
        %    SPECIALCASES= false;
            %thetestfor=lower(OUTCLASS.Config.SensitivityCalculationMethod);
            
            %SPECIALCASES = (strcmp(thetestfor,'simplesense') || strcmp(thetestfor,'inner')  || strcmp(thetestfor,'internal reference') ||  ...
             %   strcmp(thetestfor,'adaptive')  || strcmp(thetestfor,'bodycoil')  );
            %                SPECIALCASES=(strcmp(thetestfor,'bodycoil')   );
%             if (OUTCLASS.isAccelerated() && ~SPECIALCASES)
%                 
%                 KSENS=undersamplemSense2D(SOURCESENS.getRawDataImageKSpaceSlice('avg',1,1,sl),o.AccelerationF,o.AccelerationP,o.Autocalibration);
%             else
                KSENS=SOURCESENS.getRawDataImageKSpaceSlice('avg',1,1,sl);
%             end
        else
            KSENS=[];
        end
        
        [O(sl),L(sl)]=ACMWORKER(KSS,KSN,o,KSENS,FA,['slice number # ' num2str(sl)]);
        %update the main class
        OUTCLASS.appendLog(L(sl).getLog());
        
        
    end
    
    %% Time to gather the results
    
    for (sl=1:numel(O))
        
        if(isfield(O,'SNR'))
            SNR(:,:,sl)=fixalo____qui(O(sl).SNR);
        end
        
        if(isfield(O,'SNRFA'))
            FASNR(:,:,sl)=fixalo____qui(O(sl).SNRFA);
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
    
    
    
    %% export the results
    
    if(isfield(O,'SNR'))
        OUTCLASS.add2DImagetoExport(SNR,'SNR Map');
        
    end
    
    if(isfield(O,'SNRFA'))
        OUTCLASS.add2DImagetoExport(SNRFA,'SNR FA');
    end
    
    if(isfield(O,'GF'))
        OUTCLASS.add2DImagetoExport(GF,'g Factor');
    end
    
    if(isfield(O,'UGF'))
        OUTCLASS.add2DImagetoExport(UGF,'Inverse g Factor');
    end
    
    if(isfield(O,'S'))
        if (OUTCLASS.Config.SaveCoils)
            for coilnumber=1:size(SENSITIVITIES,4)
                
                OUTCLASS.add2DImagetoExport(squeeze(SENSITIVITIES(:,:,:,coilnumber)),['Coil Sens. #' sprintf('%03d',coilnumber) ]);
                
            end
        end
    end
    
    OUTCLASS.add2DImagetoExport(L(1).getNoiseCovariance(),'Noise Covariance');
    OUTCLASS.add2DImagetoExport(L(1).getNoiseCoefficients(),'Noise Coefficients');
    %write results (Exporter)
    OUTCLASS.exportResults(resultfilename);
    
    %export log
    OUTCLASS.logIt('stop calculation','stop');
    OUTCLASS.exportLog(logfilename);
    
    fprintf(1,'done!\n\n');
catch
    
    if ~exist('OUTCLASS','var')
        OUTCLASS=cmOutput();
    end
    OUTCLASS.outputError(logfilename);
    
    
    
    
end

end


function O=fixalo____qui(O)
O(isnan(O))=0;
O(isinf(O))=0;
end
