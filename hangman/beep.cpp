/*
 * Filename 	: beep.cpp
 * Description	: make buzzer sound when prompted.
 * Author	: Spencer
*/
#include <wiringPi.h>
#include <stdio.h>

#define BeepPin 0

void beep()
{
	if (wiringPiSetup() == -1)
	{
		printf("setup wiringPi failed !");
		return;
	}
	digitalWrite(BeepPin, LOW);
	delay(100);
	digitalWrite(BeepPin, HIGH);
	return;
}
