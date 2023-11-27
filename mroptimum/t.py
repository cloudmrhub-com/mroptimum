import cloudmrhub.cm2D as cm2D
from pynico_eros_montin import pynico as pn
import numpy as np
import matplotlib.pyplot as plt

import twixtools as tx
import numpy as np 

import matplotlib.pyplot as plt

import cloudmrhub.cm as cm

from  mro import *

# s='/data/MYDATA/siemensrawdataexamples/Sebastian/raw/meas_MID02696_FID183824_gre_GRAPPA_2.dat'
s='/data/MYDATA/siemensrawdataexamples/Sebastian/raw/meas_MID02699_FID183827_gre_mSENSE_2.dat'
twix=tx.map_twix(s)
H=twix[1]["hdr"]
iPat=H['MeasYaps']['sPat']


print(iPat)
sl=0
print('---signal----')
im_array = twix[1]['image']
im_array.flags['remove_os'] = True  # activate automatic os removal
im_array.flags['average']['Rep'] = True  # average all repetitions
im_array.flags['average']['Ave'] = True # average all repetitions

signal=cm.fixAccelratedKSpace2D(np.transpose(im_array[0,0,0,0,0,0,0,0,0,0,sl,0,0,:,:,:],[2,0,1]),2)
print('---noise----')
n_array = twix[0]['noise']

n_array.flags['average']['Rep'] = True  # average all repetitions
im_array.flags['average']['Ave'] = True # average all repetitions


noise=np.transpose(n_array[0,0,0,0,0,0,0,0,0,0,sl,0,0,:,:,:],[2,0,1])  


print('---refscan----')
r_array = twix[1]['refscan']
r_array.flags['remove_os'] = True  # activate automatic os removal
r_array.flags['average']['Rep'] = True  # average all repetitions
r_array.flags['average']['Ave'] = True # average all repetitions

ref_=np.transpose(r_array[0,0,0,0,0,0,0,0,0,0,sl,0,0,:,:,:],[2,0,1])  
n_ref=ref_.shape[1]

ref=np.zeros_like(signal)
ref[:,0:n_ref]=ref_


O=dict()
O["signal"]=signal
O["noise"]=noise
O["noisecovariance"]=None
O["reference"]=ref
O["mimic"]=False
O["accelleration"]=[1,int(iPat['lAccelFactPE'])]
O["autocalibration"]=[np.nan,int(iPat['lRefLinesPE'])]
O["grappakernel"]=None
O["slice"]=1

# reconstructor=cm2D.cm2DKellmanSENSE()


# OUT=calcKellmanSNR(reconstructor,O)



reconstructor=cm2D.cm2DReconSENSE()

# O["NR"]=4
# OUT=calcPseudoMultipleReplicasSNR(reconstructor,O)


O["NR"]=2
O["boxSize"]=2
OUT=calcPseudoMultipleReplicasSNRWien(reconstructor,O)


print(OUT["SNR"])
# s="/data/MYDATA/siemensrawdataexamples/15042019_MR/meas_MID00036_FID188190_Multislice_100_REPLICAS.dat"

# twix=twixtools.map_twix(s)
# im_array = twix[0]['image']
# im_array.flags['remove_os'] = True  # activate automatic os removal
# im_array.flags['average']['Rep'] = False  # average all repetitions
# im_array.flags['average']['Ave'] = True  # average all repetitions
# SL=0
# S=np.transpose(im_array[0,0,0,0,0,0,0,:,0,0,0,SL,0,:,:,:],[0,3,1,2])
# O["signal"]=S

# O["mimic"]=True
# O["accelleration"]=[1,int(iPat['lAccelFactPE'])]
# O["autocalibration"]=[np.nan,int(iPat['lRefLinesPE'])]
# O["noise"]=None

# OUT=calcMultipleReplicasSNR(reconstructor,O)



print(OUT["SNR"])
