FROM rust:1.46-slim

WORKDIR /rusty-prompt
COPY tools/rusty-prompt .
RUN apt update && apt install -y libssl-dev pkg-config
RUN cargo build --release

FROM debian:stretch-slim

MAINTAINER Andreas Linz <klingt.net@gmail.com>

COPY --from=0 /rusty-prompt/target/release/rusty-prompt /usr/bin/rusty-prompt

# enable testing repositories to install editorconfig
RUN apt update
RUN apt install -y bash\
            zsh\
            ncurses-term\
            vim\
            git\
            editorconfig\
            ruby\
            gpg\
            libcurl4-openssl-dev

RUN adduser --gecos dots --disabled-password --shell /bin/zsh --quiet dots

COPY dots /home/dots
RUN chown -R dots:dots /home/dots

USER dots

# install vim plugins
RUN vim -u ~/.vim_vundle +PluginInstall +qall --cmd "let g:session_autosave = 'no'" &> /dev/null

WORKDIR /home/dots

CMD /bin/bash
