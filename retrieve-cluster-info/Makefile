BINARY_NAME := fetch-cluster-info
BIN_DIR := bin

.PHONY: all prepare build clean

all: prepare build

prepare:
	go mod tidy

build:
	mkdir -p $(BIN_DIR)
	CGO_ENABLED=0 GOOS=linux go build -o $(BIN_DIR)/$(BINARY_NAME) .

clean:
	rm -rf $(BIN_DIR)
