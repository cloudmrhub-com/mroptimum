
init


%% rss test
jop=mro2DReconGetDefaultOptionsForType('rss');
O=ACMtask(signalfilename,noisefilename,jop,'~/test/s.snr','~/test/l.snr','');

jop=mro2DReconGetDefaultOptionsForType('b1simplesense');
O=ACMtask(signalfilename,noisefilename,jop,'~/test/s2.snr','~/test/l2.snr','');


jop=mro2DReconGetDefaultOptionsForType('sensesimplesense');
O=ACMtask(signalfilename,noisefilename,jop,'~/test/s2.snr','~/test/l2.snr','');


jop=mro2DReconGetDefaultOptionsForType('grappa');
O=ACMtask(signalfilename,noisefilename,jop,'~/test/s2.snr','~/test/l2.snr','');