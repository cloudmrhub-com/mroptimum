function [L,type]=mro2DFromType(type)

if(isstruct(type))
TYPE=type.Type; 
else
    TYPE=type;
end

if nargin>0
    %    switch lower(m)
    switch lower(TYPE)
        case 'rss'
            L=mroACMRSS();
        case {'sense','msense'}
            L=mroACMSENSE();
         case 'b1'
             L=mroACMB1();
        case 'grappa'
            L=mroACMGRAPPA();
        case 'espirit'
            L=mroACMESPIRiT();            
    end
    
    
else
    METHODS={'rss'};%,'sense','grappa','b1','msense','adapt'};
    fprintf(1,'available methods ')
    for m=1:numel(METHODS)
        fprintf(1,[METHODS{m} ', ']);
    end
    fprintf(1,'\b\b  \neros.montin@gmail.com\n');
    
    
end