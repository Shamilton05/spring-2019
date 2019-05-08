go_fish: main_.o draw.o askcards_auto.o askcards_man.o dealcards_.o modulo_.o shuffle_.o checkwin_.o checkEmptyHand_.o
	gcc -g -o  go_fish main_.o draw.o askcards_auto.o askcards_man.o dealcards_.o modulo_.o shuffle_.o checkwin_.o checkEmptyHand_.o

main_.o: main_.c dealcards_.o askcards_man.o askcards_auto.o shuffle_.o checkwin_.o
	gcc -g -c main_.c dealcards_.o askcards_man.o askcards_auto.o shuffle_.o checkwin_.o

shuffle_.o: shuffle_.s modulo_.o
	gcc -g -c shuffle_.s modulo_.o

askcards_auto.o: askcards_auto.s modulo_.o checkwin_.o checkEmptyHand_.o
	gcc -g -c askcards_auto.s modulo_.o checkwin_.o checkEmptyHand_.o

askcards_man.o: askcards_man.s modulo_.o checkwin_.o checkEmptyHand_.o
	gcc -g -c askcards_man.s modulo_.o checkwin_.o checkEmptyHand_.o

dealcards_.o: dealcards_.s
	gcc -g -c dealcards_.s

draw.o: draw.s
	gcc -g -c draw.s

checkwin_.o: checkwin_.s
	gcc -g -c checkwin_.s

checkEmptyHand_.o: checkEmptyHand_.s modulo_.o
	gcc -g -c checkEmptyHand_.s modulo_.o

modulo_.o: modulo_.s
	gcc -g -c modulo_.s
