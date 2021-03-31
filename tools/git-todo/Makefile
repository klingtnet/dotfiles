.PHONY: git-todo
VERSION:=$(shell git describe --always --tags)

all: git-todo

git-todo:
	go build -o $@ -ldflags='-X main.Version=$(VERSION)' .

install: git-todo
ifeq ($$EUID, 0)
	@install --mode=0755 --verbose git-todo /usr/local/bin
else
	@install --mode=0755 --verbose git-todo $$HOME/.local/bin
endif