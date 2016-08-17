FROM alpine:edge

MAINTAINER Andreas Linz <klingt.net@gmail.com>

# enable testing repositories to install editorconfig
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories
RUN apk update &&\
    apk add bash\
            zsh\
            ncurses\
            ncurses-terminfo\
            vim\
            git\
            editorconfig

RUN adduser -D -s zsh dots

COPY dots /home/dots
RUN chown -R dots:dots /home/dots

USER dots

# install vim plugins
RUN vim -u ~/.vim_vundle +PluginInstall +qall --cmd "let g:session_autosave = 'no'" &> /dev/null

WORKDIR /home/dots

CMD /bin/bash
