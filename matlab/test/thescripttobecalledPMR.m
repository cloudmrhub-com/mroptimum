
init


%% rss test
jop=mro2DReconGetDefaultOptionsForType('rss');
jop.NR=10;
O=PMRtask(signalfilename,noisefilename,jop,'~/test/s.snr','~/test/l.snr','');
R=O.getResultsAsImages();
imshow(R(1).image(:,:,1),[]);


jop=mro2DReconGetDefaultOptionsForType('b1simplesense');
jop.NR=10;
O=PMRtask(signalfilename,noisefilename,jop,'~/test/s2.snr','~/test/l2.snr','');
R=O.getResultsAsImages();
imshow(R(1).image(:,:,1),[]);


jop=mro2DReconGetDefaultOptionsForType('sensesimplesense');
jop.NR=10;
O=PMRtask(signalfilename,noisefilename,jop,'~/test/s2.snr','~/test/l2.snr','');
R=O.getResultsAsImages();
imshow(R(1).image(:,:,1),[]);


jop=mro2DReconGetDefaultOptionsForType('grappa');
jop.NR=10;
O=PMRtask(signalfilename,noisefilename,jop,'~/test/s2.snr','~/test/l2.snr','');
R=O.getResultsAsImages();
imshow(R(1).image(:,:,1),[]);


clear O R
jop=mro2DReconGetDefaultOptionsForType('rss');
jop.NR=10;
O=PMRtask(signalfilename,randn(10,10,16),jop,'~/test/s2.snr','~/test/l2.snr','');
R=O.getResultsAsImages();
imshow(R(1).image(:,:,1),[]);