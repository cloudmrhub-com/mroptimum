function [S,o,OUTCLASS,KSN,SOURCESENS,FA]=taskdataloader(signalfilename,noisefilename, jop,QSRVR)
%if the options file is a struct, no need to do much:

SOURCESENS=[];

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
    if isempty(signalfilename)
        S=[];
    else
        if ischar(signalfilename)
    S=cm2DRawDataReader(signalfilename);
        else
            S=cm2DRawDataReader();
            S.setcm2DRawDataReaderImageKSpaceFrom2DSlice(signalfilename,1,1,1);
        end
    end
    
    %% noise kspace
    KN=cm2DRawDataReader();
    switch(OUTCLASS.Config.NoiseFileType)
        case {'noiseFile'} %otherwise we provide an image
           % 
                   if ischar(noisefilename)

                       
                           KN.setIsSignalFile(0);

                       KN.setFilename(noisefilename);
           ln='user set that the noise map should be in a separated file';

        else
            KN.setcm2DRawDataReaderImageKSpaceFrom2DSlice(noisefilename,1,1,1);
            
            ln='user set that the noise map as a matrix';
            
                   end
                   noisefile=true;
        case {'selfMulti','selfSingle'}
            ln='user set that the noise map should be embedded in the file';
            KN.setFilename(signalfilename);
            noisefile=false;
        otherwise
            OUTCLASS.logIt('no noise source','error');
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
    end