import argparse
from pynico_eros_montin import pynico as pn
from pyable_eros_montin import imaginable as ima
from mro import RECON,SNR,KELLMAN
import cloudmrhub.cm2D as cm2D
import cloudmrhub.cm as cm
import matplotlib.pyplot as plt
RECON_f=[cm2D.cm2DReconRSS,cm2D.cm2DKellmanB1,cm2D.cm2DKellmanmSense,cm2D.cm2DReconmSense,cm2D.cm2DReconGrappa]
SNR_f=[None,cm2D.cm2DSignalToNoiseRatioMultipleReplicas,cm2D.cm2DSignalToNoiseRatioPseudoMultipleReplicas,cm2D.cm2DSignalToNoiseRatioPseudoMultipleReplicasWen]


def undersample(K,recon):
    N=recon["name"].lower()
    if N=='sense':
        return cm.undersample2DDataSENSE(K, frequencyacceleration=recon["options"]["accelerations"][0],phaseacceleration=recon["options"]["accelerations"][1]),False
    if N=="msense":
        return cm.undersample2DDatamSENSE(K, frequencyacceleration=recon["options"]["accelerations"][0],phaseacceleration=recon["options"]["accelerations"][1],phaseACL=recon["options"]["acl"][1]),True
    if N=="grappa":
        return cm.undersample2DDatamGRAPPA(K, frequencyacceleration=recon["options"]["accelerations"][0],phaseacceleration=recon["options"]["accelerations"][1],frequencyACL=recon["options"]["acl"][0],phaseACL=recon["options"]["acl"][1]),True
    
def replicas(reconstructor,snrmethod,NR=None,boxsize=None):
    L2=snrmethod
    if NR:
        L2.numberOfReplicas=NR
    if boxsize:
        L2.boxSize=10
    L2.reconstructor=reconstructor
    return L2.getOutput()

import boto3

s3 = boto3.client('s3')


def getFile(s):
    """
    
    Args:
        s (_type_): _description_
    
    Returns:
      fn (str): position of the file in the local filesystem

    """
    if (s["type"].lower()=='local'):
        return s["filename"]
    elif (s["type"].lower()=='s3'):
        T=pn.createRandomTemporaryPathableFromFileName(s["filename"])
        with open(T, 'wb') as f:
            s3.download_fileobj(s["bucket"],s["key"], f)
        return T
    else:
        raise Exception("I can't get this file modality")

import twixtools
import numpy as np
from raider_eros_montin import raider

def getSiemensKSpace2DInformation(s,raid=0):
    N=pn.Pathable(getFile(s["options"]))
    n=N.getPosition()
    twix=twixtools.map_twix(n)
    H=twix[raid]["hdr"]
    SA=H["Phoenix"]['sSliceArray']
 
    C=H["Config"]
    KS=[int(a) for a in [C['BaseResolution'],C['PhaseEncodingLines']]]
    slices=[]
    SL=SA["asSlice"]
    for t in SA['alSliceAcqOrder'][1:]:
        sl=SL[t]
        slp=SL[t]['sPosition']
        o={
            "fov":[sl["dReadoutFOV"],sl["dPhaseFOV"],sl["dThickness"]*SA["lSize"]],
            "spacing":[sl["dReadoutFOV"]/KS[0],sl["dPhaseFOV"]/KS[1],sl["dThickness"]],
            "origin":[slp["dSag"],slp["dCor"],slp["dTra"]],
            "size":[*KS,1],
            "KSpace":
        }
        if sl['sNormal']["dTra"]:
            o["direction"]=np.eye(3)
            o["direction"][-1:-1]=sl['sNormal']["dTra"]
        slices.append(o)
    return slices







def getSiemensKSpace2D(n,noise=False,aveRepetition=True,slice=0,raid=0):
    
    twix=twixtools.map_twix(n)
    im_array = twix[raid]['image']
    im_array.flags['remove_os'] = not noise  # activate automatic os removal

    if noise:
        im_array.flags['average']['Rep'] = False  # average all repetitions
        im_array.flags['average']['Ave'] = False # average all repetitions
    else:
        im_array.flags['average']['Rep'] = aveRepetition  # average all repetitions
        im_array.flags['average']['Ave'] = True # average all repetitions

    return np.transpose(im_array[0,0,0,0,0,0,0,0,0,0,0,slice,0,:,:,:],[2,0,1])

def getNoiseKSpace(s,slice=0):
    """
    
    Args:
        s (_type_): _description_
    
    Returns:
      fn (str): position of the file in the local filesystem

    """
    N=pn.Pathable(getFile(s["options"]))

    if N.getExtension() == 'dat':
        if (s["options"]["multiraid"]):
                K=getSiemensKSpace2D(N.getPosition(),noise=True,slice=slice,raid=0)
                return K
        else: 
            return getSiemensKSpace2D(N.getPosition(),noise=True,slice=slice)
    else:
        raise Exception("I can't get the noise")


def getKSpace(s,slice=0):
    """
    
    Args:
        s (_type_): _description_
    
    Returns:
      fn (str): position of the file in the local filesystem

    """
    N=pn.Pathable(getFile(s["options"]))

    if N.getExtension() == 'dat':
        if (s["options"]["multiraid"]):
                K=getSiemensKSpace2D(N.getPosition(),noise=False,slice=0,raid=1)
                return K
        else: 
            return getSiemensKSpace2D(N.getPosition(),noise=False,slice=0)
    else:
        raise Exception("I can't get the noise")



if __name__=="__main__":
    parser = argparse.ArgumentParser(
                        prog='Mroptimum',
                        description='Calculates SNR as it should be done!',
                        epilog='cloudmrhub.com')


    parser.add_argument('-j','--joptions', type=str, help='optionfile with the backbone of the calculation')
    parser.add_argument('-o','--output', type=str, help='output path')
    parser.add_argument('-l','--louput', type=str, help='output log file')
    parser.add_argument('-c','--coilsense', type=str, help='otput zip file')
    parser.add_argument('-g','--gfactor', type=str, help='otput zip file')

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

    SNR=np.zeros((*SL[0]['size'][:2],len(SL)))

        #instantiate the recon
    for counter,slice in enumerate(SL):
        r=THERECON()
        S=getKSpace(R["options"]["signal"],counter)
        r.setNoiseKSpace(getNoiseKSpace(R["options"]["noise"],counter))
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
            snr=r.getOutput()
            if args.output:
                SNR[:,:,counter]=snr  
            
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
            snr=replicas(r,s,NR,boxSize)
            if args.output:
                SNR[:,:,counter]=snr            


    if args.output:
        ISNR=ima.numpyToImaginable(SNR)
        ISNR.setImageDirection(SL[0]["direction"].flatten())
        ISNR.setImageSpacing(SL[0]["spacing"])
        ISNR.setImageOrigin(SL[0]["origin"])
        

        IMAOUT=[["SNR",ISNR,'data/snr.nii.gz']]
        J={
        };
        O=pn.Pathable(args.output)
        for n,imm,pos in IMAOUT:
            O.addBaseName(pos)
            O.ensureDirectoryExistence()
            imm.writeImageAs(O.getPosition())
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
    


