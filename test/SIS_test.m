image1='/data/MYDATA/TestSNR_15Apr2019_multislice/DICOMS/100_replicas/MR_OPTIMUM.MR._.0118.0005.2019.04.15.23.15.25.226624.332109391.IMA';
image2='/data/MYDATA/TestSNR_15Apr2019_multislice/DICOMS/100_replicas/MR_OPTIMUM.MR._.0117.0005.2019.04.15.23.15.25.226624.332109283.IMA';

addpath(genpath('../'))


MASK=zeros(96,96,1);
MASK(48-16+1:48+16,48-16+1:48+16,:)=1;

A=mroSIS(dicomread(image1),MASK,2);