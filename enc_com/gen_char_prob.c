/**
* Reads from a text file and generates the probability of each character based on their number of occurences
**/
#include <stdio.h>
#include <ctype.h>

int mani (int argc, char *argv[])
{
	FILE *fp;
	int numch[29]; 				//tracks the number of times each character occurs
	char c;
	float totchar = 0;

	if (argc>1) 				//if user specified filename
	{
		fp = fopen(argv[1], "r");
	}
	else					//default to book.txt
	{
		fp  = fopen("book.txt", "r");
	}
	
	for (int i =0; i < 29; i++)		//initialize array
	{
		numch[i] = 0;
	}

	while (!feof(fp))			//read each character from the text file
	{
		fscanf(fp, "%c", &c);		//read the char from file
		c = tolower(c);			//make lowercase
		if ('a' <= c && c <= 'z')
		{
			numch[c-'a'] = numch[c-'a']+1;
			totchar++;
		}
		else if (c == '.' || c == '!' || c == '?' || ';')
		{
			numch[26] = numch[26]+1;
			totchar++;
		}
		else if (c == ' ')
		{
			numch[27] = numch[27]+1;
			totchar++;
		}
		else if (c == ',')
		{
			numch[28] = numch[28]+1;
			totchar++;
		}
	}
	
	for (int i = 0; i < 26; i++)
	{
		printf("%c %f \n", 'a' + i, numh[i]/totchar);
	}
	printf(". %f\n", numch[26]/totchar);
	printf("<space> %f\n", numch[27]/totchar);
	printf(", %f\n", numch[28]/totchar);
	fclose(fp);
}
