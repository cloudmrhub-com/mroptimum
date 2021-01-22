# MROPTIMUM tasks

## ACMtask
- reads the jsonoption file
- creates a acmcalss accordingly (o.Type)
- sets the configuration
- reads the signal 
- reads and spread the noise
- if there's a bc body coil it downloads the file from QSRVR '/getMROPTDATAinfoByIdGET.php?ID=' num2str(ID)] //TOFIX for s3
- if FA correction is set it downloads the file similar to bc //TOFIX for s3
- for each slice
    - sets the kspace slice
    - if there's a sensitivity map it sets it
    - calls [O(s) L(s)]=ACMWORKER(KSS,KSN,o,KSENS,FA,['slice number # ' num2str(sl)]);
        - get the mroACM reconstructors the classes that getSNR and getImage by instantiating the couple of classes cm2DReconXX and cm2DKellmanXX
        - O is a struct with SNR and all the needed things for the slice
        - L is the acm class
- gathers the results
    - SNR, FASNR, GF, UGF, SENSITIVITIES

- exports the results



### ACMWORKER
- instantiates a new slice acm class
- if needs the sensitivity source it sets it
- set the conf
- gets SNR, FASNR, GF, UGF, SENSITIVITIES




## PMRtask very similar to ACMtask
- like PMR
- for each slice
    - sets the kspace slice
    - if there's a sensitivity map it sets it
    - calls [O(s) L(s)]=PMRWORKER(KSS,KSN,o,KSENS,FA,['slice number # ' num2str(sl)]);
        - O is a struct with SNR and all the needed things for the slice
        - L is the acm class
- like PMR



### PMRWORKER
- instantiates a new slice acm class
    - get the mroACM reconstructors the classes that getSNR and getImage by instantiating the couple of classes cm2DReconXX and cm2DKellmanXX
    - this class is used as recontructor to create the replica stack by means cm2DSignalToNoiseRatioPseudoMultipleReplicas
- gets SNR, FASNR, GF, UGF, SENSITIVITIES



## CRtask very similar to PMRtask
- like PMR
- for each slice
    - sets the kspace slice
    - if there's a sensitivity map it sets it
    - calls [O(s) L(s)]=CRWORKER(KSS,KSN,o,KSENS,FA,['slice number # ' num2str(sl)]);
        - O is a struct with SNR and all the needed things for the slice
        - L is the acm class
-like PMRtask



### CRWORKER
- instantiates a new slice acm class 
    - get the mroACM reconstructors the classes that getSNR and getImage by instantiating the couple of classes cm2DReconXX and cm2DKellmanXX
    - this class is used as recontructor to create the replica stack by means cm2DSignalToNoiseRatioPseudoMultipleReplicasWien
- gets SNR, FASNR, GF, UGF, SENSITIVITIES



