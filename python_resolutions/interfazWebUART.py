# -*- coding: utf-8 -*-
"""
Created on Fri Jul 24 17:14:51 2020

@author: Jimena
"""

## Import Packages
from   skimage.exposure import rescale_intensity
import numpy as np
import math
import matplotlib.pyplot as plt
import argparse
import cv2
import sys
from   tool._fixedInt import *
import serial




#---------Normalization tecniques (images)-------------
def linearNorm (matrix, Max, Min, newMax, newMin):
    matrix=(matrix-Min)*((newMax-newMin)/(Max-Min))+newMin
    return matrix

def standarNorm (matrix):
    matrix = (matrix - np.mean(matrix)) / np.std(matrix)
    return matrix

#---------Normalization tecniques (kernel)-------------
def kernelNorm(kernel, maxValAbs, norm):
    if norm=='linear':
        kernel = kernel/maxValAbs
        return kernel
    elif norm=='standar':
        kernel = (kernel - np.mean(kernel)) / np.std(kernel)
        return kernel

def quantize(matrix,NB,NBF):
    flattenMatrix = np.ravel(matrix.T) #se aplasta por columnas
    quantMatrix   = arrayFixedInt(NB,NBF,flattenMatrix, signedMode='S', roundMode='trunc', saturateMode='saturate')
    return quantMatrix

def sendData(image,command,rowImage):
    
    while 1 :
   
        if(command == 'exit'):
             ser.close()
             exit()
        else:
    
            for ptr in range(rowImage):
                ser.write(image[ptr])
                #time.sleep(1)
    
            out = ''
    
            while ser.inWaiting() > 0:
                out += ser.read(1)
    
            if out != '':
                print (">> " + out)
    
# In[0]: configuracion puerto serie

ser = serial.serial_for_url('loop://', timeout=1)


# ser = serial.Serial(
#     port     = '/dev/ttyUSB1',
#     baudrate = 9600,
#     parity   = serial.PARITY_NONE,
#     stopbits = serial.STOPBITS_ONE,
#     bytesize = serial.EIGHTBITS
# )

ser.isOpen()
ser.timeout=None
ser.flushInput()
ser.flushOutput()
print(ser.timeout)


# In[1]: Main
path = "descarga.jpg"
#path = "foto1.jpg"

ap = argparse.ArgumentParser( description="Convolution 2D")
ap.add_argument("-i", "--image", required=False, help="Path to the input image",default=path)
ap.add_argument("-k", "--kernel", help="Path to the kernel")
args = ap.parse_args()

#Load input image 
image  = cv2.imread(args.image,1)

[rowImage,colImage] = image.shape

#Kernel to use
kernel = np.array((
    	[-1, -1, -1],
    	[-1,  8, -1],
    	[-1, -1, -1]), dtype="float")

#Convert image to gray scale
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
#cv2.imshow("Gray scale image", gray)


#----Image normalization----
MaxIm     = 255.0
MinIm     = 0.0
newMaxIm  = 1.0
newMinIm  = 0.0
    #--Linear--
imageNormLin        = linearNorm(gray, MaxIm, MinIm, newMaxIm, newMinIm)
    #--Standarization--
#imageStandarization = standarNorm(gray)


#----Kernel normalization----
maxKernel  = 8.0
    #--Linear--
kernelL    = kernelNorm(kernel, maxKernel, 'linear')
    #--Standarization--
#kernelS    = kernelNorm(kernel, maxKernel, 'standar')

#----Kernel flip----
kernelLNorm                   = flipKernel (kernelL)
#kernelSNorm                   = flipKernel (kernelS)


#------------------------------------------------------------------------------
#----------------------------Fixed Point---------------------------------------          
#------------------------------------------------------------------------------


#kernel cuantizado con S(8,6)
quantKernel = quantize(kernelLNorm,8,6)
#imagen cuantizada con S(7,6)
quantImage  = quantize(imageNormLin,7,6)


#------------------------------------------------------------------------------
#----------------------------------UART---------------------------------------          
#------------------------------------------------------------------------------

