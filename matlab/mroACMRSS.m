classdef mroACMRSS<mroACM
    
    properties
    end
    
    methods
        
        %constructor
        function this=mroACMRSS(s,n,js)
            %the class expects a 3D matrix composed by a tile of 2D kspaces (fxpxncoils) of a signal and a
            %noise.
            this.setTypeOutput('RSS')
            this.setImageReconstructor(cm2DReconRSS);
            this.setSNRUnitReconstructor(cm2DKellmanRSS);
            
            if nargin>0
                this.setSignalKSpace(s);
            end
            
            if nargin>1
                this.setNoiseKSpace(n);
            end
            
            if nargin>1
                this.setConf(js);
            end
            
        end
        function setConf(this,js)
            
            this.Config.Type=js.Type;
            this.Config.FlipAngleMap=js.FlipAngleMap;
            try;this.Config.NoiseFileType=js.NoiseFileType;end
            try;this.Config.NBW=js.NBW;end;
            
        end
        
        function O=getParams(this)
            
            O.Type=this.Config.Type;
            O.FlipAngleMap=this.Config.FlipAngleMap;
            O.NoiseFileType=this.Config.NoiseFileType;
            O.NBW=this.Config.NBW;
            
        end
        
   
        
    end
    
end


