FROM rust:1.46-slim as rust

WORKDIR /rusty-prompt
COPY tools/rusty-prompt .
RUN apt update && apt install -y libssl-dev pkg-config
RUN cargo build --release

FROM golang:1.16 as go

WORKDIR /git-todo
COPY tools/git-todo .
RUN make

FROM debian:stretch-slim

LABEL maintainer="Andreas Linz <klingt.net@gmail.com>"

COPY --from=rust /rusty-prompt/target/release/rusty-prompt /usr/bin/rusty-prompt
COPY --from=go /git-todo/git-todo /usr/bin/git-todo

# enable testing repositories to install editorconfig
RUN apt update
RUN apt install -y bash\
            ncurses-term\
            vim\
            git\
            editorconfig\
            ruby\
            gpg\
            libcurl4-openssl-dev

RUN adduser --gecos dots --disabled-password --shell /bin/bash --quiet dots

COPY dots /home/dots
RUN chown -R dots:dots /home/dots

USER dots

# install vim plugins
RUN vim -u ~/.vim_vundle +PluginInstall +qall --cmd "let g:session_autosave = 'no'" &> /dev/null

WORKDIR /home/dots

CMD /bin/bash
