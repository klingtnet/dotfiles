.PHONY: build run

NAME='dotfiles'

all: build

build: Dockerfile
	docker build -t ${NAME} .

run: build
	docker run --rm -it ${NAME}

update:
	git subtree pull --squash --prefix dots/.vim/bundle/Vundle.vim/ git@github.com:VundleVim/Vundle.vim.git master
