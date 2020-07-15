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
def scale (imMatrix,maxVal, minVal, norm):   
    if norm=='linear': 
        imMatrix = (imMatrix-minVal)
        imMatrix = rescale_intensity(imMatrix,in_range=(-minVal,maxVal), out_range=(0.0,255.0))
        #imMatrix = imMatrix.astype("uint8")
        
    elif norm=='standar':
        imMatrix = (imMatrix-minVal)
        imMatrix = rescale_intensity(imMatrix, in_range=(-minVal,maxVal), out_range=(0.0,255.0))  
        #imMatrix = imMatrix.astype("uint8")
        
    return imMatrix
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
    #--Error por pixel 
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
kernel = np.array((
    	[-1, -1, -1],
    	[-1,  8, -1],
    	[-1, -1, -1]), dtype="float")

#Convert image to gray scale
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
#cv2.imshow("Gray scale image", gray)

#----Reference openCv output----
kernelF         = flipKernel (kernel)
opencvOutput    = cv2.filter2D(gray, -1, kernelF)
xOpenCv,yOpenCv = hist(opencvOutput)
#cv2.imshow("Filtro 2D - opencv", opencvOutput)

#----Image normalization----
MaxIm     = 255.0
MinIm     = 0.0
newMaxIm  = 1.0
newMinIm  = 0.0
    #--Linear--
imageNormLin        = linearNorm(gray, MaxIm, MinIm, newMaxIm, newMinIm)
    #--Standarization--
imageStandarization = standarNorm(gray)


#----Kernel normalization----
maxKernel  = 8.0
    #--Linear--
kernelL    = kernelNorm(kernel, maxKernel, 'linear')
    #--Standarization--
kernelS    = kernelNorm(kernel, maxKernel, 'standar')


#----Kernel flip----
kernelLNorm                   = flipKernel (kernelL)
kernelSNorm                   = flipKernel (kernelS)

#----Handmade convolution output LINEAR NORM----

imMatrix, imHeight, imWidth   = conv2D(imageNormLin, kernelLNorm)
maxVal, minVal                = search(imMatrix, imHeight, imWidth) 
conv2DOutput                  = scale(imMatrix,maxVal, minVal, 'linear')
xConv,yConv                   = hist(conv2DOutput)

#cv2.imshow("Filtro 2D - Handmade convolution linear norm", conv2DOutput)

#----Handmade convolution output STANDARIZATION----
imMatrix2, imHeight, imWidth  = conv2D(imageStandarization, kernelSNorm)
maxVal, minVal                = search(imMatrix, imHeight, imWidth) 
conv2DOutput2                 = scale(imMatrix2,maxVal, minVal,'standar')
xConv2,yConv2                 = hist(conv2DOutput2)
#cv2.imshow("Filtro 2D - Handmade convolution standarization norm", conv2DOutput2)

#------------------------------------------------------------------------------
#-----------------------------Error--------------------------------------------          
#------------------------------------------------------------------------------

origHeight, origWidth = opencvOutput.shape
Height2, Width2       = conv2DOutput.shape
Height3, Width3       = conv2DOutput2.shape
kHeight, kWidth       = kernel.shape

print('*'*70)
print('SIZES VERIFICATION:')
print('original: H:',origHeight,'W:', origWidth)
print('linear: H:', Height2,'W:', Width2)
print('standar: H:',Height3,'W:', Width3)
print('*'*70)



#------------------------------------------------------------------------------
#----------------------------Fixed Point-----------------------------------------          
#------------------------------------------------------------------------------
     
#----Number of bits selection----
n_bitsVar    = 5       #Se incrementan hasta 10 bits fraccionarios 

    #--Kernel--
kernelLArray = kernelLNorm.ravel()
kernelSArray = kernelSNorm.ravel()
# min1 = min(kernelLArray)
# max1 = max(kernelLArray)
# print(min1, max1)
# min2 = min(kernelSArray)
# max2 = max(kernelSArray)
# print(min2, max2)

SNRk1       = []
SNRk2       = []
SNRim1      = []
SNRim2      = []
SNRorigIm1  = []
SNRorigIm2  = []
xAxis       = []

print('*'*70)
print('ERROR CUADRATICO MEDIO KERNEL:')

for n in range(n_bitsVar):
    xAxis.append(n)
    kernelLFP = arrayFixedInt(2+n, n, kernelLArray, signedMode='S', roundMode='trunc', saturateMode='saturate')
    kernelSFP = arrayFixedInt(2+n, n, kernelSArray, signedMode='S', roundMode='trunc', saturateMode='saturate')
    
    kernelLF  = FPtoFloat(kernelLFP)
    kernelSF  = FPtoFloat(kernelSFP)
    
    kerror1   = errorArr(kernelLArray,kernelLF)
    kerror2   = errorArr(kernelSArray,kernelSF)
    
    SNR1      = SNRcalc(kerror1, kernelLArray)
    SNR2      = SNRcalc(kerror2, kernelSArray)
    
    SNRk1.append(SNR1)
    SNRk2.append(SNR2)
    
    acum2=errorPP(kernelLArray, kernelLF, 'a')
    acum3=errorPP(kernelSArray, kernelSF,'a')
    
    print('*'*70)
    print('Bits Fraccionarios: {}'.format(n))
    print('linear:', acum2)
    print('standar:', acum3)
print('*'*70)
       
    
#     #--Original Image--
           
origLinImArray      = imageNormLin.ravel()
origStdImArray      = imageStandarization.ravel()
# minimo1 = min(origLinImArray)
# maximo1 = max(origLinImArray)
# print(minimo1, maximo1)
# minimo2 = min(origStdImArray)
# maximo2 = max(origStdImArray)
# print(minimo2, maximo2)
print('*'*70)
print('ERROR CUADRATICO MEDIO IMAGEN ESCALADA:')

for n in range(n_bitsVar):
    origLinearNormFP  = arrayFixedInt(1+n, n, origLinImArray, signedMode='U', roundMode='trunc', saturateMode='saturate')
    origStandarNormFP = arrayFixedInt(2+n, n, origStdImArray, signedMode='S', roundMode='trunc', saturateMode='saturate')
   
    origLinearNormF  = FPtoFloat(origLinearNormFP)
    origStandarNormF = FPtoFloat(origStandarNormFP)
    
    origImError1   = errorArr(origLinImArray,origLinearNormF)
    origImError2   = errorArr(origStdImArray,origStandarNormF)
    
    SNR1      = SNRcalc(origImError1, origLinImArray)
    SNR2      = SNRcalc(origImError2, origStdImArray)
    
    SNRorigIm1.append(SNR1)
    SNRorigIm2.append(SNR2) 
    
    acum2=errorPP(origLinImArray,origLinearNormF, 'a')
    acum3=errorPP(origStdImArray,origStandarNormF,'a')
    
    print('*'*70)
    print('Bits Fraccionarios: {}'.format(n))
    print('linear:', acum2)
    print('standar:', acum3)
print('*'*70)
    
#------------------------------------------------------------------------------
#-----------------------------Graphics-----------------------------------------          
#------------------------------------------------------------------------------
plt.figure("Error segun cantidad de bits")
plt.subplot(2,1,1)
plt.plot(xAxis,SNRk1,'rx', label='Handmade convolution linear')
plt.plot(xAxis,SNRk2,'co', label='Handmade convolution standar')
plt.xlabel('Error')
plt.legend()
plt.grid()
plt.subplot(2,1,2)
plt.plot(xAxis,SNRorigIm1,'rx', label='Handmade convolution linear')
plt.plot(xAxis,SNRorigIm2,'co', label='Handmade convolution standar')
plt.xlabel('Error')
plt.legend()
plt.grid()
plt.show()




cv2.waitKey(0)
cv2.destroyAllWindows()


