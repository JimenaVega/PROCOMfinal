## Import Packages
from   skimage.exposure import rescale_intensity
import numpy as np
import matplotlib.pyplot as plt
import argparse
import cv2

import time
#---------------------- image reading-------------------------------------------

path  = r'C:\Users\asus\GIT_DATA_FP_PROCOM\TRABAJO_FINAL_PROCOM\PROCOMfinal\uP_VitisPython_test\foto1.jpg'
path1 = r'C:\Users\asus\GIT_DATA_FP_PROCOM\TRABAJO_FINAL_PROCOM\PROCOMfinal\uP_VitisPython_test\receivedImage1.jpg'
path2 = r'C:\Users\asus\GIT_DATA_FP_PROCOM\TRABAJO_FINAL_PROCOM\PROCOMfinal\uP_VitisPython_test\decimatedImage_local.jpg'

image     = cv2.imread(path,0)
processed = cv2.imread(path1,0)
decimated = cv2.imread(path2,0)

[ROWIM,COLIM]   = image.shape
[ROWIMP,COLIMP] = processed.shape
[ROWIMD,COLIMD] = decimated.shape

print("rows image= {0} \tcolumns image= {1}".format(ROWIM,COLIM))
print("rows processed= {0} \tcolumns processed= {1}".format(ROWIMP,COLIMP))
print("rows decimated= {0} \tcolumns decimated= {1}".format(ROWIMD,COLIMD))

#Decimate image 
imReconsDecimation = []
imReconsDecimation = processed[0::4,:]

print("Decimated image:")
print(imReconsDecimation)

print("Original Image:")
print(image)


print("Primera columna imagen original:")
for n in range(ROWIM):
    print(image[n,1])

print("Primera columna imagen decimada:")
for n in range(ROWIM):
    print(decimated[n,1])

'''
print("Final size post decimation:")
print(imReconsDecimation.shape)

print("COMPARACION DE MATRICES")
print("Returned image:")
print(processedGray)
print("Original image:")
print(gray)
'''

#Guardar las imagenes resultantes
#filename1 = 'sentImage.jpg'
#filename3 = r'C:\Users\asus\GIT_DATA_FP_PROCOM\TRABAJO_FINAL_PROCOM\PROCOMfinal\uP_VitisPython_test\decimatedImage_local.jpg'

#cv2.imwrite(filename1, gray)
#cv2.imwrite(filename3, imReconsDecimation)

print("Finished processing/r/n")
