clear all

init


%% rss test
jop=mro2DReconGetDefaultOptionsForType('rss');
jop.NR=10;
jop.BoxSize=3;
O=CRtask(signalfilename,noisefilename,jop,'~/test/s.snr','~/test/l.snr','');
R=O.getResultsAsImages();
imshow(R(1).image(:,:,1),[]);
clear OR
jop=mro2DReconGetDefaultOptionsForType('b1simplesense');
jop.NR=10;
jop.BoxSize=3;
O=CRtask(signalfilename,noisefilename,jop,'~/test/s2.snr','~/test/l2.snr','');

R=O.getResultsAsImages();
imshow(R(1).image(:,:,1),[]);
clear OR

jop=mro2DReconGetDefaultOptionsForType('sensesimplesense');
jop.NR=10;
jop.BoxSize=3;
O=CRtask(signalfilename,noisefilename,jop,'~/test/s2.snr','~/test/l2.snr','');

R=O.getResultsAsImages();
imshow(R(1).image(:,:,1),[]);
clear OR

jop=mro2DReconGetDefaultOptionsForType('grappa');
jop.NR=10;
jop.BoxSize=3;
O=CRtask(signalfilename,noisefilename,jop,'~/test/s2.snr','~/test/l2.snr','');

R=O.getResultsAsImages();
imshow(R(1).image(:,:,1),[]);
clear OR