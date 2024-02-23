CC = gcc
CFLAGS = -std=gnu99 -Wall -Wextra -Werror -pedantic -g
LDFLAGS = -pthread -lrt
SRCS = proj2.c
TARGET = proj2

.PHONY: all $(TARGET) clean 

all: $(TARGET)

$(TARGET): $(SRCS)
	$(CC) $(SRCS) $(CFLAGS) $(LDFLAGS) -o $(TARGET)

clean:
	rm $(TARGET) proj2.out
