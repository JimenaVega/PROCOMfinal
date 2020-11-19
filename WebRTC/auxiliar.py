# -*- coding: utf-8 -*-
"""
Tecnicas utilizadas para el escalado. 
Escalar el kernel o la imagen.

@author: Emilia Mamaní
"""

## Import Packages
from skimage.exposure import rescale_intensity
import numpy as np
import math
import matplotlib.pyplot as plt
import argparse
import cv2
import sys
from tool._fixedInt import *

#------------------------------------------------------------------------------
#-----------------------------------Functions----------------------------------
#------------------------------------------------------------------------------

#----Flip kernel for convolution----
def flipKernel (kernel):               
    kernel = np.flipud(kernel)
    kernel = np.fliplr(kernel)
    return kernel

#----Kernel determination----creditos a Manu----
def combination (n,r):
    return int(np.power(-1,r)*math.factorial(n))/((math.factorial(r)*math.factorial(n-r)))

def border_kernel(dim):
    row = np.arange(dim)
    for element in range(dim):
        row[element] = combination(dim-1, element)
    diag = np.diag(row)
    ker  = np.array([[0 for x in range(dim)] for y in range(dim)])
    ker [int((dim-1)/2)]=row   
    if dim == 3:
        return ((ker+ker.transpose()+diag+np.fliplr(diag))*-1).astype('float')
    else:
        return ((ker+ker.transpose()+diag+np.fliplr(diag))).astype('float')

#----Handmade convolution----
#--Returns the image, it's height and it's width
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

#----Search max and min values from a matrix----
def search (imMatrix, imHeight, imWidth):
    maxVal = imMatrix[0,0]
    minVal = imMatrix[0,0]
    for i in range(imHeight):
        for j in range(imWidth):
            if (imMatrix[i,j]>maxVal):
                maxVal=imMatrix[i,j]
            elif (imMatrix[i,j]<minVal):
                minVal=imMatrix[i,j]
    return maxVal, minVal

#----Histogram values----
def hist (image):
    unique, counts = np.unique(image, return_counts=True)
    return unique, counts

#----Rescale the processed image----
def scale (imMatrix,maxVal, minVal):   
    imMatrix = (imMatrix-minVal)
    imMatrix = rescale_intensity(imMatrix, in_range=(-minVal,maxVal), out_range=(0.0,255.0))
    imMatrix = imMatrix.astype("uint8")        
    return imMatrix
   
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

#--------Error determination---------------------------
    #--Error cuadrático medio por pixel 
def errorPP(matrixRef, matrixToCompare,form):
    acum=0
    if form=='m':
        Height, Width = matrixRef.shape
        n_pixels      = Height*Width
        for i in range(Height):
                for j in range(Width):
                    if matrixRef[i,j]>matrixToCompare[i,j]:
                        acum+= math.pow(matrixRef[i,j]-matrixToCompare[i,j], 2)
                    elif matrixRef[i,j]<matrixToCompare[i,j]:
                        acum+= math.pow(matrixToCompare[i,j]-matrixRef[i,j], 2)
    elif form=='a':
        n_pixels      = len(matrixRef)
        for i in range( n_pixels):
            if matrixRef[i]>matrixToCompare[i]:
                acum+= math.pow(matrixRef[i]-matrixToCompare[i], 2)
            elif matrixRef[i]<matrixToCompare[i]:
                acum+= math.pow(matrixToCompare[i]-matrixRef[i], 2)
                
    return acum/n_pixels

    #--Error array--
def errorArr(arrRef, arrToCompare):
    errorArray = []
    n_pixels   = len(arrRef)
    for i in range( n_pixels):
       if arrRef[i]>arrToCompare[i]:
          errorArray.append(arrRef[i]-arrToCompare[i])
       else:
          errorArray.append(arrToCompare[i]-arrRef[i])
    return errorArray

#----------Return to float------------------------------
    
def FPtoFloat(array):
    lenght = len(array)
    for n in range(lenght):
            array[n]=array[n].fValue
    return array

#---------SNR Calcule-----------------------------------

def SNRcalc(error, origArray):
    acumSNR1 = 0
    acumSNR2 = 0
    for n in range(len(origArray)):
        #print('n:',n,':',math.pow(error[n], 2))
        acumSNR1  += math.pow(error[n], 2)
        acumSNR2  += math.pow(origArray[n], 2)
    
    #acumSNR1 = math.sqrt(acumSNR1)
    #acumSNR2 = math.sqrt(acumSNR2)
    SNR      = 20*math.log((acumSNR2)/(acumSNR1+0.000001),10)   
    return SNR
#------------------------------------------------------------------------------
#-----------------------------Start--------------------------------------------          
#------------------------------------------------------------------------------
           
ap = argparse.ArgumentParser( description="Convolution 2D: This function compares opencv and interative method.")
ap.add_argument("-i", "--image", required=True, help="Path to the input image")
ap.add_argument("-k", "--kernel", help="Path to the kernel")
args = ap.parse_args()

#Load input image 
image  = cv2.imread(args.image,1)

#Kernel to use
print('*'*70)
print('Choose kernel dimensions:')
print('3- 3x3')
print('9- 9x9')
print('13- 13x13')
print('*'*70)

dim = input()

kernel = border_kernel(int(dim))

#Convert image to gray scale
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
#cv2.imshow("Gray scale image", gray)

#----Reference openCv output----
kernelF         = flipKernel (kernel)
opencvOutput    = (cv2.filter2D(gray, -1, kernelF))
xOpenCv,yOpenCv = hist(opencvOutput)
cv2.imshow("Filtro 2D - opencv ORIGINAL", opencvOutput)

#----Image normalization----
MaxIm     = 255.0
MinIm     = 0.0
newMaxIm  = 1.0
newMinIm  = 0.0
    #--Linear--
imageNormLin        = linearNorm(gray, MaxIm, MinIm, newMaxIm, newMinIm)

#----Kernel normalization----
kernelR    = kernel.ravel()
maxKernel  = max(abs(kernelR))

    #--Linear--
kernelL    = kernelNorm(kernel, maxKernel, 'linear')

#----Kernel flip----
kernelLNorm                   = flipKernel (kernelL)

#----Handmade convolution output LINEAR NORM----

imMatrix, imHeight, imWidth   = conv2D(imageNormLin, kernelLNorm)
maxVal, minVal                = search(imMatrix, imHeight, imWidth) 
conv2DOutput                  = scale(imMatrix,maxVal, minVal)
xConv,yConv                   = hist(conv2DOutput)

cv2.imshow("Filtro 2D - Handmade convolution linear norm", conv2DOutput)


#------------------------------------------------------------------------------
#---------------------------Size Verification----------------------------------          
#------------------------------------------------------------------------------

origHeight, origWidth = opencvOutput.shape
Height2, Width2       = conv2DOutput.shape
kHeight, kWidth       = kernel.shape

print('*'*70)
print('SIZES VERIFICATION:')
print('original: H:',origHeight,'W:', origWidth)
print('linear: H:', Height2,'W:', Width2)
print('*'*70)


#------------------------------------------------------------------------------
#----------------------------Fixed Point-----------------------------------------          
#------------------------------------------------------------------------------

    #--Kernel--
kernelLArray = kernelLNorm.ravel()

    #--Original Image--
           
origLinImArray      = imageNormLin.ravel()

#-----------------------------------------------------------------------------
#----Processing with the Fixed Point To Float Image----
nK =6
nIm=6
kernelLFP         = arrayFixedInt(2+nK, nK, kernelLArray  , signedMode='S', roundMode='trunc', saturateMode='saturate')
origLinearNormFP  = arrayFixedInt(1+nIm, nIm, origLinImArray, signedMode='U', roundMode='trunc', saturateMode='saturate')

kernelLF          = FPtoFloat(kernelLFP)
origLinearNormF   = FPtoFloat(origLinearNormFP)

kernelLF          = kernelLF.reshape(kHeight, kWidth)
origLinearNormF   = origLinearNormF.reshape(origHeight, origWidth)

    #--Handmade convolution output: LINEAR NORM Fixed Point--

imMatrix, imHeight, imWidth   = conv2D(origLinearNormF, kernelLF)

maxVal, minVal                = search(imMatrix, imHeight, imWidth) 
conv2DOutputFP2F              = scale(imMatrix,maxVal, minVal)
cv2.imshow("Filtro 2D - Handmade convolution linear norm FP", conv2DOutputFP2F)

cv2.waitKey(0)
cv2.destroyAllWindows()


