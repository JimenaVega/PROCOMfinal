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

import multiprocessing
import pyimgur
import asyncio
import os


class _QueueProxy(object):
    def __init__(self):
        self._queueimp = None

    @property
    def _queue(self):
        if self._queueimp is None:
            isMonoCPU = multiprocessing.cpu_count() == 1
            self._queueimp = queue.Queue() if isMonoCPU else multiprocessing.Queue() 

        return self._queueimp

    def get(self, *args, **kw):
        return self._queue.get(*args, **kw)

    def put(self, *args, **kw):
        return self._queue.put(*args, **kw)

   # etc... only expose public methods and attributes of course


# and now our `shared_queue` instance    


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


#Image processing

def linearScalling (imMatrix,maxVal, minVal):   
    imMatrix = (imMatrix-minVal)
    imMatrix = rescale_intensity(imMatrix,in_range=(-minVal,maxVal), out_range=(0.0,255.0))

    return imMatrix

def linearNorm (matrix, Max, Min, newMax, newMin):
    matrix=(matrix-Min)*((newMax-newMin)/(Max-Min))+newMin
    return matrix

def quantize (matrix,NB,NBF,signedMode_):
    
    flattenMatrix = np.ravel(matrix.T) #se aplasta por columnas
    quantMatrix   = arrayFixedInt(NB,NBF,flattenMatrix, signedMode=signedMode_ , roundMode='trunc', saturateMode='saturate')
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

def upload_image(image,path,photo_name):

    #Datos de acceso IMGUR:
    #Usuario:  AJEMProcom
    #Password: quesadilla123
    
   
    PATH = path +  photo_name
    
    CLIENT_ID = "fdecbab9c6d3bc0" #proporcionado por la pagina IMGUR
    CLIENT_SECRET= "9c7ebc0e24263b9a1f1a7cd6c11815ef734aec8a" #por ahora no se usa , la dejo guardada

    im = pyimgur.Imgur(CLIENT_ID)
    uploaded_image = im.upload_image(PATH, title="foto_post_process")

   
    return uploaded_image.link

    


# In[0]: serial port configuration
if __name__ == "__main__":

        

        
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
    # print(ser.timeout)









    # def run(gray):
        


    # In[1]: Main

    #---------------------- imagen reading-------------------------------------------

    # path = "descarga.jpg"
    # #path = "foto1.jpg"

    ap = argparse.ArgumentParser( description="Convolution 2D")
    ap.add_argument("-c", "--condicion", required=False, default="0")
    # ap.add_argument("-i", "--image", required=False, help="Path to the input image",default="path")
    # ap.add_argument("-k", "--kernel", help="Path to the kernel")
    args = ap.parse_args()



    ##Lo que quiero hacer es que no cargue dos veces la imagen osea si el argumento del parser se da como true entonces 
    ##lo carga pero esto es para que no cargue cualquier cosa por defecto al hacer el import
    # # Load input image 

        
    #ejecucion normal

    gray   = cv2.imread("photo.jpg",0)


    #Kernel to use momentaneamente 
    kernel = np.array((
            [-1, -1, -1],
            [-1,  8, -1],
            [-1, -1, -1]), dtype="float")

    #Convert image to gray scale
    # gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    [ROWIM,COLIM] = gray.shape
    # print("rows image= {0} \tcolumns image= {1}".format(ROWIM,COLIM))

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

    quantImage  = quantize(imageNormLin,7,6,'S')
    quantKernel = quantize(kernelLNorm,8,6,'S')


    #------------------------------------------------------------------------------
    #----------------------------------UART---------------------------------------          
    #------------------------------------------------------------------------------
    ser.flushInput()
    ser.flushOutput()

    byteImage   = bytearray()
    byteImageStr = bytearray()

    imRecons    = []


    #envio de imagen escalada linealmente
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
    # plotHist(imBeforeUART,'original image with lineal scalling',1)
    # cv2.imshow("1- image before UART ", imBeforeUART)

    imMatrix, imHeight, imWidth   = conv2D (imageLinRec, kernelLNorm)
    maxVal, minVal                = searchXtremeValues (imMatrix, imHeight, imWidth) 
    imAfterUART                   = linearScalling (imMatrix,maxVal, minVal).astype('uint8')
    #xConv,yConv                   = hist (imAfterUART)
    # plotHist(imAfterUART,'lineal reconstructed',2)
    # cv2.imshow("2- image after UART ", imAfterUART)


    PATH="C:\\Educacion\\Procom2020\\PROCOMeste\\PROCOMfinal\\WebRTC\\"

    cv2.imwrite("photoAFTERUART.jpg",imAfterUART)
    photo_name = 'photoAFTERUART.jpg'



    link=upload_image(imAfterUART,PATH,photo_name)
  
    
    f = open("url.txt",'r+')
    f.write(link)
    f.close()

    print("Fin INTERFAZWEBUART")

        # return imAfterUART,link

            