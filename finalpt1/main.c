#include <stdio.h>
#include <stdlib.h>

void hack_password();

int main()
{
	hack_password();
	return 0;
}


int check_password(char passwd[]){
	char pass[4] = "0zZ";
	int check = 0;
	if (pass[0] == passwd[0])
		check = check + 100;
	if (pass[1] == passwd[1])
		check = check + 10;
	if (pass[2] == passwd[2])
		check = check + 1;
	//printf("passwd: %s produced %d\n", passwd, check);
	return check;
}
