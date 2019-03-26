prime: prime.o checkPrimeNumber.o
	        gcc -o  prime prime.o checkPrimeNumber.o modulo.o
prime.o: prime.c
	        gcc -c prime.c
checkPrimeNumber.o: checkPrimeNumber.s modulo.s
	        gcc -c checkPrimeNumber.s modulo.s
modulo.o: modulo.s
		gcc -c modulo.s
