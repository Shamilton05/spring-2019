#include <stdio.h>
int checkPrimeNumber(int n);
int main()
{
	int n1, n2, i, flag;

	printf("Enter two positive integers: ");
	scanf("%d %d", &n1, &n2);
	printf("Prime numbers between %d and %d are: \n", n1, n2);

	for(i=n1+1; i<n2; ++i)
	{
		flag = checkPrimeNumber(i);

		if(flag==1)
		{printf("%d ",i);}
	}
	printf("\n");
	return 0;
}
