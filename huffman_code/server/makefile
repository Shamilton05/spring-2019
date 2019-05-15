receive: server.o decoder.o read_huffman.o search_hcode.o check_space.o
	        gcc -g -o receive server.o read_huffman.o decoder.o search_hcode.o check_space.o

server.o: server.c
	        gcc -g -c server.c

decoder.o: decoder.s
	        gcc -g -c decoder.s 

read_huffman.o: ../read_huffman.s
	        gcc -g -c ../read_huffman.s

check_space.o: ../check_space.s
		gcc -g -c ../check_space.s

search_hcode.o: ../search_hcode.s
		gcc -g -c ../search_hcode.s
