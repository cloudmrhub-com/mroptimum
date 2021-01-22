classdef mroACMB1<mroACM
    
    properties
    end
    
    methods
        
        %constructor
        function this=mroACMB1(s,n,js)
            %the class expects a 3D matrix composed by a tile of 2D kspaces (fxpxncoils) of a signal and a
            %noise.
            
            this.setTypeOutput('B1')
            
            this.setImageReconstructor(cm2DReconB1);
            this.setSNRUnitReconstructor(cm2DKellmanB1);
            
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
            
            % colsens
            this.Config.SensitivityCalculationMethod=js.SensitivityCalculationMethod;
            
            R=this.getImageReconstructor();
            RS=this.getSNRUnitReconstructor();
            R.setCoilSensitivityMatrixCalculationMethod(js.SensitivityCalculationMethod);
            RS.setCoilSensitivityMatrixCalculationMethod(js.SensitivityCalculationMethod);
            
            %i don't want to take the matlab image but it's id o the db
            this.Config.SourceCoilSensitivityMapID=js.SourceCoilSensitivityMap;
            
            this.Config.SaveCoils=js.SaveCoils;
            
            this.Config.SourceCoilSensitivityMapSmooth=js.SourceCoilSensitivityMapSmooth;
            R.setCoilSensitivityMatrixSourceSmooth(js.SourceCoilSensitivityMapSmooth);
            RS.setCoilSensitivityMatrixSourceSmooth(js.SourceCoilSensitivityMapSmooth);


            
            
            
        end
        
        function O=getParams(this)
            
            O.Type=this.Config.Type;
            O.FlipAngleMap=this.Config.FlipAngleMap;
            O.NoiseFileType=this.Config.NoiseFileType;
            O.NBW=this.Config.NBW;
            
            O.SensitivityCalculationMethod=this.Config.SensitivityCalculationMethod;
            O.SaveCoils=this.Config.SaveCoils;
            O.SourceCoilSensitivityMap=this.Config.SourceCoilSensitivityMapID;
            O.SourceCoilSensitivityMapSmooth=this.Config.SourceCoilSensitivityMapSmooth;
                        
        end
        
        

        
 
        
    end
    
end


