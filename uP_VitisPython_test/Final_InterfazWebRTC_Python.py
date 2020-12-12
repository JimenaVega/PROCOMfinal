## Import Packages
from   skimage.exposure import rescale_intensity
import numpy as np
import matplotlib.pyplot as plt
import argparse
import cv2
from   tool._fixedInt import *
import time
import serial

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

def rebuildIm ():
	outInteger = []
	i = 0
	while (i<ROWIM):
		value=ord(ser.read(1))
		outInteger.append(fixedToFloat(7,6,'S',value))
		i=i+1
	
	return outInteger

#------------------ serial port configuration -------------------------------------------

ser = serial.Serial(
    port='/dev/ttyUSB7',		#Configurar con el puerto a usar 
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

ap = argparse.ArgumentParser( description="Convolution 2D")
ap.add_argument("-i", "--image", required=False, help="Path to the input image",default=path)
ap.add_argument("-k", "--kernel", help="Path to the kernel")
args = ap.parse_args()

#Load input image 
image   = cv2.imread(args.image,1)
endFlag = 0

#Convert image to gray scale
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

[ROWIM,COLIM] = gray.shape
#COLIM = 300
print("rows image= {0} \tcolumns image= {1}".format(ROWIM,COLIM))

#-----------------------Image normalization-----------------------------------
MaxIm     = 255.0
MinIm     = 0.0
newMaxIm  = 1.0
newMinIm  = 0.0
    #--Linear--
imageNormLin = linearNorm(gray, MaxIm, MinIm, newMaxIm, newMinIm)

#----------------------------Fixed Point-------------------------------------
quantImage  = quantize(imageNormLin,7,6)
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
n           	 = 0
m				 = 0

#envio de imagen escalada linealmente
while(1):
	if(ser.inWaiting()>0):
		a=ser.readline()
		print(a)
		if(a==(b"Send header\r\n")):
				ser.write(byteHeader)
				print("Sent header\r\n")
		elif(a==(b"Send Image\r\n")):
				for delta in range (COLIM):
					for i in range (ROWIM):
						byteImage.append(quantImage[(i+delta*ROWIM)]) 
					sendCol(byteImage)
					byteImage.clear() 
				print("Sent Image\r\n")

		elif(a==(b"Return data\r\n")):
			while(m<COLIM):
				imReconsMatrix.append(rebuildIm()) 
				m=m+1
			imReconsMatrix=(np.asarray(imReconsMatrix,'float64').T)
				
			#Check size
			print("Final size1:")
			print(imReconsMatrix.shape) 
			print(imReconsMatrix)
				
			#Rescalling
			maxVal, minVal                = searchXtremeValues (imReconsMatrix, ROWIM, COLIM) 
			imAfterUART                   = linearScalling (imReconsMatrix,maxVal, minVal).astype('uint8')

			print("COMPARACION DE MATRICES")
			print("Returned image:")
			print(imAfterUART)
			print("Original image:")
			print(gray)

			#Guardar las imagenes resultantes
			filename1 = 'sentImage.jpg'
			filename2 = 'receivedImage.jpg'

			cv2.imwrite(filename1,gray)
			cv2.imwrite(filename2,imAfterUART)

			print("Finished processing/r/n")
