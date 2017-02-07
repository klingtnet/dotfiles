# klingt.net's dotfiles

The latest edition of my dotfiles.
This time I tried to make the prompt as minimal as possible without omitting relevant informations.
Both prompts, bash and zsh are looking identical, except that there is no version control prompt for bash.
I'm also using defaults wherever possible, so customization is really easy.

[Try](#Try) it yourself: `make try` (requires docker)

![vim with papercolor theme](vim.png)
![terminal with solarized-dark theme](terminal-dark.png)
![terminal with solarized-light theme](terminal-light.png)

## Prompt Features

- subshell level if > 0
- number of background jobs if > 0
- return code if non zero
- root username is red
- git branch (zsh only)
- works with light and dark shell color themes

## Try

```sh
$ make try
```

- requires docker
- spins up a small alpine linux container

## Install

**WARNING** The installation will overwrite your original *dots* without confirmation!

```sh
$ make install
```

## Customize

You can create a patch file of your custom dotfile settings:

```sh
$ ./patch.sh create
```

The install script will check if the patch file exists and apply them after a successful installation.
You can also apply them manually by running: `./patch.sh apply`.
