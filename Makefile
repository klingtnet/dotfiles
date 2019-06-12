.PHONY: build run

NAME='dotfiles'
SHELL:=$(shell which bash)

all: try

build:
	make -C tools/rusty-prompt rusty-prompt

try: Dockerfile
	docker build -t ${NAME} .
	docker run --rm -it ${NAME}

# http://www.cyberciti.biz/faq/bash-considered-harmful-to-match-dot-files-why/
install: build
	cp --verbose -r dots/.[^.]* ~
	vim -u ~/.vim_vundle +PluginInstall --cmd "let g:session_autosave='no'" +qall
	./setup_nvim.sh
	./patch.sh apply
	make -C tools/rusty-prompt install
	touch ~/.$(shell whoami)
	make -C tools/xfce4-genmon-panel install

update:
	git subtree pull --squash --prefix dots/.vim/bundle/Vundle.vim/ git@github.com:VundleVim/Vundle.vim.git master -m "Update vundle"

clean:
	make -C tools/rusty-prompt clean
	make -C tools/xfce4-genmon-panel clean
