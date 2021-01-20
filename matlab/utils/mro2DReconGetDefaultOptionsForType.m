function [o , recon]=mro2DReconGetDefaultOptionsForType(type,options)


o.FlipAngleMap="no";
o.NBW=1;
o.NoiseFileType='noiseFile';


if nargin>0
    switch(lower(type))
    
        case 'b1simplesense'
            o.Type='B1';
            o.SensitivityCalculationMethod='simplesense';
            o.SourceCoilSensitivityMap='self';
            o.SaveCoils=false;
            o.SourceCoilSensitivityMapSmooth=false;

          case 'rss'
            o.Type='RSS';
            o.UseCovarianceMatrix=true; %normal  
        case {'msensesimplesense','sensesimplesense'}
               o.Type='msense';
            o.SensitivityCalculationMethod='simplesense';
            o.SourceCoilSensitivityMap='self';
            o.SaveCoils=false;
            o.SourceCoilSensitivityMapSmooth=false;
            o.AccelerationF=1;
            o.AccelerationP=2;
            o.Autocalibration=32;
              case {'grappa'}
            o.Type='GRAPPA';
            o.AccelerationF=1;
            o.AccelerationP=2;
            o.AutocalibrationF=32;
            o.AutocalibrationP=32;
            o.GrappaKernel1=5
            o.GrappaKernel2=4
            o.SoSRecon=0;
    end
    
    
    
    ON=fieldnames(o);
    c=0;
    
    
    if exist('options','var')
        if(isstruct(options))
            FN=fieldnames(options);
            
            for t=1:numel(FN)

                c=c+1;
                eval(['o.' FN{t} '=options.' FN{t} ';']);
            end
            display([num2str(c) ' field overloaded over ' num2str(numel( fieldnames(o))) ' (originally ' num2str(numel(ON)) ')']);
        end
    end
    
else
    o=[];
%    METHODS={'b1espirit','rssbart','msensebartsense','msenseespirits','msensesimplesense','msenseadaptive','rss','b1simplesense','b1bc'};
METHODS={'rss','b1simplesense','msensesimplesense'};    
fprintf(1,'available methods ')
    for m=1:numel(METHODS)
        fprintf(1,[METHODS{m} ', ']);
    end
    fprintf(1,'\b\b  \neros.montin@gmail.com\n');
    
    
end





%  case 'b1espirit'
%             o.Type='B1';
%             o.SensitivityCalculationMethod='espirit';
%             o.SourceCoilSensitivityMap='self';
%             o.SaveCoils=false;
%             o.SourceCoilSensitivityMapSmooth=false;        
%         case {'b1bc','b1bodycoil'}
%             o.Type='B1';
%             o.SensitivityCalculationMethod='BodyCoil';
%             o.SourceCoilSensitivityMap='self';
%             o.SaveCoils=false;
%             o.bc='filenameBC';
%             o.SourceCoilSensitivityMapSmooth=false;
%             
%   
%         
%         case 'espirits'
%             o.Type='espirit';
%             o.SensitivityCalculationMethod='espirit';
%             o.SourceCoilSensitivityMap='self';
%             o.SaveCoils=false;
%             o.SourceCoilSensitivityMapSmooth=false;
%             o.AccelerationF=1;
%             o.AccelerationP=2;
%             o.Autocalibration=24;
%             
%         case 'msensebartsense'
%             o.Type='msense';
%             o.SensitivityCalculationMethod='bartsense';
%             o.SourceCoilSensitivityMap='self';
%             o.SourceCoilSensitivityMapSmooth=false;
%             o.AccelerationF=1;
%             o.AccelerationP=2;
%             o.Autocalibration=32;
%         case 'msensesepirit'
%             o.Type='msense';
%             o.SensitivityCalculationMethod='espirit';
%             o.SourceCoilSensitivityMap='self';
%             o.SaveCoils=false;
%             o.SourceCoilSensitivityMapSmooth=false;
%             o.AccelerationF=1;
%             o.AccelerationP=2;
%             o.Autocalibration=24;
%         case 'msensesimplesense'
%             o.Type='msense';
%             o.SensitivityCalculationMethod='simplesense';
%             o.SourceCoilSensitivityMap='self';
%             o.SaveCoils=false;
%             o.SourceCoilSensitivityMapSmooth=false;
%             o.AccelerationF=1;
%             o.AccelerationP=2;
%             o.Autocalibration=32;
%         case 'msenseadaptive'
%             o.Type='msense';
%             o.SensitivityCalculationMethod='adapt';
%             o.SourceCoilSensitivityMap='self';
%             o.SaveCoils=false;
%             o.NBW=1;
%             o.SourceCoilSensitivityMapSmooth=false;
%             o.AccelerationF=1;
%             o.AccelerationP=2;
%             o.Autocalibration=32;
