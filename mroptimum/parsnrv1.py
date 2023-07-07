import argparse
from pynico_eros_montin import pynico as pn
from pyable_eros_montin import imaginable as ima
from mro import *
import cloudmrhub.cm2D as cm2D
RECON_f=[cm2D.cm2DReconRSS,cm2D.cm2DKellmanB1,cm2D.cm2DKellmanmSense,cm2D.cm2DReconmSense,cm2D.cm2DReconGrappa]
G_f=[None,None,cm2D.cm2DGfactorSense,cm2D.cm2DGfactormSense,cm2D.cm2DReconGrappa]
SNR_f=[None,cm2D.cm2DSignalToNoiseRatioMultipleReplicas,cm2D.cm2DSignalToNoiseRatioPseudoMultipleReplicas,cm2D.cm2DSignalToNoiseRatioPseudoMultipleReplicasWen]


    


if __name__=="__main__":
    parser = argparse.ArgumentParser(
                        prog='Mroptimum',
                        description='Calculates SNR as it should be done!',
                        epilog='cloudmrhub.com')


    parser.add_argument('-j','--joptions', type=str, help='optionfile with the backbone of the calculation')
    parser.add_argument('-o','--output', type=str, help='output path')
    parser.add_argument('-l','--louput', type=str, help='output log file')
    parser.add_argument('-c','--coilsense', type=bool, help='output coil sensitivities')
    parser.add_argument('-g','--gfactor', type=bool, help='otput g-factor')
    parser.add_argument('-f','--outputformat', choices=['mat','cmr','nifti','mha'],type=str, help='otput g-factor')

    args = parser.parse_args()

    print(args)
    O=pn.Pathable(args.joptions)
    J=O.readJson()

    
    if J["version"]!="v0":
        raise Exception("dunno what to do with this i only know version v0")
    

    #which reconstructor has been requested
    R=J["options"]["reconstructor"]
    RID=RECON.index(R["name"].lower())
    SID=SNR.index(J["name"].lower())
    
    #how many slices
    SL=getSiemensKSpace2DInformation(R["options"]["signal"])
    # if it's analitical    
    if (SID==0) and (RID<5):
        THERECON=KELLMAN[RID]
    else:
        #otherwise i go with the other methods of snr
        THERECON=RECON_f[RID]
    NN=cm2D.cm2DRecon()
    NOISE=getNoiseKSpace(R["options"]["noise"],'all')
    BN=NOISE[0]
    for tn in range(1,len(NOISE)):
        BN=np.concatenate((BN,NOISE[tn]),axis=1)
    NN.setNoiseKSpace(BN)
    NC=NN.getNoiseCovariance()
    SNR=np.zeros((*SL[0]['size'][:2],len(SL)))

    TASK=[]
        #instantiate the recon
    for counter,slice in enumerate(SL):
        r=THERECON()
        S=slice['KSpace'] #getKSpace(R["options"]["signal"],counter)
        r.setNoiseCovariance(NC)
        if r.HasAcceleration:
            r.AccelerationF,r.AccelerationP=R["options"]["accelerations"]
        if R["options"]["mimicKspace"]:
            UK,ac=undersample(S,R)
            r.setSignalKSpace(UK)
        else:
            r.setSignalKSpace(S)
        if ac:
            r.AutocalibrationF,r.AutocalibrationP=R["options"]["acl"]
        if r.HasSensitivity:
            r.setCoilSensitivityMatrixCalculationMethod(R["options"]["sensitivityMap"]["name"])
        if ((r.HasAcceleration) and (not r.HasSensitivity)):
            # this is grappa:
            r.setGrappaKernel(R["options"]["kernelSize"])

        if SID==0:
            TASK.append([r,counter])  
            
        else:
            SN=SNR_f[SID]
            s=SN()

            try:
                NR=J["options"]["NR"]
            except:
                NR=None

            try:
                boxSize=J["options"]["boxSize"]
            except:
                boxSize=None
            
            TASK.append(mreplicas(r,s,NR,boxSize,counter))
            
    
    p=mlp.Pool()
    dd=p.map(rT,TASK)
    p.close()
    for sn,cc in dd:
        SNR[:,:,cc]=np.abs(sn)


    IMAOUT=[]



    if args.coilsense:
        if r.HasSensitivity:
            SENS=np.zeros((*S.shape[0:2],len(TASK), S.shape[-1]),dtype=S.dtype)
            for ic,ia in enumerate(TASK):
                SENS[:,:,ic,:]=ia.reconstructor.getCoilSensitivityMatrix()
            
            for nn in range(SENS.shape[-1]):
                IMAOUT.append([2,3,f"Coil Sensitivity Map {nn:02d}",ima.numpyToImaginable(SENS[:,:,:,nn]),f'data/coilsense{nn:02d}.nii.gz'])

    
    if args.gfactor:
        if r.HasSensitivity:
            G=np.zeros_like(SNR)
            for ic,ia in enumerate(TASK):
                ia.reconstructor.__class__=G_f[RID]
                G[:,:,ic]=np.abs(ia.reconstructor.getOutput())
            IMAOUT.append([3,3,"GFactor",ima.numpyToImaginable(G),'data/gfactor.nii.gz'])
    

    if args.output:
        ISNR=ima.numpyToImaginable(SNR)
        IMAOUT.append([1,3,"SNR",ISNR,'data/snr.nii.gz'])
    
    
    if len(IMAOUT)>0:
        direction=SL[0]["direction"].flatten()
        spacing=SL[0]["spacing"]
        origin=SL[0]["origin"]
        J={
        };
        O=pn.Pathable(args.output)
        for id,dim,n,imm,pos in IMAOUT:
            O.addBaseName(pos)
            O.ensureDirectoryExistence()
            if dim==3:
                saveImage(imm,origin,spacing,direction,O.getPosition())
            O.undo()
            J[n]=pos
        O.addBaseName('info.json')
        O.writeJson(J)

        
        

    



# FA=1
# PA=2
# ACLF=20
# ACLP=20
# GK=[3,2]

# L=cm2D.cm2DReconGrappa()
# L.AccelerationF=FA
# L.AccelerationP=PA
# L.AutocalibrationF=ACLF
# L.AutocalibrationP=ACLP
# US=cm.undersample2DDatamGRAPPA(S,frequencyacceleration=FA,phaseacceleration=PA,frequencyACL=ACLF,phaseACL=ACLP)
# L.setSignalKSpace(US)
# L.setNoiseKSpace(N)
# L.setGrappaKernel(GK)


# L2=cm2D.cm2DSignalToNoiseRatioPseudoMultipleReplicas()

# L2.numberOfReplicas=100
# L2.reconstructor=L

# plt.subplot(121)
# plt.imshow(L2.getOutput(),vmax=250)
# plt.title('PMR')
# plt.colorbar()

# R2=cm2D.cm2DSignalToNoiseRatioPseudoMultipleReplicasWen()
# R=cm2D.cm2DReconRSS()
# R2.numberOfReplicas=5
# R2.boxSize=10
# R.setNoiseKSpace(N)
# R.setSignalKSpace(S)
# R2.reconstructor=R






# plt.subplot(122)
# plt.imshow(R2.getOutput(),vmax=250)
# plt.title('CR')
# plt.colorbar()



# plt.show()








# L2=cm2D.cm2DSignalToNoiseRatioPseudoMultipleReplicas()
# L=cm2D.cm2DReconRSS()
# L2.numberOfReplicas=100
# L.setNoiseKSpace(N)
# L.setSignalKSpace(S)
# L2.reconstructor=L

# plt.subplot(221)
# plt.imshow(L2.getOutput(),vmax=250)
# plt.title('PMR')
# plt.colorbar()

# R2=cm2D.cm2DSignalToNoiseRatioPseudoMultipleReplicasWen()
# R=cm2D.cm2DReconRSS()
# R2.numberOfReplicas=5
# R2.boxSize=10
# R.setNoiseKSpace(N)
# R.setSignalKSpace(S)
# R2.reconstructor=R






# plt.subplot(222)
# plt.imshow(R2.getOutput(),vmax=250)
# plt.title('CR')
# plt.colorbar()

# R=cm2D.cm2DKellmanRSS()
# R.setNoiseKSpace(N)
# R.setSignalKSpace(S)
# plt.subplot(223)
# plt.imshow(R.getOutput(),vmax=250)
# plt.title('Kellman')
# plt.colorbar()


# plt.show()



# FA=1
# PA=2
# ACL=20
# L=cm2D.cm2DReconSense()
# L.AccelerationF=FA
# L.AccelerationP=PA

# US=cm.undersample2DDataSENSE(S,frequencyacceleration=FA,phaseacceleration=PA)

# L.setSignalKSpace(US)
# L.setNoiseKSpace(N)
# L.setCoilSensitivityMatrixSource(S)
# L.setCoilSensitivityMatrixCalculationMethod('inner')

# plt.figure()
# plt.imshow(np.abs(L.getOutput()))
# plt.colorbar()
# plt.title('recon')


# # transform in Kellman!!!
# L.__class__=cm2D.cm2DKellmanSense

# plt.figure()
# plt.imshow(np.abs(L.getOutput()))
# plt.colorbar()
# plt.title('SNR')

# # transform in Kellman!!!
# L.__class__=cm2D.cm2DGfactorSense

# plt.figure()
# plt.imshow(np.abs(L.getOutput()))
# plt.colorbar()
# plt.title('GFactor')
# plt.show()
    


