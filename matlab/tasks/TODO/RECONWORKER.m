function [O,NEEDCLASS]=RECONWORKER(KSS,KSN,o,KSENS,FA,ontheclass)
%BIDIMENSIONAL KSPACE signal (freq,phase,ncoils), noise(freq,phase,ncoils), optionfiles, sensitivitykspace (freq,phase,ncoils),
%FA map (freq,phase)
%ACMWORKER(KSS,KSN,o,KSS,FA,'you can do it baby!') %if KSS is the same as KSENS
%OUT.Image

[NEEDCLASS]=taskcreateneededclass(o,KSN,KSENS,KSS,ontheclass);

try
    O.Image=NEEDCLASS.getImage();
    NEEDCLASS.logIt(['Image calc'],'ok');
catch
    NEEDCLASS.logIt(['problem with Image calc'],'ko');
end


if(exist('FA','var'))
    if(isempty(FA))
        
    else
        
        try
            O.Image=O.Image./FA;
            NEEDCLASS.logIt(['FAMAP'],'ok');
            
        catch
            NEEDCLASS.logIt(['problem with FA'],'ko');
        end
    end
else
    NEEDCLASS.logIt(['problem with FA'],'ko');
    
end











end
