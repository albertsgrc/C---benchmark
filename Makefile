all: timer/timer fibonacci/c++11 primality/c++11 collatz/c++11 matrixmul/c++11

timer/timer: timer/timer.cc
	g++ timer/timer.cc -std=c++11 -O2 -o timer/timer

fibonacci/c++11: fibonacci/c++11.cc
	g++ fibonacci/c++11.cc -std=c++11 -o fibonacci/c++11

primality/c++11: primality/c++11.cc
	g++ primality/c++11.cc -std=c++11 -o primality/c++11

collatz/c++11: collatz/c++11.cc
	g++ collatz/c++11.cc -std=c++11 -o collatz/c++11

matrixmul/c++11: matrixmul/c++11.cc
	g++ matrixmul/c++11.cc -std=c++11 -o matrixmul/c++11

clean:
	rm -f timer/timer
	rm -f fibonacci/c++11
	rm -f primality/c++11
	rm -f collatz/c++11
	rm -f matrixmul/c++11
