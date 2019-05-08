//client.c source file
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 8080
#define SA struct sockaddr
int main(){
        int socketFp = socket(AF_INET, SOCK_STREAM, 0);
        int code = 2019;
        struct sockaddr_in address, serverAddress;

        serverAddress.sin_family = AF_INET;
        serverAddress.sin_port = htons(PORT);
        serverAddress.sin_addr.s_addr = inet_addr("127.0.0.1"); // dif

        if(connect(socketFp, (SA *)&serverAddress, sizeof(serverAddress)) != 0){
                printf("connection failed..\n");
                exit(0);
        }

        write(socketFp, &code, sizeof(code));

        close(socketFp);
}