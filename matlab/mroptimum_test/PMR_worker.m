function [SNR]=PMR_worker(KSS,KSN,o,KBC)
%BIDIMENSIONAL KSPACE signal, noise, option files KspaceBODYCOIL if needed PUBBLICAZIONE_ACM_worker(KSS,KSN,o,KBC)
TMP=pwd;



L=CLOUDMRgetclassfromOptions(o);

L.logIT('start calculation','start');



%istantiate noise data the data is able to understand which kind of data is
%(ismrmrd and siemens by now)
KN=CLOUDMRRD();

%set the noise data if the noise is set o self it will be set by the image
%sequence


%caluclate set the noise statistics
L.setNoiseKSpace(KSN);
L.logIT('set noise ','ok');
noisecoef=L.getNoiseCoefficients();
noisecov=L.getNoiseCovariance();


SL=1;






if (L.needsSensitivity())
    
    switch(o.SensitivityCalculationMethod)
        
        case {'BodyCoil'}
            
            L.setSourceCoilSensitivityMap(KBC);
        otherwise
            L.setSourceCoilSensitivityMap(KSS);
            
    end
    
    
    
    
    %         o=rmfield (o,'SourceCoilSensitivityMap');
    
    
end






%set the options
try
    L.setConf(o);
catch
    clc
    L.logIT(['problem with the conf' jop ],'ko');
    fprintf('no snr..\n');
    
end






PMR=CLOUDMR2DPMR();
L.setSignalKSpace(KSS);

PMR.readConf(o);

PMR.setReconstructor(L);

try
SNR=PMR.PseudoMRS();
catch
    S_=size(KSS);
    SNR=NaN(S_(1:2));
    fprintf('no snr..\n');
end

end
