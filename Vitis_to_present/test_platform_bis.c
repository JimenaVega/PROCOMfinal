/***************************** Include Files *********************************/
#include "xaxidma.h"
#include "xdebug.h"
#include <stdio.h>
#include <string.h>
#include "xparameters.h"
#include "xil_cache.h"
#include "platform.h"
#include "xuartlite.h"
#include "microblaze_sleep.h"
#include "xuartlite_l.h"


/******************** Constant Definitions **********************************/
#define IMAGEN_CABECERA 	0x11
#define VALID_DATA 			0x22
#define TOTAL_BYTES 		50325

/************************** Variable Definitions *****************************/
/*
 * Device instance definitions
 */
XUartLite	uart_module	;

/*****************************************************************************/

/*************************** Prototypes **************************************/

/*****************************************************************************/
int main(void){

	init_platform();
	XUartLite_Initialize(&uart_module, 0);

	unsigned char recv_data;
	unsigned char send_data;

	while(1){
		int i;

		recv_data=XUartLite_RecvByte((&uart_module)->RegBaseAddress);

		if (recv_data==IMAGEN_CABECERA){
				for(i=1; i<TOTAL_BYTES ;i++){
					recv_data=XUartLite_RecvByte((&uart_module)->RegBaseAddress);
					send_data=(char)(recv_data&(0x0000000F));
					while(XUartLite_IsSending(&uart_module)){}
					XUartLite_Send(&uart_module, &(send_data),1);
				}
		}

		recv_data=XUartLite_RecvByte((&uart_module)->RegBaseAddress);

		if (recv_data==VALID_DATA){
			cleanup_platform();
		}
		return 0;
	}
}





