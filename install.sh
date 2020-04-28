#!/usr/bin/env bash

curl -sfL https://git.io/chezmoi | sh
chezmoi init --apply --verbose https://github.com/abruneau/dotfiles.git
