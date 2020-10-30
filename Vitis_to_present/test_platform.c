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

#if (!defined(DEBUG))
extern void xil_printf(const char *format, ...);
#endif

/******************** Constant Definitions **********************************/

#define DMA_DEV_ID			XPAR_AXIDMA_0_DEVICE_ID

#define DDR_BASE_ADDR		XPAR_MIG7SERIES_0_BASEADDR
#define MEM_BASE_ADDR		(DDR_BASE_ADDR + 0x1000000)

#define TX_BD_SPACE_BASE	(MEM_BASE_ADDR)
#define TX_BD_SPACE_HIGH	(MEM_BASE_ADDR + 0x00000FFF)
#define RX_BD_SPACE_BASE	(MEM_BASE_ADDR + 0x00001000)
#define RX_BD_SPACE_HIGH	(MEM_BASE_ADDR + 0x00001FFF)
#define TX_BUFFER_BASE		(MEM_BASE_ADDR + 0x00100000)
#define RX_BUFFER_BASE		(MEM_BASE_ADDR + 0x00300000)
#define RX_BUFFER_HIGH		(MEM_BASE_ADDR + 0x004FFFFF)


#define MAX_PKT_LEN			0x20
#define MARK_UNCACHEABLE    0x701

#define TEST_START_VALUE	0xC

#define CABECERA 			0x11
#define VALID_DATA 			0x22

/************************** Variable Definitions *****************************/
/*
 * Device instance definitions
 */
XAxiDma     AxiDma		;
XUartLite	uart_module	;

/*****************************************************************************/

/*************************** Prototypes **************************************/
void setUART (void);
void transmit(void);

/*****************************************************************************/
int main(void){

	init_platform();
	setUART();

	unsigned char recv_data[6];
	unsigned char send_data;

	while(1){

		short int i;
		for(i=0;i<6;i++){
			recv_data[i]=XUartLite_RecvByte((&uart_module)->RegBaseAddress);
		}
	}

	if(recv_data[0]==CABECERA && recv_data[5]==VALID_DATA){
		for (i=1; i<6; i++){
			switch (recv_data[i]){
			case 'i':
				send_data='o';
				break;
			default:
				send_data=recv_data[i];
				break;
			}
			while(XUartLite_IsSending(&uart_module)){}
			XUartLite_Send(&uart_module, &(send_data),1);
		}
	}

	return 0;
}

void setUART(void){
	XUartLite_Initialize(&uart_module, 0);
	return;
}




