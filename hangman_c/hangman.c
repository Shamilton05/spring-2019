#include <stdlib.h>
#include <time.h>
#include <stdio.h>
#include "hangman.h"
#include "wordGrabber.h"
#define MAX_WORD_SIZE 80
#define LOSE 7
#define MAXLETTERS 26

void beep();

int main(int argc, char *argv[])
{
	char word[MAX_WORD_SIZE];
	char hangman[LOSE+1] = "HANGMAN";
	char triedBin[MAXLETTERS];
	char displayBin[MAX_WORD_SIZE];
        FILE *wordList;
	int count, right, wrong, tried;
	int hit;
	char guess;

	wordList = fopen("dictionary.txt", "r");
	count = getWord(wordList, word);

	for (int i = 0; i < count; i++)
	{
		displayBin[i] = '_';
	}
	right = wrong = tried = 0;
	printf("Welcome to hangman. Enter characters to guess the word\n");
	for (int i = 0; i < count; i++)
	{
		printf("%c", displayBin[i]);
	}
	printf("\n");
	while (right < count && wrong < LOSE)
	{
		prompt:
		scanf("%c", &guess);
		while ((getchar()) != '\n');
		hit = 0;
		for (int i = 0; i < tried; i++)
		{
			if (guess == triedBin[i])
			{
			printf("You already tried that letter\n");
			goto prompt;
			}
		}
		triedBin[tried++] = guess;
		for (int i = 0; i < count; i++ )
		{
			if (word[i] == guess)
			{
				displayBin[i] = guess;
				right++;
				hit = 1;
			}
		}
		if (!hit) 
		{	
			beep();
			printf("Try again.\n");
			wrong++;
		}
		else 
			{printf("Nice!\n");}
		for (int i = 0; i < count; i++)
			{printf("%c", displayBin[i]);}
		printf("\n");
		for (int i = 0; i < LOSE; i++)
		{
			if (i < wrong)
			{
				printf("%c", hangman[i]);
			}
			else printf("-");
		}
		printf("\n");
	}
	if (right == count) 
		{printf("You won!\n");}
	else
		 {printf("You did not win!\n");}
	return 0;
}
