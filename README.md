Antonin's Dotfiles
==================

This repository serves as my way to help me setup and maintain my Mac. It takes the effort out of installing everything manually. Everything needed to install my preferred setup of macOS is detailed in this readme.

## A Fresh macOS Setup

These instructions are for when you've already set up your dotfiles.

This setup uses [chezmoi.io](https://www.chezmoi.io/) to help manage configuration files (dotfiles, like ~/.bashrc) across multiple machines.

To get started, you can use this one line installer:

```sh
curl -sfL https://raw.githubusercontent.com/abruneau/dotfiles/master/install.sh | sh
```

Or install chezmoi.io and init with your repo:

```sh 
curl -sfL https://git.io/chezmoi | sh
chezmoi init --apply --verbose https://github.com/abruneau/dotfiles.git
```

## Updating setup

If you made changes to your Dotfiles and want to apply it to another system, pull the new version and apply it.

```sh
chezmoi cd
git pull
chezmoi -v apply
```