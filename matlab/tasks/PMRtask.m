function OUTCLASS=  PMRtask(signalfilename,noisefilename,jop,resultfilename,logfilename,QSRVR)
warning('off');




[TMP,~,~]=fileparts(resultfilename);

try
    %%read options and instantiate the output class
    
    [S,o,OUTCLASS,KSN,SOURCESENS,FA]=taskdataloader(signalfilename,noisefilename, jop,QSRVR);
    
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
        
        [O(sl),L(sl)]=PMRWORKER(KSS,KSN,o,KSENS,FA,['slice number # ' num2str(sl)]);
        %update the main class
        OUTCLASS.appendLog(L(sl).getLog());
        
        
    end
    
    %% Ttime togather the results
    
      [SNR,SNRFA,GF,UGF,SENSITIVITIES,STD]=taskgatherdata(O);
   

   
  
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
              if(isfield(O,'STD'))
              OUTCLASS.add2DImagetoExport(STD,'STD Image');

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
        OUTCLASS=CLOUDMROutput();
    end
    OUTCLASS.outputError(logfilename);
    
    
    
    
end

end


function O=fixalo____qui(O)
    O(isnan(O))=0;
    O(isinf(O))=0;
end
