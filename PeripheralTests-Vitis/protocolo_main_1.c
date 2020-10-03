
#include <stdio.h>
#include <string.h>
#include "xparameters.h"
#include "xil_cache.h"
#include "xgpio.h"
#include "platform.h"
#include "xuartlite.h"

#define PORT_IN	 		XPAR_UP_I_AXI_GPIO_0_DEVICE_ID //XPAR_GPIO_0_DEVICE_ID
#define PORT_OUT 		XPAR_UP_I_AXI_GPIO_0_DEVICE_ID //XPAR_GPIO_0_DEVICE_ID

#define testPosition    (*((volatile unsigned long *) 0x8FFFFFFE))

XGpio GpioOutput;
XGpio GpioParameter;
XGpio GpioInput;
u32 GPO_Value;
u32 GPO_Param;
XUartLite uart_module;

//Funcion para recibir 1 byte bloqueante
//XUartLite_RecvByte((&uart_module)->RegBaseAddress)

int main()
{
	init_platform();

	print("---Entering main---\n\r");

	int Status;

	XUartLite_Initialize(&uart_module, 0);

	GPO_Value=0x00000000;
	GPO_Param=0x00000000;

	Status=XGpio_Initialize(&GpioInput, PORT_IN);
	if(Status!=XST_SUCCESS){
        return XST_FAILURE;
    }
	Status=XGpio_Initialize(&GpioOutput, PORT_OUT);
	if(Status!=XST_SUCCESS){
		return XST_FAILURE;
	}
	XGpio_SetDataDirection(&GpioOutput, 1, 0x00000000);
	XGpio_SetDataDirection(&GpioInput, 1, 0xFFFFFFFF);

	print("GPIO successfull init\n\r");

	testPosition = 2;

	if (testPosition==2){
		XGpio_DiscreteWrite(&GpioOutput,1, (u32) 0x00000249);
		print("passed 1 \n\r");
	   }

	else if (testPosition==1){
		XGpio_DiscreteWrite(&GpioOutput,1, (u32) 0x00000492);
		print("passed 2 \n\r");
	}
	else{
        XGpio_DiscreteWrite(&GpioOutput,1, (u32) 0x00000000);
        print("failed \n\r");
	   }

	while(1){
  		   }

	cleanup_platform();
	return 0;
}
