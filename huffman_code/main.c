/* main.c
 * This program reads a message from a text file, encodes the
 * message using huffman binary encoding, and then transmits the message
 * to a recipient.
 *
*/

#include <stdio.h>
#include <stdlib.h>

typedef struct{                 // typedef structure
    char letter;
    int code[12];
    int size;
} huffcode;                     // struct used to store huffman code

extern int read_huffman(FILE * fptr, huffcode hcode[]);
extern int read_message(FILE * fptr, char message[]);
extern int encode(char message[], huffcode hcode[]);
extern int sort_hcode(huffcode hcode[]);                 //FOR DEBUGGING
extern int decoder(int encoded_int, huffcode hcode[], int * current_char, char d_message[]);  // FOR DEBUGGING

int main (int argc, char *argv[]){
    FILE *fptr;                 // file pointer
    huffcode hcode[29];         // array used to store huffman code
    char message[10000];        // array used to store message from file to encode and send over to recipient
    int messageLngth = 0;
    int current_char = 0;       // FOR DEBUGGING
    char d_message[10000];      // FOR DEBUGGING

    // if no file name arguments in main then open deck.dat to read the huffman code
    if (argc == 1){
        fptr = fopen("huffman.dat", "r");
    }
    else{       // else open the string file name given as an argument to main
        fptr = fopen(argv[1], "r");
    }

    // read the huffman code from the file and store huffman code into hcode array of structs
    read_huffman(fptr, hcode);
    fclose(fptr);               //close "huffman.dat"

    // open the message to encode and send to recipient
    fptr = fopen("message.txt", "r");
    // read the message and store the message into the char array message[10000]
    messageLngth = read_message(fptr, message);
    fclose(fptr);               // close message.txt

    // USE TO DEBUG CODE
    printf("\n\nThis is the message from message.txt that is stored in message[10000] array:\n\n");
    for (int i = 0; i < messageLngth; ++i) {
        printf("%c", message[i]);
    }
    printf("\n\n\nBased on the message in \"message.txt\", these are the int packets that are going to be sent over the ip address:\n\n");
    // STOP DEBUG

    // encode the message stored in the message[] array and send the message as an integer in 32 bit or less chunks
    encode(message, hcode);

    // DEBUGGING
    printf("\n\nThis is the hcode array stored according to \"huffman.dat\" (in a-z format):\n\n");
    for (int i = 0; i < 29; ++i) {
        printf("%c ", hcode[i].letter);
        for (int j = 0; j < hcode[i].size; ++j) {
            printf("%d", hcode[i].code[j]);
        }
        printf(" %d\n",hcode[i].size);
    }


    sort_hcode(hcode);  // sort the hcode according to huffman code bit length

    printf("\n\nThis is the hcode array sorted according to the length of huffman bits: \n");
    for (int i = 0; i < 29; ++i) {
        printf("%c ", hcode[i].letter);
        for (int j = 0; j < hcode[i].size; ++j) {
            printf("%d", hcode[i].code[j]);
        }
        printf(" %d\n",hcode[i].size);
    }

    // DEBUGGING  contains the int packets sent over according to the output on the user console
    decoder(2337374144, hcode, &current_char, d_message);
    decoder(3120004608, hcode, &current_char, d_message);
    decoder(266968856, hcode, &current_char, d_message);
    decoder(246611456, hcode, &current_char, d_message);
    decoder(201309136, hcode, &current_char, d_message);
    decoder(4048354120, hcode, &current_char, d_message);
    decoder(584348224, hcode, &current_char, d_message);
    decoder(3218971328, hcode, &current_char, d_message);
    decoder(4252540732, hcode, &current_char, d_message);
    decoder(3848216552, hcode, &current_char, d_message);
    decoder(2611198944, hcode, &current_char, d_message);
    decoder(232414464, hcode, &current_char, d_message);
    decoder(3154116608, hcode, &current_char, d_message);

    printf("\n\nThis is the decoded message that was, after decoding, stored in the d_message[10000] array:\n\n");
    for (int i = 0; i < 110; ++i) {
        printf("%c", d_message[i]);
    }
    printf("\n\n");
    // STOP DEBUG


    return 0;
}
