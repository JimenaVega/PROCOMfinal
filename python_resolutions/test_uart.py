# -*- coding: utf-8 -*-
"""
Created on Fri Jul 24 17:14:51 2020

@author: Jimena

NOTA: el kernel no es necesario en el programa final. Solo se encuentra en el codigo a modo
de facil debuggeo.
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



def linearScalling (imMatrix,maxVal, minVal):  
    
    imMatrix = (imMatrix-minVal)
    imMatrix = rescale_intensity(imMatrix,in_range=(-minVal,maxVal), out_range=(0.0,255.0))

    return imMatrix


def linearNorm (matrix, Max, Min, newMax, newMin):
    
    matrix=(matrix-Min)*((newMax-newMin)/(Max-Min))+newMin
    return matrix


def quantize (matrix,NB,NBF):
    
    flattenMatrix = np.ravel(matrix.T) #se aplasta por columnas
    quantMatrix   = arrayFixedInt(NB,NBF,flattenMatrix, signedMode='S', roundMode='trunc', saturateMode='saturate')
    packedMatrix  = np.zeros(len(quantMatrix), dtype='int')
    
    for i in range(len(quantMatrix)):
        packedMatrix[i] = quantMatrix[i].intvalue
    
    return packedMatrix


def fixedToFloat(NB,NBF,signedMode,num):
    
	if  (signedMode=='S'):
		return (((num+2**(NB-1))&((2**NB)-1))-2**(NB-1))/(2**NBF)
	elif(signedMode=='U'):
		return num/(2**NBF)
    
     
def sendCol(imageCol,i):
   
    ser.write(imageCol)
    time.sleep(0.001)
    out = []
    while (ser.inWaiting() > 0):
        out.append(ser.read(1))
        #print("aca ta el out {}".format(out))
        
    outInteger = []
  
    for i in range(len(out)):
      
        outInteger.append(int.from_bytes( out[i], "big"))
    
    ser.flushInput()
    ser.flushOutput()
    
    return outInteger
  
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


    
# In[0]: serial port configuration

ser = serial.serial_for_url('loop://', timeout=1)

##Descomentar en caso de enviar a FPGA
# ser = serial.Serial(
#     port     = '/dev/ttyUSB1',
#     baudrate = 115200,
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

#---------------------- imagen reading-------------------------------------------

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

[ROWIM,COLIM] = gray.shape
print("rows image= {0} \tcolumns image= {1}".format(ROWIM,COLIM))

#-----------------------Image normalization-----------------------------------
MaxIm     = 255.0
MinIm     = 0.0
newMaxIm  = 1.0
newMinIm  = 0.0
    #--Linear--
imageNormLin = linearNorm(gray, MaxIm, MinIm, newMaxIm, newMinIm)

#----Kernel normalization----
maxKernel  = 8.0

kernelL    = kernelNorm(kernel, maxKernel, 'linear')
kernelS    = kernelNorm(kernel, maxKernel, 'standar')
#----Kernel flip----
kernelLNorm  = flipKernel (kernelL)
kernelSNorm  = flipKernel (kernelS)


#------------------------------------------------------------------------------
#----------------------------Fixed Point---------------------------------------          
#------------------------------------------------------------------------------


#kernel cuantizado con S(8,6)
#imagen cuantizada con S(7,6)

quantImage  = quantize(imageNormLin,7,6)
quantKernel = quantize(kernelLNorm,8,6)


#------------------------------------------------------------------------------
#----------------------------------UART---------------------------------------          
#------------------------------------------------------------------------------
ser.flushInput()
ser.flushOutput()

byteImage   = bytearray()
byteHeader = bytearray()

#envio y recepcion de header
sizeOfImage = ROWIM*COLIM
lsb = (sizeOfImage & 0xff)
msb = ((sizeOfImage & 0xff00) >> 8)

byteHeader.append(0xb0) #10110000
byteHeader.append(lsb)
byteHeader.append(msb)
  
ser.write(byteHeader)  

while (ser.inWaiting() > 0):
    print(ser.read(1))

ser.flushInput()
ser.flushOutput()


#envio de imagen escalada linealmente
imRecons    = []

for delta in range (COLIM):
    for i in range(ROWIM):
        byteImage.append(quantImage[i+(delta*ROWIM)]) 
    imRecons.append(sendCol(byteImage,delta))
    byteImage.clear() 
   

ser.close()

for i in range(COLIM):
    for j in range(ROWIM):
       imRecons[i][j]    = fixedToFloat(7,6,'S',imRecons[i][j])
    

imageLinRec = (np.asarray(imRecons,'float64').T) #imagen reconstruida
endFlag = 1

#------------------------------------------------------------------------------
#---------------------------------output image--------------------------------         
#------------------------------------------------------------------------------

#imagen original escalada linealmente

plt.figure(1)

imMatrix, imHeight, imWidth   = conv2D(imageNormLin, kernelLNorm)
maxVal, minVal                = searchXtremeValues (imMatrix, imHeight, imWidth) 
imBeforeUART                  = linearScalling (imMatrix,maxVal, minVal).astype('uint8')
#xConv,yConv                   = hist(imBeforeUART)
plotHist(imBeforeUART,'original image with lineal scalling',1)
cv2.imshow("1- image before UART ", imBeforeUART)

imMatrix, imHeight, imWidth   = conv2D (imageLinRec, kernelLNorm)
maxVal, minVal                = searchXtremeValues (imMatrix, imHeight, imWidth) 
imAfterUART                   = linearScalling (imMatrix,maxVal, minVal).astype('uint8')
#xConv,yConv                   = hist (imAfterUART)
plotHist(imAfterUART,'lineal reconstructed',2)
cv2.imshow("2- image after UART ", imAfterUART)

