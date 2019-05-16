#include <unistd.h>
#include <stdio.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <netinet/in.h>

#define PORT 8080

typedef struct{                 // typedef structure
	    char letter;
	        int code[12];
		    int size;
} huffcode; // struct used to store huffman code

extern time_t time(time_t *t);
extern int read_huffman(FILE * fptr, huffcode hcode[]);
extern int sort_hcode(huffcode hcode[]);                 //FOR DEBUGGING
extern int decoder(int encoded_int, huffcode hcode[], int * current_char, char d_message[]);  // FOR DEBUGGING

int main(int argc, char *argv[])
{
    FILE *fptr;
    struct sockaddr_in address;
    huffcode hcode[29]; // array used to store huffman code
    unsigned int code; //store code from sender
    int c_in=0;
    char message[10000];
    int valread;

    // if no file name arguments in main then open deck.dat to read the huffman code
         if (argc == 1){
             fptr = fopen("huffman.dat", "r");
         }
         else{       // else open the string file name given as an argument to main
             fptr = fopen(argv[1], "r");
         }
    
    // read the huffman code from the file and store huffman code into hcode array of structs
    read_huffman(fptr, hcode);
    fclose(fptr); //close "huffman.dat"

    //set up socket
    int socket_fp = socket(AF_INET, SOCK_STREAM, 0);    //Params: Comm (IPV4/IPV6), TCP packet, 0 specifies internet protocol

    //bind -> address/PORT
    address.sin_family = AF_INET; //use IPV4
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);
    int addrlen = sizeof(address);
    bind(socket_fp, (struct sockaddr *) &address, addrlen);

    //listen
    listen(socket_fp, 3); //set queue size to three

    //accept
    int new_socket = accept(socket_fp, (struct sockaddr *) &address, (socklen_t *) &addrlen);

    valread = read(new_socket, &code, sizeof(code));
    while (valread != 0)
    {
    //receive
    printf("%u\n", code);
    decoder(code, hcode, &c_in, message);
    valread = read(new_socket, &code, sizeof(code));
    }

    printf(message);
    printf("\n");
    return 0;
}
