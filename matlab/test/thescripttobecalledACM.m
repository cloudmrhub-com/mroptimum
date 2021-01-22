
init


%% rss test
jop=mro2DReconGetDefaultOptionsForType('rss');
O=ACMtask(signalfilename,noisefilename,jop,'~/test/s.snr','~/test/l.snr','');
R=O.getResultsAsImages();
imshow(R(1).image(:,:,1),[]);


jop=mro2DReconGetDefaultOptionsForType('b1simplesense');
O=ACMtask(signalfilename,noisefilename,jop,'~/test/s2.snr','~/test/l2.snr','');
R=O.getResultsAsImages();
imshow(R(1).image(:,:,1),[]);

clear O R
jop=mro2DReconGetDefaultOptionsForType('sensesimplesense');
O=ACMtask(signalfilename,noisefilename,jop,'~/test/s2.snr','~/test/l2.snr','');
R=O.getResultsAsImages();
imshow(R(1).image(:,:,1),[]);



%no ACm for GRAPPA
jop=mro2DReconGetDefaultOptionsForType('grappa');
O=ACMtask(signalfilename,noisefilename,jop,'~/test/s2.snr','~/test/l2.snr','');
R=O.getResultsAsImages();
imshow(R(1).image(:,:,1),[]);



%[NF NP SL NC]=size(K);
jop=mro2DReconGetDefaultOptionsForType('rss');
O=ACMtask(signalfilename,randn(20,20,5,16),jop,'~/test/s.snr','~/test/l.snr','');
R=O.getResultsAsImages();
imshow(R(1).image(:,:,1),[]);
