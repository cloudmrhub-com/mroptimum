classdef mroCR<mroPMR
    
    properties(Access=protected)        
     DFTNR=2; %default numberof replicas
     DFTBB=3; %default number bounding box size
    end
    
    
    methods
    
              %constructor
        function this=mroCR(RE,js)
             this.Filter=cm2DSignalToNoiseRatioPseudoMultipleReplicasWien();
            %the class expects a Reconstructor class
            if (nargin>0)
                
                %we don't want to calculate hfactor every replica
                if(RE.hasGFactor())
                RE.setGfactorFlag(0);
                end
                this.Filter.setNumberOfPseudoReplicas(this.DFTNR); %default
                this.Filter.setBoxSize(this.DFTBB);
            
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


