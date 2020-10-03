/*
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A 
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR 
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION 
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE 
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO 
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO 
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE 
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY 
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 */

/*
 * 
 *
 * This file is a generated sample test application.
 *
 * This application is intended to test and/or illustrate some 
 * functionality of your system.  The contents of this file may
 * vary depending on the IP in your system and may use existing
 * IP driver functions.  These drivers will be generated in your
 * SDK application project when you run the "Generate Libraries" menu item.
 *
 */

#include <stdio.h>
#include "xparameters.h"
#include "xil_cache.h"
#include "xintc.h"
#include "intc_header.h"
#include "xgpio.h"
#include "gpio_header.h"
#include "axidma_header.h"
int main () 
{
   static XIntc intc;
   //Xil_ICacheEnable();
   //Xil_DCacheEnable();
   print("---Entering main---\n\r");


   {
      int status;

      print("\r\n Running IntcSelfTestExample() for uP_i_microblaze_0_axi_intc...\r\n");

      status = IntcSelfTestExample(XPAR_UP_I_MICROBLAZE_0_AXI_INTC_DEVICE_ID);

      if (status == 0) {
         print("IntcSelfTestExample PASSED\r\n");
      }
      else {
         print("IntcSelfTestExample FAILED\r\n");
      }
   }

   {
       int Status;

       Status = IntcInterruptSetup(&intc, XPAR_UP_I_MICROBLAZE_0_AXI_INTC_DEVICE_ID);
       if (Status == 0) {
          print("Intc Interrupt Setup PASSED\r\n");
       }
       else {
         print("Intc Interrupt Setup FAILED\r\n");
      }
   }


   /*
    * Peripheral SelfTest will not be run for uP_i_axi_uartlite_0
    * because it has been selected as the STDOUT device
    */




   {
      int status;


      print("\r\n Running AxiDMASelfTestExample() for uP_i_axi_dma_0...\r\n");

      status = AxiDMASelfTestExample(XPAR_UP_I_AXI_DMA_0_DEVICE_ID);

      if (status == 0) {
         print("AxiDMASelfTestExample PASSED\r\n");
      }
      else {
         print("AxiDMASelfTestExample FAILED\r\n");
      }
   }


   print("---Exiting main---\n\r");
   //Xil_DCacheDisable();
   //Xil_ICacheDisable();
   return 0;
}
