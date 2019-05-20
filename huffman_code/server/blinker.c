/**************************************
 * Filename	: blinker.c
 * Description	: controls blinking of 2 lights based on binary input
 * Author	: Shamilton
 * Date		: 05/16/19
**************************************/
#include <wiringPi.h>
#include <stdio.h>

#define  LedPin0    0
#define LedPin1	    1

int blink(char input)
{
	if (wiringPiSetup() == -1){
		printf("setup of wiring failed");
		return 1;
	}

	printf("%c ", input);
	if (input == 0)
	{
		pinMode(LedPin0, OUTPUT);
		digitalWrite(LedPin0, LOW); //on
		delay(50);
		digitalWrite(LedPin0, HIGH); //off
	        delay(50);
	}
	else if (input == 1)
	{
		pinMode(LedPin1, OUTPUT);
		digitalWrite(LedPin1, LOW); //on
		delay(50);
		digitalWrite(LedPin1, HIGH); //off
		delay(50);
	}
	else return 0;
	return 1;
}

