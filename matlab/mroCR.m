classdef mroCR<mroPMR
    
    properties        
      Filter=cm2DSignalToNoiseRatioPseudoMultipleReplicasWien()
    end
    
    
    methods
    
              %constructor
        function this=mroCR(RE,js)
            %the class expects a Reconstructor class
            if (nargin>0)
                
                %we don't want to calculate hfactor every replica
                if(RE.hasGFactor())
                RE.setGfactorFlag(0);
                end
                this.Config.NR=100;
                this.BoxSize=3;
            
                this.setImageReconstructor(RE);
            end
            if (nargin>1)
                    this.setConf(js);                    
            end
        end
        
        
        function setConf(this,js)            
            this.Filter.setNumberOfPseudoReplicas(js.NR);
            this.Filter.setBoxSize(js.BoxSize);
        end
        
        function O=getParams(this)
                    R=this.getImageReconstructor();
                    O=R.getParams();
                    O.NR=this.Filter.getNumberOfPseudoReplicas();
                    O.BoxSize=this.Filter.getBoxSize();
        end
        
       

        
  
        

            
            
        
        
        
    end
        
        
        
      
end


