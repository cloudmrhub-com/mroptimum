classdef mroACM<cmOutput
    
    properties
        ImageReconstructor
        SNRUnitReconstructor
        NoiseKSpace
        SignalKSpace
        Config
        Others
    end
    
    
    methods
        
        function setSNRUnitReconstructor(this,recon)
            this.SNRUnitReconstructor=recon;
        end
        
        function o=getSNRUnitReconstructor(this)
            o=this.SNRUnitReconstructor;
        end
        
        function setImageReconstructor(this,recon)
            this.ImageReconstructor=recon;
        end
        
        function o=getImageReconstructor(this)
            o=this.ImageReconstructor;
        end
        
        
        function setSignalKSpace(this,K)
            this.SignalKSpace=K;
        end
        
        function o=getSignalKSpace(this)
            o=this.SignalKSpace;
        end
        
        
        function setNoiseKSpace(this,K)
            this.NoiseKSpace=K;
            this.ImageReconstructor.setNoiseKSpace(K);
try;            this.SNRUnitReconstructor.setNoiseKSpace(K);end; %not every recon has a snrend
        end
        
        function o=getNoiseKSpace(this)
            o=this.NoiseKSpace;
        end
        
        
        
        function id=getFlipAngleMap(this)
            try;id= this.Config.FlipAngleMap;catch; id="no";end;
        end
        
        
        function O=faCorrection(this)
            
            
            if strcmp(this.Config.FlipAngleMap,'no')
                O=false;
            else
                O=true;
            end
            
        end
        
        
        function o=getNoiseCovariance(this)
            
            o=this.ImageReconstructor.getNoiseCovariance();
            if (isempty(o))
                o=this.SNRUnitReconstructor.getNoiseCovariance();
            end
        end
        
        function o=getNoiseCoefficients(this)
            o=this.calculateNoiseCoefficientsMatrix(this.getNoiseCovariance());
            
        end
        
        
        
    end
    
    methods
        
        %constructor
        function this=mroACM(s,n)
            %the class expects a 3D matrix composed by a tile of 2D kspaces (fxpxncoils) of a signal and a
            %noise.
            
            
            if nargin>0
                this.setSignalKSpace(s);
            end
            
            if nargin>1
                this.setNoiseKSpace(n);
            end
            
            
            
        end
        
        
        
        
        
        function[o]=isAccelerated(this)
            R=this.getImageReconstructor();
            o =R.isAccelerated();
        end
        
        
        
        function[o]=needsSensitivity(this)
            R=this.getImageReconstructor();
            o =R.needsSensitivity();
        end
        
        
        function setCoilSensitivityMatrix(this,S)
            R=this.getImageReconstructor();
            R.setCoilSensitivityMatrixSource(S);
            RS=this.getSNRUnitReconstructor();
            RS.setCoilSensitivityMatrixSource(S);
        end
        
        
        
        function S= getCoilSensitivityMatrix(this)
            try
            S=this.Others.CoilSensitivityMatrix;
            catch
               this.getImage();
               try
               S=this.Others.CoilSensitivityMatrix;
               catch
                   this.getSNR()
                   try
                       S=this.Others.CoilSensitivityMatrix;
                   catch
                       NaN(2);
                   end
               end
            end
        end
        
        function S= getGFactor(this)
            S=this.Others.GFactorMap;
        end
        
        function O=undersampleTheSignal(this,R,K)
            %different for sense and grappa a reconstructor must be passed
            % O=R.mimicmSenseDataFromFullysampledZeroPadded(K,R.getAccelerationFrequency(),R.getAccelerationPhase(),R.getAutocalibration());
        end
        
        function [o, R]=calclIt(this,R)
            %R is the reconstructor
            if(R.isAccelerated())
                %set in the
                %reconstructor
                %the kspace
                %undersampled
                %
                R.setSignalKSpace(this.undersampleTheSignal(R,this.getSignalKSpace()));
            else
                
                R.setSignalKSpace(this.getSignalKSpace());
                
            end
            
            try
                R.setNoiseKSpace(this.getNoiseKSpace());
            catch
                R.logIt(['no Noise file for '  class(this)],'warning');
            end
            
            o=R.getOutput();
            if(this.needsSensitivity())
               
                    try
                        this.Others.CoilSensitivityMatrix=R.getCoilSensitivityMatrix();
                    catch
                        this.Others.CoilSensitivityMatrix=NaN(2);
                    end
               
            end
            
            if(this.hasGFactor())
                if(this.getGfactorFlag())
                    this.Others.GFactorReconstructor.setSignalKSpace(this.undersampleTheSignal(this.Others.GFactorReconstructor,this.getSignalKSpace()));
                    
                    try
                        this.Others.GFactorReconstructor.setNoiseKSpace(this.getNoiseKSpace());
                    catch
                        this.Others.GFactorReconstructor.logIt(['no Noise file for '  class(this)],'warning');
                    end
                    
                    this.Others.GFactorMap= this.Others.GFactorReconstructor.getOutput();
                    
                    R.appendLog(this.Others.GFactorReconstructor.getLog());
                    
                end
            end
            this.appendLog(R.getLog());
        end
        
        
        
        function o=hasGFactor(this)
            o=isfield(this.Others,'GFactorReconstructor');
        end
        function o=getSNR(this)
            R=this.getSNRUnitReconstructor();
            [o]=this.calclIt(R);
            
        end
        
        function o=getImage(this)
            
            R=this.getImageReconstructor();
            [o]=this.calclIt(R);
            
            
        end
        
        %just to be used with pmr and mr
        function [im, snr ]=getOutput(this)
            im=this.getImage();
            
            if nargin>1
                snr=this.getSNR();
            end
        end
        
        
    end
    
    
    
    
end


