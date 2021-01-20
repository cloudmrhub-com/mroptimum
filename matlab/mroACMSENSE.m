classdef mroACMSENSE<mroACM
    
    properties
        
        
    end
    
    methods
        
        
        %constructor
        function this=mroACMSENSE(s,n,js)
            %the class expects a 3D matrix composed by a tile of 2D kspaces (fxpxncoils) of a signal and a
            %noise.
            
            this.setImageReconstructor(cm2DReconSENSE());
            this.setSNRUnitReconstructor(cm2DKellmanSENSE());
            this.Others.GFactorReconstructor=cm2DGFactorSENSE();
            
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
            this.Others.GFactorReconstructor.setCoilSensitivityMatrixCalculationMethod(js.SensitivityCalculationMethod);
            %i don't want to take the matlab image but it's id o the db
            this.Config.SourceCoilSensitivityMapID=js.SourceCoilSensitivityMap;
            
            this.Config.SaveCoils=js.SaveCoils;
            
            this.Config.SourceCoilSensitivityMapSmooth=js.SourceCoilSensitivityMapSmooth;
            R.setCoilSensitivityMatrixSourceSmooth(js.SourceCoilSensitivityMapSmooth);
            RS.setCoilSensitivityMatrixSourceSmooth(js.SourceCoilSensitivityMapSmooth);
             this.Others.GFactorReconstructor.setCoilSensitivityMatrixSourceSmooth(js.SourceCoilSensitivityMapSmooth);
            
            this.Config.AccelerationF = js.AccelerationF;
            this.Config.AccelerationP = js.AccelerationP;
            this.Config.Autocalibration = js.Autocalibration;
            
            R.setAccelerationFrequency(js.AccelerationF);
            R.setAccelerationPhase(js.AccelerationP);
            R.setAutocalibration(js.Autocalibration);
            
            RS.setAccelerationFrequency(js.AccelerationF);
            RS.setAccelerationPhase(js.AccelerationP);
            RS.setAutocalibration(js.Autocalibration);
            
            this.Others.GFactorReconstructor.setAccelerationFrequency(js.AccelerationF);
            this.Others.GFactorReconstructor.setAccelerationPhase(js.AccelerationP);
            this.Others.GFactorReconstructor.setAutocalibration(js.Autocalibration);
            
             
             if(isfield(js,'GFactorMask'))
                this.Config.GFactorMaskID =js.GFactorMask;
            else
                this.Config.GFactorMaskID="no";
            end
            
            
            this.Config.GFactor=1;
            
            
            
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
            
            
            O.AccelerationF = this.Config.AccelerationF;
            O.AccelerationP = this.Config.AccelerationP;
            
            O.GFactorMask =this.GFactorMaskID;
            O.Autocalibration=this.Config.Autocalibration;
            
        end
        
        
        function O=undersampleTheSignal(this,R,K)
            %different for sense and grappa a reconstructor must be passed
            O=R.mimicmSenseDataFromFullysampledZeroPadded(K,R.getAccelerationFrequency(),R.getAccelerationPhase(),R.getAutocalibration());
        end
        
        
        
        
    end
end

