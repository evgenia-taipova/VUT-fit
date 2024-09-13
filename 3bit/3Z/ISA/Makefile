#  Projekt: DNS Resolver
#  Autor: Taipova Evgeniya
#  Login: xtaipo00
#  Předmět: Síťové aplikace a správa sítí (ISA)
#  Datum: 20.11.2023

CC = g++
CFLAGS = -Wall -Wextra -pedantic -std=c++11
LIBS = -lm -pthread
TARGET = dns
SRC = dns.cpp
OBJ = $(SRC:.cpp=.o)
HDR = dns.h

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $(TARGET) $(LIBS)

%.o: %.cpp $(HDR)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o $(TARGET)

test: $(TARGET)
	python3 test_dns_resolver.py