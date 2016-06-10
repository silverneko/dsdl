CC         = g++
OBJS       = src/quine_mc_cluskey.o src/minterm.o src/forward.o

.cpp.o:
	$(CC) -g -c $*.cpp -o $@ -std=c++11 -O2

all: forward

forward: $(OBJS)
	$(CC) -o $@ $(OBJS) -std=c++11 -O2

clean : 
	rm -f src/*.o

src/quine_mc_cluskey.o: src/quine_mc_cluskey.cpp
src/minterm.o: src/minterm.cpp
src/forward.o: src/forward.cpp
