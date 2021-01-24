## Import Packages
from   skimage.exposure import rescale_intensity
import numpy as np
import matplotlib.pyplot as plt
import argparse
import cv2

import time
import serial


def linearScalling (imMatrix,maxVal, minVal):  
    
    imMatrix = (imMatrix-minVal) 
    imMatrix = rescale_intensity(imMatrix,in_range=(-minVal,maxVal), out_range=(0.0,255.0))

    return imMatrix

def linearNorm (matrix, Max, Min, newMax, newMin):
    
    matrix=(matrix-Min)*((newMax-newMin)/(Max-Min))+newMin
    return matrix

def sendCol(imageCol):
   
    ser.write(imageCol)
    time.sleep(0.001)

    return 

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

def plotHist(conv_image,name,pos):
    [x  ,y]   = np.unique(conv_image,return_counts=True)
    plt.subplot(2,1,pos)
    plt.stem(x,y,'ko',label=name,use_line_collection=True)
    plt.legend()
    plt.grid()
    
    plt.show()

def rebuildIm ():
    outInteger = []
    i = 0
    while (i < 5):
        value=ord(ser.read(1))
        outInteger.append(value)
        i=i+1

    return outInteger

#------------------ serial port configuration -------------------------------------------

#ser = serial.serial_for_url('loop://', timeout=1) 
ser = serial.Serial(
	port='/dev/ttyUSB1',		#Configurar con el puerto a usar 
	baudrate=115200,
	parity=serial.PARITY_NONE,
	stopbits=serial.STOPBITS_ONE,
	bytesize=serial.EIGHTBITS
)
 
ser.isOpen()
ser.timeout=None
print(ser.timeout)

#---------------------- image reading-------------------------------------------

path = "foto1.jpg"

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
gray = np.pad(gray, ((1,1),(1,1)), 'constant')

[ROWIM,COLIM] = gray.shape
print("rows image= {0} \tcolumns image= {1}".format(ROWIM,COLIM))


#----------------------------------UART---------------------------------------

ser.flushInput()
ser.flushOutput()

byteHeader  = bytearray()
byteImage   = bytearray()

sizeOfImage = ROWIM*COLIM
#rowImLSB = (ROWIM  & 0xff)
#rowImMSB = ((ROWIM & 0xff00) >> 8)
#colImLSB = (COLIM  & 0xff)
#colImMSB = ((COLIM & 0xff00) >> 8)

byteHeader.append(0xb0)     
byteHeader.append(0x7b)
byteHeader.append(0x7c)
byteHeader.append(0x4f)
#byteHeader.append(rowImLSB)
#byteHeader.append(rowImMSB)
#byteHeader.append(colImLSB)
#byteHeader.append(colImMSB)

imReconsArray  = []
imReconsMatrix = []
imSendArray    = []
imSendMatrix   = []
n = 0
m = 0

#envio de imagen escalada linealmente
while(1):
	
	if(ser.inWaiting() > 0):
		
		a = ser.readline()
		print(a)
		
		if (a == (b"Send header\r\n")):
			ser.write(byteHeader)
			print("Sent header\r\n")
			
		elif (a == (b"Send Image\r\n")):
			for j in range (COLIM):
				for i in range (ROWIM):
					byteImage.append(gray[i][j]) 
				sendCol(byteImage)
				byteImage.clear() 
			print("Sent Image\r\n")

		elif (a == (b"Return data\r\n")):
			imReconsMatrix.append(rebuildIm()) 
			imReconsMatrix = (np.asarray(imReconsMatrix, 'uint8').T)
				
			#Check size
			print("Final size1:")
			print(imReconsMatrix.shape) 
			print(imReconsMatrix)
			
			print("Finished processing/r/n")
