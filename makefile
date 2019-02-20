# makefile to create hangman
DEBUG ?= 1
ifeq ($(DEBUG), 1)
    CFLAGS =-DDEBUG -g
else
    CFLAGS=-DNDEBUG
endif

hangman: hangman.o wordGrabber.o beep.o
	gcc $(CFLAGS) -o hangman hangman.o wordGrabber.o beep.o
hangman.o: hangman.cpp
	gcc $(CFLAGS) -c hangman.cpp
wordGrabber.o: wordGrabber.cpp
	gcc $(CFLAGS) -c wordGrabber.cpp
beep.o: beep.cpp
	gcc $(CFLAGS) -c beep.cpp
# remove object files and backup files
clean: 
	rm -i *.o *~
