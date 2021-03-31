.PHONY: git-todo

all: git-todo

git-todo:
	go build -o $@ .

install: git-todo
ifeq ($$EUID, 0)
	@install --mode=0755 --verbose git-todo /usr/local/bin
else
	@install --mode=0755 --verbose git-todo $$HOME/.local/bin
endif