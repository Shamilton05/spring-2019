#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// gets word from list of words given in the file and returns the length of the word
int getWord(FILE *fp, char keyword[80])
{
	int count, numWords, rNum;
	fscanf(fp, "%d", &numWords);
	srand(time(0));
	rNum = rand() % numWords;
	for (int i = 0; i <= rNum; i++)
	{
		fscanf(fp, "%s", keyword);
	}
	count = 0;
	while(*keyword!='\0')
	{count++; keyword++;}
	return count;
}
