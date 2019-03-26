# makefile to create hangman

hangman: hangman.o wordGrabber.o beep.o
	gcc  -o hangman hangman.o wordGrabber.o beep.o -lwiringPi
hangman.o: hangman.c
	gcc  -c hangman.c -lwiringPi
wordGrabber.o: wordGrabber.c
	gcc  -c wordGrabber.c
beep.o: beep.c
	gcc  -c beep.c -lwiringPi
# remove object files and backup files
clean: 
	rm -i *.o *~
