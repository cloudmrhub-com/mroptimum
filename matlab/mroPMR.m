classdef mroPMR<cmOutput
    
    properties        
      ImageReconstructor
      Config
      Others
      Filter
    end
    
    
    methods
    
              %constructor
        function this=mroPMR(RE,js)
            %the class expects a Reconstructor class
             this.Filter=cm2DSignalToNoiseRatioPseudoMultipleReplicas();
            if (nargin>0)
                
                if(RE.hasGFactor())
                RE.setGfactorFlag(0);
                end
                this.Config.NR=100;
                this.setImageReconstructor(RE);
            end
            if (nargin>1)
                    this.setConf(js);                    
            end
        end
        
        
        function setConf(this,js)
            
            this.Filter.setNumberOfPseudoReplicas(js.NR);
            
        
        end
        
        function O=getParams(this)
                    R=this.getImageReconstructor();
                    O=R.getParams();
                    O.NR=this.Filter.getNumberOfPseudoReplicas();
        end
        
        function setImageReconstructor(this,recon)
            this.ImageReconstructor=recon;
            this.Filter.setReconstructor(this.ImageReconstructor);
        end

        function o=getImageReconstructor(this)
            o=this.ImageReconstructor;
        end

        
  
        

            
            
            
                    function[o]=isAccelerated(this)
                        R=this.getImageReconstructor();
                        o =R.isAccelerated();
                    end
            

                    
                                        function[o]=needsSensitivity(this)
                                            R=this.getImageReconstructor();
                                                o =R.needsSensitivity();
                                        end

        
                
        
        
        function S= getSensitivityMatrix(this)
            S=this.Others.CoilSensitivityMarix;
        end
        
         function S= getGFactor(this)
            S=this.Others.GFactorMap;
        end
        
                                       
                                        
                                        
        function [snr,niose]=getSNR(this)
            F=this.Filter;
                [snr,niose]=F.getOutput();
        end
        
        
        
    end
        
        
        
      
end


