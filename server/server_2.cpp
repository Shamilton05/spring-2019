//sender.c source file
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define PORT 8080
#define SA struct sockaddr

int main(){
        int socketFp = socket(AF_INET, SOCK_STREAM, 0);
        unsigned int code;

        if(socketFp == -1){
                printf("Socket not made..\n");
                exit(0);
        }

        struct sockaddr_in address;

        address.sin_family = AF_INET;
        address.sin_addr.s_addr = INADDR_ANY;
        address.sin_port = htons(PORT);

        if((bind(socketFp, (SA *)&address , sizeof(address))) != 0){
                printf("Binding failed..\n");
                exit(0);
        }

        if((listen(socketFp, 3)) != 0){
                printf("Listen failed..\n");
                exit(0);
        }

        int addrLen = sizeof(address);

        int new_socket = accept(socketFp, (SA *)&address, (socklen_t *)&addrLen);

        if(new_socket < 0){
                        printf("Accept failed..\n");
                        exit(0);
        }

        read(new_socket, &code, sizeof(code));

        printf("Recieved: %d\n", code);

        close(socketFp);
}