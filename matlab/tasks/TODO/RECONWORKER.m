function [O,NEEDCLASS]=RECONWORKER(KSS,KSN,o,KSENS,FA,ontheclass)
%BIDIMENSIONAL KSPACE signal (freq,phase,ncoils), noise(freq,phase,ncoils), optionfiles, sensitivitykspace (freq,phase,ncoils),
%FA map (freq,phase)
%ACMWORKER(KSS,KSN,o,KSS,FA,'you can do it baby!') %if KSS is the same as KSENS
%OUT.Image

NEEDCLASS=CLOUDMRgetclassfromOptions(o);

if(exist('ontheclass','var'))
    NEEDCLASS.logIT([ontheclass 'start calculation'],'start');
else
    NEEDCLASS.logIT('start calculation','start');
end

%istantiate noise data the data is able to understand which kind of data is
%(ismrmrd and siemens by now)
%KN=CLOUDMRRD();

%set the noise data if the noise is set o self it will be set by the image
%sequence


%caluclate set the noise statistics
NEEDCLASS.setNoiseKSpace(KSN);
NEEDCLASS.logIT('set noise ','ok');

%single slice
SL=1;

if (NEEDCLASS.needsSensitivity())
    try
        NEEDCLASS.setSourceCoilSensitivityMap(KSENS);
        NEEDCLASS.logIT(['senstivity set'],'ok');
    catch
        try
            NEEDCLASS.setSourceCoilSensitivityMap(KSS);
            NEEDCLASS.logIT(['i set the senstivity to the same mimage'],'ko');
            
        catch
            
            NEEDCLASS.logIT(['senstivity set to the'],'ko');
        end
    end
end






%set the options
try
    NEEDCLASS.setConf(o);
    NEEDCLASS.logIT(['option set'],'ok');
catch
    NEEDCLASS.logIT(['problem with the conf'],'ko');
end







NEEDCLASS.setSignalKSpace(KSS);

try
    O.Image=NEEDCLASS.getImage();
    NEEDCLASS.logIT(['Image calc'],'ok');
catch
    NEEDCLASS.logIT(['problem with Image calc'],'ko');
end


if(exist('FA','var'))
    if(isempty(FA))
        
    else
        
        try
            O.ImageFA=O.Image./FA;
            NEEDCLASS.logIT(['FAMAP'],'ok');
            
        catch
            NEEDCLASS.logIT(['problem with FA'],'ko');
        end
    end
else
    NEEDCLASS.logIT(['problem with FA'],'ko');
    
end











end
