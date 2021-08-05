classdef CLOUDMR2DDI<cmOutput
    %main class of for DI it needs cloudmr toolbox
    
    properties
        image0
        image1        
    end
    
    
    
    
    methods
        function this = CLOUDMR2DDI(s0,s1)
            this.logIt('instantiate the class DI','ok')
            this.setTypeOutput('DI')
            if nargin>0
                try
                    this.setImage0(s0);
                    this.logIt('correctly set the first image','ok');
                catch
                    this.logIt('cannot set the first image','ko');
                end
                
            end
            
            if nargin>1
                try
                    this.setImage1(s1);
                    this.logIt('correctly set the second image','ok');
                catch
                    this.logIt('cannot set the second image','ko');
                end
            end
            
        end
        
        function setImage0(this,f)
            
            this.image0=this.DIgetImage(f);
            this.addToExporter('image2D','Image 1',this.image0);
            
            
            
        end
        
        function setImage1(this,f)
            this.image1=this.DIgetImage(f);
            this.addToExporter('image2D','Image 2',this.image1);
        end
        
        
        function calculate(this)
            this.logIt('start calculation','start');
            if (sum(size(this.image0)-size(this.image1))==0)
                this.logIt('images have the same size','ok');
                
                if(numel(size(this.image0))==2)
                    this.logIt('images are both 2D','ok');
                    try
                        this.addToExporter('image2D','Result Difference Image',this.image1-this.image0);
                        this.logIt('subctraction image is calculated','ok');
                    catch
                        this.logIt('subctraction image is not calculate','ko');
                    end
                    try
                        this.addToExporter('image2D','Result Sum image',this.image1+this.image0);
                        this.logIt('sum image is calculated','ok');
                    catch
                        this.logIt('sum image isn''t calculate','ko');
                    end
                else
                    this.logIt('images are not 2D','ko');
                end
            else
                this.logIt('images has not the same size','ko');
            end
            this.logIt('end calculation','end');
            
        end
        
        
        
        
        
        
        
        function O=DIgetImage(this,X)
            try
                try
                    if(exist(X,'file'))
                        [a,b,c]=fileparts(X);
                        
                    else
                        this.logIt('image doesnt exist','ko');
                    end
                catch
                    this.logIt('image doesnt exist','ko');
                end
                
                
                switch(lower(c(2:end)))
                    case {'dcm','ima'}
                        this.logIt('image is Dicom','ok');
                        try
                            O=dicomread(X);
                        catch
                            this.logIt('cannot read image with dicom read','ko');
                            
                        end
                    case{'jpg','jpeg','bmp','png'}
                        this.logIt('image is not Dicom','ok');
                        try
                            
                            O=imread(X);
                        catch
                            this.logIt('cannot read image with imread','ko');
                        end
                        if numel(size(O))==3
                            O=rgb2gray(O);
                        else
                            this.logIt('this is a weird image with more than 3 dimension (RGB)','ko');
                            
                        end
                    case {'nii'}
                        this.logIt('image is Nifti','ok');
                        try
                            O=load_(X);
                        catch
                            this.logIt('cannot read image with dicom read','ko');
                            
                        end
                        
                end
                
                
                
            catch
                this.logIt('something went wrong during the DI read of the file','ko');
                
            end
            
        end
        %     end
        %     methods (Static)
        function scalarSNR=getRoiSNR(this,roi)
            scalarSNR=NaN;
            
            if exist('roi','var')
                if ~isempty(roi)
                    scalarSNR=mroDI(this.image0,this.image0,roi);
                end
            end
        end
    end
end



