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
	n = 0
	while (n<ROWIM):
		value=ord(ser.read(1))
		outInteger.append(fixedToFloat(7,6,'S',value))
		n=n+1
	
	return outInteger

"""
				while(n<COLIM):
					while(m<ROWIM):

					imReconsArray.append(ord(ser.read(1)))
					n=n+1
				n=0	
"""

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

[ROWIM,ORIG_COLIM] = gray.shape
print("rows image= {0} \tcolumns image= {1}".format(ROWIM,ORIG_COLIM))

#Resize image to have a minor flow of data 
COLIM = 30
dsize         = (COLIM,ROWIM)
resizedIm     = cv2.resize(gray, dsize, interpolation=cv2.INTER_AREA)

#-----------------------Image normalization-----------------------------------
MaxIm     = 255.0
MinIm     = 0.0
newMaxIm  = 1.0
newMinIm  = 0.0
    #--Linear--
imageNormLin = linearNorm(resizedIm, MaxIm, MinIm, newMaxIm, newMinIm)

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
Result			 = []
imSendArray    	 = []
imSendMatrix	 = []
n           	 = 0
m				 = 0

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
						byteImage.append(quantImage[i+(delta*ROWIM)]) 
						#imSendArray.append(quantImage[i+(delta*ROWIM)])
					sendCol(byteImage)
					byteImage.clear() 
				#fin de la trama 
				#ser.write(0x50)
				print("Sent Image\r\n")

		elif(a==(b"Return data\r\n")):
			while(m<COLIM):
				imReconsMatrix.append(rebuildIm()) 
				m=m+1
			m=0
			imReconsMatrix=(np.asarray(imReconsMatrix,'float64').T)
			
			#Resize the resize
			rsize         = (ORIG_COLIM,ROWIM)     
			backIm        = cv2.resize(imReconsMatrix, rsize, interpolation=cv2.INTER_AREA)
			print("Final size1:")
			print(backIm.shape) 
			print(backIm)
			
			#Rescalling
			maxVal, minVal                = searchXtremeValues (backIm, ROWIM, ORIG_COLIM) 
			imAfterUART                   = linearScalling (backIm,maxVal, minVal).astype('uint8')
			
			#Print images to compare 
			print("Returned image:")
			print(imAfterUART)
			print("Original image:")
			print(gray)

			print("Finished processing/r/n")

"""				#Verificacion de el arreglo recibido y el enviado 
				Result        = (np.asarray(imSendArray))-(np.asarray(imReconsArray))
				SumElements   = sum(Result)
				print("Sum element (si es 0, los bytes enviados son los mismos que los recibidos):")
				print(SumElements)

				#Reconstruccion de la matriz de la imagen enviada
				imSendMatrix=((np.reshape(imSendArray,(COLIM,ROWIM))).T)
				print("Rearranged send matrix size:")
				print(imSendMatrix.shape)

				#Reconstruccion de la matriz de la imagen recibida
				imReconsMatrix=((np.reshape(imReconsArray,(COLIM,ROWIM))).T)
				print("Rearranged received matrix size:")
				print(imReconsMatrix.shape)

				#Comparacion de matrices
				print("Matriz enviada:")
				print(imSendMatrix)

				print("Matriz recibida:")
				print(imReconsMatrix)
"""
					
