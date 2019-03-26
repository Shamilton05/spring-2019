prime: prime.o checkPrimeNumber.o
	        gcc -o  prime prime.o checkPrimeNumber.o modulo.o
prime.o: prime.s
	        gcc -c prime.s
checkPrimeNumber.o: checkPrimeNumber.c modulo.s
	        gcc -c checkPrimeNumber.c modulo.s
modulo.o: modulo.s
		gcc -c modulo.s
