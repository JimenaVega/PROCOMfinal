# -*- coding: utf-8 -*-
"""
Created on Fri Dec 18 15:48:15 2020

@author: 
@Description: test de envio y recepcion de imagen pero sin cuantificacion ni rescalado.

"""

## Import Packages
from   skimage.exposure import rescale_intensity
import numpy as np
import matplotlib.pyplot as plt
import argparse
import cv2
from   tool._fixedInt import *
import serial
import time

# In[]: Funciones
#kernel stuff
def kernelNorm(kernel, maxValAbs, norm):
    if norm=='linear':
        kernel = kernel/maxValAbs
        return kernel
    elif norm=='standar':
        kernel = (kernel - np.mean(kernel)) / np.std(kernel)
        return kernel


def flipKernel (kernel):               
    kernel = np.flipud(kernel)
    kernel = np.fliplr(kernel)
    return kernel


def conv2D (image, kernel):

    imHeight, imWidth = image.shape
    kHeight , kWidth  = kernel.shape
    center    = int(kHeight-(kHeight+1)/2)
    imConv2D  = np.zeros((int(imHeight),int(imWidth)))    
    
    for n in range (int(imHeight)):
        for m in range (int(imWidth)):
            row     = n-center
            col     = m-center
            element = 0        
            for i in range(int(kHeight)):
                for j in range(int(kWidth)):
                   if (row+i)>= 0 and (col+j)>=0 and (row+i)<imHeight and (col+j)<imWidth:
                      element += image[row+i,m-center+j]*kernel[i,j]            
            imConv2D[n,m]=element 
    return imConv2D,imHeight,imWidth



def linearScalling (imMatrix,maxVal, minVal, newMax, newMin):  
    
    imMatrix = (imMatrix-minVal)
    imMatrix = rescale_intensity(imMatrix,in_range=(-minVal,maxVal), out_range=(newMin,newMax))

    return imMatrix


def linearNorm (matrix, Max, Min, newMax, newMin):
    
    matrix=(matrix-Min)*((newMax-newMin)/(Max-Min))+newMin
    return matrix


def quantize (matrix,NB,NBF,sign):
    
    flattenMatrix = np.ravel(matrix.T) #se aplasta por columnas
   
    if (sign == 'S'):
        quantMatrix   = arrayFixedInt(NB,NBF,flattenMatrix, signedMode='S', roundMode='trunc', saturateMode='saturate')
        packedMatrix  = np.zeros(len(quantMatrix), dtype='int')
    elif (sign == 'U'):
        quantMatrix   = arrayFixedInt(NB,NBF,flattenMatrix, signedMode='U', roundMode='trunc', saturateMode='saturate')
        packedMatrix  = np.zeros(len(quantMatrix), dtype='int')
    
    for i in range(len(quantMatrix)):
        packedMatrix[i] = quantMatrix[i].intvalue
    
    return packedMatrix


def fixedToFloat(NB,NBF,signedMode,num):
    
	if  (signedMode=='S'):
		return (((num+2**(NB-1))&((2**NB)-1))-2**(NB-1))/(2**NBF)
	elif(signedMode=='U'):
		return num/(2**NBF)
    
    
#Histograms
def hist (image):
    
    unique, counts = np.unique(image, return_counts=True)
    return unique, counts

def plotHist(conv_image,name,pos):
    [x  ,y]   = np.unique(conv_image,return_counts=True)
    plt.subplot(2,1,pos)
    plt.stem(x,y,'ko',label=name,use_line_collection=True)
    plt.legend()
    plt.grid()
    
    plt.show()

def searchXtremeValues (imMatrix, imHeight, imWidth):
    maxVal = imMatrix[0,0]
    minVal = imMatrix[0,0]
    for i in range(imHeight):
        for j in range(imWidth):
            if (imMatrix[i,j]>maxVal):
                maxVal=imMatrix[i,j]
            elif (imMatrix[i,j]<minVal):
                minVal=imMatrix[i,j]
    return maxVal, minVal

def saveTofileMatrix(matrix, fileName):
    file = open(fileName, "w")
    for i in range(ROWIM): 
        for j in range(COLIM):
            file.write("{0}\n".format(matrix[i][j]))
    file.close()

# In[1]:

path = "descarga.jpg"
#path = "foto1.jpg"

ap = argparse.ArgumentParser( description="Convolution 2D")
ap.add_argument("-i", "--image", required=False, help="Path to the input image",default=path)
ap.add_argument("-k", "--kernel", help="Path to the kernel")
args = ap.parse_args()

#Load input image 
image   = cv2.imread(args.image,1)
endFlag = 0                                        


#Kernel to use momentaneamente 
kernel = np.array((
    	[-1, -1, -1],
    	[-1,  8, -1],
    	[-1, -1, -1]), dtype="float")

#Convert image to gray scale
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
cv2.imshow("gray ", gray)
[ROWIM,COLIM] = gray.shape
print("rows image= {0} \tcolumns image= {1}".format(ROWIM,COLIM))


#kernel flip
kernelFlipped  = flipKernel (kernel)

#convolucion
[conv2Dout, imHeight, imWidth] = conv2D(gray, kernelFlipped)

valMax = np.amax(conv2Dout)
valMin = np.amin(conv2Dout)

imClipped = conv2Dout

#clipeado
for i in range(ROWIM):
    for j in range(COLIM):
        if (conv2Dout[i][j] > 255):
            imClipped[i][j] = 255
        elif (conv2Dout[i][j] < 0):
            imClipped[i][j] = 0 
        else:
            imClipped[i][j] = conv2Dout[i][j]
         
#casteo uint8
convFinal = imClipped.astype('uint8')

# grafico e imagen
plotHist(convFinal, 'lineal reconstructed',1)
cv2.imshow("2 image after UART ", convFinal)



























