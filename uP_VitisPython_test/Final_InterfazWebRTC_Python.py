##Merge código python 
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

def sendCol(imageCol):
   
    ser.write(imageCol)
    time.sleep(0.001)

    return 
  
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

def rebuildIm ():
	outInteger = []
	i = 0
	while (i<ROWIM):
		value=ord(ser.read(1))
		outInteger.append(fixedToFloat(7,6,'S',value))
		i=i+1
	
	return outInteger


# In[0]: serial port configuration


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


# In[1]: Main

#---------------------- imagen reading-------------------------------------------
path = "foto1.jpg"

ap = argparse.ArgumentParser( description="Convolution 2D")
ap.add_argument("-i", "--image", required=False, help="Path to the input image",default=path)
ap.add_argument("-k", "--kernel", help="Path to the kernel")
args = ap.parse_args()

#Load input image 
image   = cv2.imread(args.image,1)
endFlag = 0                                        

#Kernel to use whithout conv IP
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
byteHeader  = bytearray()

#envio y recepcion de header
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

PCKTS_TO_SEND	 = 0
COLS_TO_SEND     = 30

#envio de imagen escalada linealmente

while(1):
	if(ser.inWaiting()>0):
		a=ser.readline()
		print(a)
		if(a==(b"Send header\r\n")):
				ser.write(byteHeader)
				print("Sent header\r\n")
		elif(a==(b"Send Image\r\n") and (PCKTS_TO_SEND<15)):
				print(PCKTS_TO_SEND)
				for delta in range (COLS_TO_SEND):
					for i in range (ROWIM):
						byteImage.append(quantImage[(PCKTS_TO_SEND*(COLS_TO_SEND*ROWIM))+(i+delta*ROWIM)]) 
					sendCol(byteImage)
					byteImage.clear() 
				#fin de la trama 
				#ser.write(0x50)
				print("Sent Image\r\n")

		elif(a==(b"Return data\r\n") and (PCKTS_TO_SEND<15)):
			print(PCKTS_TO_SEND)
			while(m<COLS_TO_SEND):
				imReconsMatrix.append(rebuildIm()) 
				m=m+1
			PCKTS_TO_SEND=PCKTS_TO_SEND+1
			m=0
	
	if(PCKTS_TO_SEND==15):
		PCKTS_TO_SEND=0
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

imMatrix, imHeight, imWidth   = conv2D (imAfterUART , kernelLNorm)
#xConv,yConv                   = hist (imAfterUART)
plotHist(imAfterUART,'lineal reconstructed',2)
cv2.imshow("2- image after UART ", imAfterUART)

