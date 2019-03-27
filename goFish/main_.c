#include <stdio.h>
extern FILE * shuffle (FILE * fptr);
extern void dealcards(FILE * fptr, int arr[]);
extern int askcards_man(FILE * fptr, int arrPlayer[], int arrCPU[]);
extern int askcards_auto(FILE * fptr, int arrCPU[], int arrPlayer[]);
void displayPlayerHand(int arr[]);       // for DEBUGGING
void displayCPUHand(int arr[]);          // for DEBUGGING

int main(int argc, char *argv[])
{
    int winner;             // used to check for winner
    int player[14],cpu[14]; //index 0 to track card count, 1-13 to track pairs

    for (int i = 0; i < 14; ++i) {
        player[i] = 0;     // set total cards for player at 0
        cpu[i] = 0;        // set total cards for cpu at 0
    }
    FILE * fptr;

    if (argc > 1)                     // if file name indicated in main parameters
    {
        fptr = fopen(argv[1], "w");   // opens file indicated by filename in main parameter
    }
    else                              // if file name not indicated in main parameters
    {
        fptr = fopen("deck.dat", "w"); // open and set to write mode "deck.dat"
    }

    // place random number between 0-13 for card rank and place into file 52 times to represent a card deck
    shuffle(fptr);
    // close file
    //fclose(fptr);   // file closed in shuffle so line not necessary

    if (argc > 1)                      // if file name indicated in main parameters
    {
        fptr = fopen(argv[1], "r");    // opens file indicated by filename in main parameter
    }
    else                               // if file name not indicated in main parameters
    {
        fptr = fopen("deck.dat", "r"); // open and set to write mode "deck.dat"
    }

    dealcards(fptr, player);          // deal 5 cards to player
    player[0] = 5;                    // set total card count for player to 5

    displayPlayerHand(player);       // FOR DEBUGGING

    dealcards(fptr, cpu);             // deal 5 cards to cpu
    cpu[0] = 5;                       // set total card count for cpu to 5

    displayCPUHand(cpu);              // FOR DEBUGGING

    // play Go Fish
    while(1)   // while loop runs until winner is declared which breaks the while loop
    {
        //  have player ask CPU for cards in its deck, if no card, then Go Fish for player (draw a card),
        winner = askcards_man(fptr, player, cpu); //return winner; 0 no winner, 1 means player 1 won, 2 means cpu won

        displayPlayerHand(player);       //FOR DEBUGGING
        displayCPUHand(cpu);            // FOR DEBUGGING

        printf("\n\n");

        if (winner==1)
        {
            printf("\nCongratulations, you won the game!\n");
            break;
        }
        // have CPU ask player for a card based on random selection from its own deck, if player doesn't have a card, Go Fish for CPU
        winner = askcards_auto(fptr, cpu, player);

        displayPlayerHand(player);         // FOR DEBUGGING
        displayCPUHand(cpu);               // FOR DEBUGGING

        if (winner == 2)
        {
            printf("\nSorry, you lost. The CPU  won the game.\n");
            break;
        }


    }
    return 0;
}

// for FOR DEBUGGING
void displayPlayerHand(int arr[])
{
	int count = 0;
        printf("player deck:  ");
        for (int i = 0; i < 14; ++i) {
            printf("%d ", arr[i]);
        }
        printf("\n");
	for (int i = 0; i < 14; ++i)
	{
		if(arr[i]==2) count++;
		if(arr[i]==4) count+=2;
	}
	printf("player matches %d\n", count);


}

void displayCPUHand(int arr[])
{
	int count = 0;
        printf("cpu deck:     ");
        for (int i = 0; i < 14; ++i) {
            printf("%d ", arr[i]);
        }
        printf("\n");
	for (int i = 0; i < 14; ++i)
	{
		if(arr[i]==2) count++;
		if(arr[i]==4) count+=2;
	}
	printf("cpu matches %d\n", count);


}
