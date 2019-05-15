#include <unistd.h>
#include <stdio.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 8080
#define SERVER_IP "127.0.0.1"

typedef struct{                 // typedef structure
	    char letter;
	    int code[12];
	    int size;
} huffcode;                     // struct used to store huffman code

extern int read_huffman(FILE * fptr, huffcode hcode[]);
extern int read_message(FILE * fptr, char message[]);
extern int encode(char message[], huffcode hcode[]);
int socket_fp;

int main(int argc, char *argv[])
{
    FILE *fptr;                 // file pointer
    huffcode hcode[29];         // array used to store huffman code
    char message[10000];        // array used to store message from file to encode and send over to recipient
    int messageLngth = 0;

    if (argc ==1){
	    fptr = fopen("huffman.dat", "r");
    }

    // read the huffman code from the file and store huffman code into hcode array of structs
    read_huffman(fptr, hcode);
    fclose(fptr);

    // open the message to encode and send to recipient
    fptr = fopen("message.txt", "r");
    // read the message and store the message into the char array message[10000]
    messageLngth = read_message(fptr, message);
    fclose(fptr);	// close message.txt

    // encode the message stored in the message[] array and send the message as an integer in 32 bit or less chunks
   // encode(message, hcode);

    //set up socket
    socket_fp = socket(AF_INET, SOCK_STREAM, 0);
    struct sockaddr_in address;
    struct sockaddr_in server_address;
    server_address.sin_family = AF_INET;
    server_address.sin_port = htons(PORT);
    inet_pton(AF_INET, "127.0.0.1", &server_address.sin_addr);

    //connect
    connect(socket_fp, (struct sockaddr*) &server_address, sizeof(server_address));
    encode(message, hcode);
//    send(socket_fp, &message, messageLngth, 0);
  //  char buffer[1000];

   // int valread = read(socket_fp, buffer, 1000);
   // printf("%d\n", valread);
    close(socket_fp);
}

void send_packet(int *packet_pntr)
{
	write(socket_fp, packet_pntr, 4);
	return;
}
