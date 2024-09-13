//       An example for demonstrating basic principles of FITkit3 usage.
//
// It includes GPIO - inputs from button press/release, outputs for LED control,
// timer in output compare mode for generating periodic events (via interrupt 
// service routine) and speaker handling (via alternating log. 0/1 through
// GPIO output on a reasonable frequency). Using this as a basis for IMP projects
// as well as for testing basic FITkit3 operation is strongly recommended.
//
//            (c) 2019 Michal Bidlo, BUT FIT, bidlom@fit.vutbr.cz
////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////
//                                                                           
// IMP Project                                                   
// ARM/FITkit3: Watchdog Timer Application (WDOG)                         
// Author: Taipova Evgeniya xtaipo00
// 16.12.2022
//
////////////////////////////////////////////////////////////////////////////


/* Header file with all the essential definitions for a given type of MCU */
#include "MK60D10.h"
// Macros for bit-level registers manipulation
#define GPIO_PIN_MASK 0x1Fu
#define GPIO_PIN(x) (((1)<<(x & GPIO_PIN_MASK)))

/* Mapping of LEDs and buttons to specific port pins: */
#define LED_D9  0x20 // Port B, bit 5
#define LED_D10 0x10 // Port B, bit 4
#define LED_D11 0x8 // Port B, bit 3
#define LED_D12 0x4 // Port B, bit 2

#define BTN_SW6 0x800     // Port E, bit 11

#define SPK 0x10          // Speaker is on PTA4

#define UNLOCK_1 0xC520
#define UNLOCK_2 0xD928


//Сhoose your mode
#define MODE 0x5 // Periodic Mode
//#define MODE 0xD //Windowed Mode

#define PERIOD 0x7D0 // Period size 
#define WINDOW 0x320 // Window size

#define ZERO 0

int pressed_btn = 0;
int beep_flag = 0;
unsigned int compare = 0x200;


/* A delay function */
void delay(long long bound) {

  long long i;
  for(i=0;i<bound;i++);
}

/* Initialize the MCU - basic clock settings */
void MCUInit(void)
{
    MCG_C4 |= ( MCG_C4_DMX32_MASK | MCG_C4_DRST_DRS(0x01) );
    SIM_CLKDIV1 |= SIM_CLKDIV1_OUTDIV1(0x00);
}

void PortsInit(void)
{
    /* Turn on all port clocks */
    SIM->SCGC5 = SIM_SCGC5_PORTB_MASK | SIM_SCGC5_PORTE_MASK | SIM_SCGC5_PORTA_MASK;

    /* Set corresponding PTB pins (connected to LED's) for GPIO functionality */
    PORTB->PCR[5] = PORT_PCR_MUX(0x01); // D9
    PORTB->PCR[4] = PORT_PCR_MUX(0x01); // D10
    PORTB->PCR[3] = PORT_PCR_MUX(0x01); // D11
    PORTB->PCR[2] = PORT_PCR_MUX(0x01); // D12

    PORTE->PCR[10] = PORT_PCR_MUX(0x01); // SW2
    PORTE->PCR[12] = PORT_PCR_MUX(0x01); // SW3
    PORTE->PCR[27] = PORT_PCR_MUX(0x01); // SW4
    PORTE->PCR[26] = PORT_PCR_MUX(0x01); // SW5
    PORTE->PCR[11] = PORT_PCR_MUX(0x01); // SW6

    PORTA->PCR[4] = PORT_PCR_MUX(0x01);  // Speaker

    /* Change corresponding PTB port pins as outputs */
    PTB->PDDR = GPIO_PDDR_PDD(0x3C);     // LED ports as outputs
    PTA->PDDR = GPIO_PDDR_PDD(SPK);     // Speaker as output
    PTB->PDOR |= GPIO_PDOR_PDO(0x3C);    // turn all LEDs OFF
    PTA->PDOR &= GPIO_PDOR_PDO(~SPK);   // Speaker off, beep_flag is false
}

void LPTMR0_IRQHandler(void)
{
    // Set new compare value set by up/down buttons
    LPTMR0_CMR = compare;                // !! the CMR reg. may only be changed while TCF == 1
    LPTMR0_CSR |=  LPTMR_CSR_TCF_MASK;   // writing 1 to TCF tclear the flag
    GPIOB_PDOR ^= LED_D9;                // invert D9 state
    GPIOB_PDOR ^= LED_D10;               // invert D10 state
}

void LPTMR0Init(int count)
{
    SIM_SCGC5 |= SIM_SCGC5_LPTIMER_MASK; // Enable clock to LPTMR
    LPTMR0_CSR &= ~LPTMR_CSR_TEN_MASK;   // Turn OFF LPTMR to perform setup
    LPTMR0_PSR = ( LPTMR_PSR_PRESCALE(0) // 0000 is div 2
                 | LPTMR_PSR_PBYP_MASK   // LPO feeds directly to LPT
                 | LPTMR_PSR_PCS(1)) ;   // use the choice of clock
    LPTMR0_CMR = count;                  // Set compare value
    LPTMR0_CSR =(  LPTMR_CSR_TCF_MASK    // Clear any pending interrupt (now)
                 | LPTMR_CSR_TIE_MASK    // LPT interrupt enabled
                );
    NVIC_EnableIRQ(LPTMR0_IRQn);         // enable interrupts from LPTMR0
    NVIC_EnableIRQ(WDOG_EWM_IRQn);
    LPTMR0_CSR |= LPTMR_CSR_TEN_MASK;    // Turn ON LPTMR0 and start counting
}

/* Initialize the Watchdog */
void WDOGInit()
{
	WDOG_UNLOCK = UNLOCK_1;
    WDOG_UNLOCK = UNLOCK_2;

    WDOG_STCTRLH = MODE;

    WDOG_TOVALH = ZERO;
    WDOG_TOVALL = PERIOD;

    WDOG_WINH = ZERO;
    WDOG_WINL = WINDOW;
}

// Speaker beeps and LEDs flash
void beepLight(void)
{
	int q;
	for (int q=0; q<500;q++){
		GPIOA_PDOR ^= SPK;                   // invert speaker state
		delay(1000);
		GPIOB_PDOR ^= LED_D11;               // invert D11 state
		GPIOB_PDOR ^= LED_D12;               // invert D12 state
	}

}


int main(void)
{
    MCUInit();
    PortsInit();
    LPTMR0Init(compare);
    WDOGInit();

    while (1) {
        
        // Press button SW6
        if (!pressed_btn && !(GPIOE_PDIR & BTN_SW6))
        {
            pressed_btn = 1;
            
            beepLight();

            //refresh WDOG
            WDOG_REFRESH = 0xA602;
    	    WDOG_REFRESH = 0xB480;

        }
        else if (GPIOE_PDIR & BTN_SW6) {
        	pressed_btn = 0;
        }
        //Reset system
    }

    return 0;
}
