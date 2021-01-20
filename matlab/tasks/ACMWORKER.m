function [O,NEEDCLASS]=ACMWORKER(KSS,KSN,o,KSENS,FA,ontheclass)
%BIDIMENSIONAL KSPACE signal (freq,phase,ncoils), noise(freq,phase,ncoils), optionfiles, sensitivitykspace (freq,phase,ncoils),
%FA map (freq,phase)
%ACMWORKER(KSS,KSN,o,KSS,FA,'you can do it baby!') %if KSS is the same as KSENS
%OUT.SNR
%OUT.S sensitivity
%OUT.SNRFA
%OUT.GF
%OUT.UGF

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

try
    O.SNR=NEEDCLASS.getSNR();
    NEEDCLASS.logIt(['SNR calc'],'ok');
catch
    NEEDCLASS.logIt(['problem with snr calc'],'ko');
end
if NEEDCLASS.isAccelerated()
    try
        O.GF=NEEDCLASS.getGFactor();
        O.UGF=1./O.GF;
        O.UGF(isnan(O.UGF))=0;
        O.UGF(isinf(O.UGF))=0;
        NEEDCLASS.logIt(['GF calc'],'ok');
    catch
        NEEDCLASS.logIt(['problem with GF'],'ko');
    end
end



if (NEEDCLASS.needsSensitivity())
    if(NEEDCLASS.Config.SaveCoils)
        try
            O.S=NEEDCLASS.getSensitivityMatrix();
            NEEDCLASS.logIt(['Sensitivity'],'ok');
        catch
            NEEDCLASS.logIt(['problem with Sensitivity'],'ko');
        end
    end
end


if(exist('FA','var'))
    if(isempty(FA))
        
    else
        
        try
            O.SNRFA=O.SNR./FA;
            NEEDCLASS.logIt(['FAMAP'],'ok');
            
        catch
            NEEDCLASS.logIt(['problem with FA'],'ko');
        end
    end
else
    NEEDCLASS.logIt(['problem with FA'],'ko');
    
end











end
