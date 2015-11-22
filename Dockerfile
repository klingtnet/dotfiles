FROM alpine:latest

MAINTAINER Andreas Linz <klingt.net@gmail.com>

RUN apk update &&\
    apk add bash\
            zsh\
            ncurses\
            vim\
            git

RUN adduser -D -s zsh dots

USER dots

COPY dots /home/dots

WORKDIR /home/dots

CMD /bin/bash
