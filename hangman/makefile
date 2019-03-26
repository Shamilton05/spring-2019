# makefile to create hangman
DEBUG ?= 1
ifeq ($(DEBUG), 1)
    CFLAGS =-DDEBUG -g
else
    CFLAGS=-DNDEBUG
endif

hangman: hangman.o wordGrabber.o beep.o
	gcc $(CFLAGS) -o hangman hangman.o wordGrabber.o beep.o -lwiringPi
hangman.o: hangman.cpp
	gcc $(CFLAGS) -c hangman.cpp -lwiringPi
wordGrabber.o: wordGrabber.cpp
	gcc $(CFLAGS) -c wordGrabber.cpp
beep.o: beep.cpp
	gcc $(CFLAGS) -c beep.cpp -lwiringPi
# remove object files and backup files
clean: 
	rm -i *.o *~
