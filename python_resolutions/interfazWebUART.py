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
import multiprocessing
import sys
import time



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

def flipKernel (kernel):               
    kernel = np.flipud(kernel)
    kernel = np.fliplr(kernel)
    return kernel

def quantize(matrix,NB,NBF):
    print("Columnas imagen= {0} Filas Imagen = {1} ".format(matrix.shape[0],matrix.shape[1]))
    flattenMatrix = np.ravel(matrix.T) #se aplasta por columnas
    quantMatrix   = arrayFixedInt(NB,NBF,flattenMatrix, signedMode='S', roundMode='trunc', saturateMode='saturate')
    
    packedMatrix = np.zeros(len(quantMatrix), dtype='int')
    for i in range(len(quantMatrix)):
        packedMatrix[i] = quantMatrix[i].intvalue
    
    return packedMatrix
"""    packedMatrix = np.zeros(len(quantMatrix), dtype='str')
    for i in range(len(quantMatrix)):
        packedMatrix[i] = chr(quantMatrix[i].intvalue)"""

def sendData(image,command,rowImage,colst):
    
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



#Kernel to use
kernel = np.array((
    	[-1, -1, -1],
    	[-1,  8, -1],
    	[-1, -1, -1]), dtype="float")

#Convert image to gray scale
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
#cv2.imshow("Gray scale image", gray)
[rowImage,colImage] = gray.shape
print("filas gray = {0} \tcolumnas en gray = {1}".format(rowImage,colImage))
#----Image normalization----
MaxIm     = 255.0
MinIm     = 0.0
newMaxIm  = 1.0
newMinIm  = 0.0
    #--Linear--
imageNormLin = linearNorm(gray, MaxIm, MinIm, newMaxIm, newMinIm)

#----Kernel normalization----
maxKernel    = 8.0
kernelL      = kernelNorm(kernel, maxKernel, 'linear')

#----Kernel flip----
kernelLNorm  = flipKernel (kernelL)



#------------------------------------------------------------------------------
#----------------------------Fixed Point---------------------------------------          
#------------------------------------------------------------------------------


# #kernel cuantizado con S(8,6)
#imagen cuantizada con S(7,6)
#test (3er elem) usado solo para poder ver los char unicode de espaciado
quantImage  = quantize(imageNormLin,7,6)
quantKernel = quantize(kernelLNorm,8,6)


#------------------------------------------------------------------------------
#----------------------------------UART---------------------------------------          
#------------------------------------------------------------------------------
ser.flushInput()
ser.flushOutput()

#test = (ord(quantImage[0]))
row  = 0

print(quantImage[0])
idk = bytearray()
#for i in range(len(quantImage)):
idk.append(quantImage[0])
idk.append(quantImage[256])
idk.append(quantImage[10680])



print("valor num ascii = {0} \t tamaño en byte = {1}".format(idk[0],sys.getsizeof(idk[0])))
print("valor num ascii = {0} \t tamaño en byte = {1}".format(idk[1],sys.getsizeof(idk[1])))
print("valor num ascii = {0} \t tamaño en byte = {1}".format(idk[2],sys.getsizeof(idk[2])))
ser.write(idk)
time.sleep(0.001)

out1 = []
count = 0
while (ser.inWaiting() > 0):
    print(count)
    out1.append(ser.read(1))
    count+=1

print('-'*7+"UART reading o1"+'-'*7)
print(sys.getsizeof(out1[0]))
print(int.from_bytes( out1[0], "big"))
print(int.from_bytes( out1[1], "big"))
print(int.from_bytes( out1[2], "big"))
ser.flushInput()
ser.flushOutput()
#-------------op2----------------------------------

# print('-'*7+"UART writing"+'-'*7)
# toSend = chr(quantImage[10680]).encode()
# print(sys.getsizeof(toSend))
# print(toSend)

# ser.write(toSend)
# time.sleep(0.05)

# while (ser.inWaiting() > 0):
#     out = (ser.read(1))
#     print(out)
# print('-'*7+"UART reading"+'-'*7)
# print(sys.getsizeof(out))
# print(int.from_bytes( out, "big"))



# for j in range(colImage):
#         trama = bytearray(colImage)
#         for c in range(colImage):
#             aaa = quantImage[c+row]
#             trama.insert(c,aaa)
#         row += rowImage    
#         for i in range(colImage):
#             print()
            
                
                #time.sleep(1)
       # ser.write(trama)
        # out = ''

        # while ser.inWaiting() > 0:
        #     out += ser.read(1)

        # if out != '':
        #     print (">> " + out)



#if close project / receive data
# inp = input("Close Port?\t[y/n]:\n>>")
# if (inp == 'y'):
ser.close()
    #exit()



#////////////////////////BORRAR//////////////////////////////

#----Handmade convolution output LINEAR NORM----

imMatrix, imHeight, imWidth   = conv2D(imageNormLin, kernelLNorm)
maxVal, minVal                = search(imMatrix, imHeight, imWidth) 
conv2DOutput                  = scale(imMatrix,maxVal, minVal, 'linear').astype('uint8')

#cv2.imshow("2- escalada ", conv2DOutput)


#////////////////////////BORRAR////////////////////////////"""
