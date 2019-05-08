#include <unistd.h>
#include <stdio.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 8080

int main()
{
    //set up socket
    int socket_fp = socket(AF_INET, SOCK_STREAM, 0);
    struct sockaddr_in address;
    struct sockaddr_in server_address;
    server_address.sin_family = AF_INET;
    server_address.sin_port = htons(PORT);
    inet_pton(AF_INET, "127.0.0.1", &server_address.sin_addr);

    //connect
    connect(socket_fp, (struct sockaddr*) &server_address, sizeof(server_address));
    unsigned int x = 7;
    send(socket_fp, &x, sizeof(x), 0);
    char buffer[1000];

    int valread = read(socket_fp, buffer, 1000);
    printf("%d\n", valread);

}