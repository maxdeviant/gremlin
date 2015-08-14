BIN_DIR=$(shell pwd)/bin/
PREFIX?=/usr/local
INSTALL_BIN=$(PREFIX)/bin/

all:
	crystal run src/gremlin.cr

build:
	@mkdir -p $(BIN_DIR)
	crystal build -o $(BIN_DIR)gremlin src/gremlin.cr

install: build
	@cp $(BIN_DIR)gremlin $(INSTALL_BIN)gremlin
