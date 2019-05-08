#include <unistd.h>
#include <stdio.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <netinet/in.h>

#define PORT 8080

int main()
{
    struct sockaddr_in address;
    unsigned int code; //store code from sender
    int c_in;
    char message[10000];
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

    //receive
    int valread = read(new_socket, &code, sizeof(code));
    printf("%u\n", code);
    //decoder(code, hcode, &c_in, message);
    //print_message(message);
}
