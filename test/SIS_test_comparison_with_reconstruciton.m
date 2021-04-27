%test with dicom
% i want to test why sis does not work with our reconstructions


if ~exist('B1_1','file')

    
    if exist('data.mat','file')
        load data
    else


addpath(genpath('../'))

MASK=zeros(96,96,5);
MASK(48-16+1:48+16,48-16+1:48+16,:)=1;

replica1={'/data/MYDATA/TestSNR_15Apr2019_multislice/DICOMS/100_replicas/MR_OPTIMUM.MR._.0018.0001.2019.04.15.23.15.25.226624.332098663.IMA' , ...
'/data/MYDATA/TestSNR_15Apr2019_multislice/DICOMS/100_replicas/MR_OPTIMUM.MR._.0018.0002.2019.04.15.23.15.25.226624.332098717.IMA', ...
'/data/MYDATA/TestSNR_15Apr2019_multislice/DICOMS/100_replicas/MR_OPTIMUM.MR._.0018.0003.2019.04.15.23.15.25.226624.332098681.IMA', ...
'/data/MYDATA/TestSNR_15Apr2019_multislice/DICOMS/100_replicas/MR_OPTIMUM.MR._.0018.0004.2019.04.15.23.15.25.226624.332098735.IMA', ...
'/data/MYDATA/TestSNR_15Apr2019_multislice/DICOMS/100_replicas/MR_OPTIMUM.MR._.0018.0005.2019.04.15.23.15.25.226624.332098699.IMA'};

replica2={'/data/MYDATA/TestSNR_15Apr2019_multislice/DICOMS/100_replicas/MR_OPTIMUM.MR._.0019.0001.2019.04.15.23.15.25.226624.332098771.IMA', ...
'/data/MYDATA/TestSNR_15Apr2019_multislice/DICOMS/100_replicas/MR_OPTIMUM.MR._.0019.0002.2019.04.15.23.15.25.226624.332098825.IMA', ...
'/data/MYDATA/TestSNR_15Apr2019_multislice/DICOMS/100_replicas/MR_OPTIMUM.MR._.0019.0003.2019.04.15.23.15.25.226624.332098789.IMA', ...
'/data/MYDATA/TestSNR_15Apr2019_multislice/DICOMS/100_replicas/MR_OPTIMUM.MR._.0019.0004.2019.04.15.23.15.25.226624.332098843.IMA', ...
'/data/MYDATA/TestSNR_15Apr2019_multislice/DICOMS/100_replicas/MR_OPTIMUM.MR._.0019.0005.2019.04.15.23.15.25.226624.332098807.IMA'};




for d=1:5
    dicom_replica1(:,:,d)=dicomread(replica1{d});
    dicom_replica2(:,:,d)=dicomread(replica2{d});
end

%you need to load  P=load('STATIC_ANALYSIS.mat')
RSS1=P.RSS.RECON.Image(:,:,:,1);
RSS2=P.RSS.RECON.Image(:,:,:,2);
B1_1=P.B1.RECON.Image(:,:,:,1);
B1_2=P.B1.RECON.Image(:,:,:,2);
E1_1=P.ESPIRiT1.RECON.Image(:,:,:,1);
E1_2=P.ESPIRiT1.RECON.Image(:,:,:,2);
G1_1=P.GRAPPA1.RECON.Image(:,:,:,1);
G1_2=P.GRAPPA2.RECON.Image(:,:,:,2);


order(1)=1;
order(2)=4;
order(3)=2;
order(4)=5;
order(5)=3;


oRSS_1=rot90(RSS1(:,:,order));
oRSS_2=rot90(RSS2(:,:,order));
oB1_1=rot90(B1_1(:,:,order));
oB1_2=rot90(B1_2(:,:,order));
oE1_1=rot90(E1_1(:,:,order));
oE1_2=rot90(E1_2(:,:,order));
oG1_1=rot90(G1_1(:,:,order));
oG1_2=rot90(G1_2(:,:,order));
    
    end
end
    


d=dicom_replica1(find(MASK));
k=abs(oG1_1(find(MASK)));
scatter(k,d);
[q,m]=polyfit(k,double(d),1);
title(num2str(q))
xlabel('recon')
ylabel('dicom')
hold on
x=[min(k(:)):max(k(:))];
plot(x,polyval(q,double(x)))





%single replica
KDATA='/data/MYDATA/TestSNR_15Apr2019_multislice/RAWDATA/meas_MID00024_FID188178_Multislice.dat';
NOISE='/data/MYDATA/TestSNR_15Apr2019_multislice/RAWDATA/meas_MID00027_FID188181_Multislice_no_RF.dat';


N=cm2DRawDataReader();
N.setIsSignalFile(0)
N.setFilename(NOISE)

S=cm2DRawDataReader();
S.setIsSignalFile(1)
S.setFilename(KDATA)


SL=S.getNumberImageSlices();

KN=spread2DRawDataKSpaceNoiseInChannels(N,1);

reconstruction_rss=cm2DReconRSS();
reconstruction_rss.setNoiseKSpace(double(KN))


for  s=1:SL
    
   
    reconstruction_rss.setSignalKSpace(double(S.getRawDataImageKSpaceSlice(1,1,1,s)));
    R_RSS(:,:,s)=reconstruction_rss.getOutput();


end


    




A=mroSIS(dicomread(image1),MASK,2);