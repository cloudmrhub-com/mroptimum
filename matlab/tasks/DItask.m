function[]=DItask(im0,im1,output,l)
%create the di matrix
try
    L=CLOUDMR2DDI(im0,im1);
    L.logIt('start calculation','start');
    
    L.calculate();
    L.exportResults(output);
    
    
    
    L.logIt('stop calculation','stop');
    L.exportLog(l);
catch
    try
        L.logIt('not work','ko');
        L.exportLog(l);
    catch
    end
end

