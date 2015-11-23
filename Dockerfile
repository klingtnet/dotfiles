FROM alpine:latest

MAINTAINER Andreas Linz <klingt.net@gmail.com>

RUN apk update &&\
    apk add bash\
            zsh\
            ncurses\
            ncurses-terminfo\
            vim\
            git

RUN adduser -D -s zsh dots

COPY dots /home/dots
RUN chown -R dots:dots /home/dots

USER dots


WORKDIR /home/dots

CMD /bin/bash
