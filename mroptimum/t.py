import pyable_eros_montin.imaginable as ima
import numpy as np  

L=np.tile(np.array([1,2,3,4,5,6,7,8,9,10]),(10,1))
# use itk to save the image and metadata
import itk
img=itk.GetImageFromArray(L)
itk.imwrite(img,'test.tif')
