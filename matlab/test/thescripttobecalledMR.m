
%pay attention since i changed the MRtask, the function now needs the noise data

init


%% rss test
jop=mro2DReconGetDefaultOptionsForType('rss');
O=MRtask([{themrfile}],noisefilename,jop,'~/test/s.json','~/test/l.json','');
%%to get the results just us
R=O.getResultsAsImages();
imshow(R(1).Image(:,:,1),[]);

jop=mro2DReconGetDefaultOptionsForType('b1simplesense');

O=MRtask([{themrfile}],noisefilename,jop,'~/test/s2.json','~/test/l2.json','');
%%to get the results just us
R=O.getResultsAsImages();
imshow(R(1).Image(:,:,1),[]);


jop=mro2DReconGetDefaultOptionsForType('sensesimplesense');

O=MRtask([{themrfile}],noisefilename,jop,'~/test/s2.json','~/test/l2.json','');
%%to get the results just us
R=O.getResultsAsImages();
imshow(R(1).Image(:,:,1),[]);

jop=mro2DReconGetDefaultOptionsForType('grappa');
O=MRtask([{themrfile}],noisefilename,jop,'~/test/s2.json','~/test/l2.json','');



%%to get the results just us
R=O.getResultsAsImages();
imshow(R(1).Image(:,:,1),[]);
