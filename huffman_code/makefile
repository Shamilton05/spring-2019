send: client.o encode.o read_huffman.o read_message.o
	gcc -g -o send client.o read_huffman.o read_message.o encode.o

client.o: client.c
	gcc -g -c client.c

encode.o: encode.s
	gcc -g -c encode.s 

read_huffman.o: read_huffman.s
	gcc -g -c read_huffman.s

read_message.o: read_message.s
	gcc -g -c read_message.s
