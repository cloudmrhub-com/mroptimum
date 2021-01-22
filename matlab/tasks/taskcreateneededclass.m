function [NEEDCLASS]=taskcreateneededclass(o,KSN,KSENS,KSS,ontheclass)
NEEDCLASS=mro2DFromType(o);

if(exist('ontheclass','var'))
    NEEDCLASS.logIt([ontheclass 'start calculation'],'start');
else
    NEEDCLASS.logIt('start calculation','start');
end

%istantiates noise data the data is able to understand which kind of data is
%(ismrmrd and siemens by now)
KN=cm2DRawDataReader();

%set the noise data if the noise is set o self it will be set by the image
%sequence


%caluclate set the noise statistics
NEEDCLASS.setNoiseKSpace(KSN);
NEEDCLASS.logIt('set noise ','ok');

%single slice
SL=1;

if (NEEDCLASS.needsSensitivity())
    try
        NEEDCLASS.setSourceCoilSensitivityMap(KSENS);
        NEEDCLASS.logIt(['senstivity set'],'ok');
    catch
        try
            NEEDCLASS.setSourceCoilSensitivityMap(KSS);
            NEEDCLASS.logIt(['i set the senstivity to the same mimage'],'ko');
            
        catch
            
            NEEDCLASS.logIt(['senstivity set to the'],'ko');
        end
    end
end






%set the options
try
    NEEDCLASS.setConf(o);
    NEEDCLASS.logIt(['option set'],'ok');
catch
    NEEDCLASS.logIt(['problem with the conf'],'ko');
end







NEEDCLASS.setSignalKSpace(KSS);