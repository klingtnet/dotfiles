.PHONY: build run

NAME='dotfiles'

all: build

build: Dockerfile
	docker build -t ${NAME} .

try: build
	docker run --rm -it ${NAME}

install:
	# http://www.cyberciti.biz/faq/bash-considered-harmful-to-match-dot-files-why/
	cp -r dots/.[^.]* ~
	vim -u ~/.vim_vundle +PluginInstall +qall

update:
	git subtree pull --squash --prefix dots/.vim/bundle/Vundle.vim/ git@github.com:VundleVim/Vundle.vim.git master
