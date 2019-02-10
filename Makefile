.PHONY: build run

NAME='dotfiles'
SHELL:=$(shell which bash)

all: build

build: Dockerfile
	make -C tools/rusty-prompt rusty-prompt
	docker build -t ${NAME} .

try: build
	docker run --rm -it ${NAME}

# http://www.cyberciti.biz/faq/bash-considered-harmful-to-match-dot-files-why/
install:
	cp --verbose -r dots/.[^.]* ~
	vim -u ~/.vim_vundle +PluginInstall --cmd "let g:session_autosave='no'" +qall
	./setup_nvim.sh
	./patch.sh apply
	make -C tools/rusty-prompt install
	touch ~/.$(shell whoami)
	make -C tools/xfce4-genmon-panel install

update:
	git subtree pull --squash --prefix dots/.vim/bundle/Vundle.vim/ git@github.com:VundleVim/Vundle.vim.git master -m "Update vundle"
