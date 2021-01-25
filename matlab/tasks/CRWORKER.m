function [O,NEEDCLASS]=CRWORKER(KSS,KSN,o,KSENS,FA,ontheclass)
%BIDIMENSIONAL KSPACE signal (freq,phase,ncoils), noise(freq,phase,ncoils), optionfiles, sensitivitykspace (freq,phase,ncoils),
%FA map (freq,phase)
%ACMWORKER(KSS,KSN,o,KSS,FA,'you can do it baby!') %if KSS is the same as KSENS
%OUT.SNR
%OUT.S sensitivity
%OUT.SNRFA
%OUT.GF
%OUT.UGF


[NEEDCLASS]=taskcreateneededclass(o,KSN,KSENS,KSS,ontheclass);


CR=mroCR(NEEDCLASS,o);



try
    
    [O.SNR, O.STD]=CR.getSNR();
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
            O.S=NEEDCLASS.getCoilSensitivityMatrix();
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
