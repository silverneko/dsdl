CC         = g++
OBJS       = src/main.o src/minterm.o src/forward.o

.cc.o:
	$(CC) -g -c $*.cc -o $@ -std=c++11 -O2
.cpp.o:
	$(CC) -g -c $*.cpp -o $@ -std=c++11 -O2
all: forward

forward: $(OBJS)
	$(CC) -o $@ $(OBJS) -std=c++11 -O2

clean : 
	rm -f *.o qm

src/main.o: src/main.cpp
src/minterm.o: src/minterm.cc
src/forward.o: src/forward.cpp
