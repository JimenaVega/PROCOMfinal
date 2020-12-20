# -*- coding: utf-8 -*-
"""
Created on Sat Dec 19 09:19:06 2020

@author: miner
"""

## Import Packages
from   skimage.exposure import rescale_intensity
import numpy as np
import matplotlib.pyplot as plt
import argparse
import cv2

import time
import serial


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


def flipKernel (kernel):               
    kernel = np.flipud(kernel)
    kernel = np.fliplr(kernel)
    return kernel


def sendCol(imageCol):
   
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

def plotHist(conv_image,name,pos):
    [x  ,y]   = np.unique(conv_image,return_counts=True)
    plt.subplot(2,1,pos)
    plt.stem(x,y,'ko',label=name,use_line_collection=True)
    plt.legend()
    plt.grid()
    
    plt.show()

def rebuildIm ():
    #clipeado
    clippedCol = []
    i = 0
    while (i < ROWIM):
        
        value = ord(ser.read(1))
        if (value > 255):
            clippedCol[i] = 255
        elif (value < 0):
            clippedCol[i] = 0 
        else:
            clippedCol[i] = value
        i=i+1

    return clippedCol.astype('uint8')

#------------------ serial port configuration -------------------------------------------

ser = serial.serial_for_url('loop://', timeout=1) 
# ser = serial.Serial(
#     port='/dev/ttyUSB7',		#Configurar con el puerto a usar 
#     baudrate=115200,
#     parity=serial.PARITY_NONE,
#     stopbits=serial.STOPBITS_ONE,
#     bytesize=serial.EIGHTBITS
# )
 
ser.isOpen()
ser.timeout=None
print(ser.timeout)


#---------------------- image reading-------------------------------------------

path = "foto2.jpg"

ap = argparse.ArgumentParser( description = "Convolution 2D")
ap.add_argument("-i", "--image", required = False, help="Path to the input image",default=path)
ap.add_argument("-k", "--kernel", help = "Path to the kernel")
args = ap.parse_args()

#Load input image 
image   = cv2.imread(args.image,1)
endFlag = 0

#Convert image to gray scale
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

#zero-padding
np.pad(gray, ((1,1),(1,1)), 'constant')

[ROWIM,COLIM] = gray.shape
#COLIM = 300
print("rows image= {0} \tcolumns image= {1}".format(ROWIM,COLIM))


#----------------------------------UART---------------------------------------

ser.flushInput()
ser.flushOutput()

byteHeader  = bytearray()
byteImage   = bytearray()

sizeOfImage = ROWIM*COLIM
rowImLSB = (ROWIM  & 0xff)
rowImMSB = ((ROWIM & 0xff00) >> 8)
colImLSB = (COLIM  & 0xff)
colImMSB = ((COLIM & 0xff00) >> 8)

byteHeader.append(0xb0)     #10110000
byteHeader.append(rowImLSB)
byteHeader.append(rowImMSB)
byteHeader.append(colImLSB)
byteHeader.append(colImMSB)

imReconsArray    = []
imReconsMatrix   = []
imSendArray    	 = []
imSendMatrix	 = []
n = 0
m = 0

while(1):
	a = input("Accion:")
	print(a)
	if (a == ("Send header")):
		ser.write(byteHeader)
		print("Sent header\r\n")
		
	elif (a == ("Send Image")):
		imReconsList = []
		for j in range (COLIM):
			for i in range (ROWIM):
				byteImage.append(gray[i][j]) 
			imReconsList.append(sendCol(byteImage))
			byteImage.clear()  
		imReconsMatrix = (np.asarray(imReconsList, 'uint8').T)
		print("Sent Image\r\n")
	else:
		break
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
[conv2Dout, imHeight, imWidth] = conv2D(imReconsMatrix, kernelFlipped)

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
plotHist(convFinal, 'lconvolution',2)
cv2.imshow("2- convolution ", convFinal)


