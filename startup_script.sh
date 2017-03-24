#!/bin/bash -u

# clone prezto

git clone --recursive 'https://github.com/tenebrousedge/prezto' "$HOME"/.zprezto

# the way prezto does this is much more elegant. This should be more robust.
ZSH_DOTFILES=(zshrc zshenv zshlogin zshlogout zprofile zpreztorc)
for dotfile in "$ZSH_DOTFILES"; do echo "$HOME/.zprezto/runcoms/$dotfile" "$HOME/.$dotfile"; done

# clone the repo creator
exec_dir=$HOME/bin
mkdir "$exec_dir"
git clone 'https://github.com/tenebrousedge/new_project_script' "$exec_dir" 

# set up nano

git clone 'https://github.com/scopatz/nanorc' "$HOME"/.nano
cat "$HOME"/.nano/nanorc >> "$HOME"/.nanorc

# git config

git config --global 'core.editor' $(which nano)
git config --global 'core.autocrlf' 'input'
git config --global 'alias.ignore'  'update-index --assume-unchanged'
git config --global 'alias.unignore' 'update-index --no-assume-unchanged'
git config --global 'alias.ignored' '!git ls-files -v | grep "^h\"'

# git hooks

curl http://pre-commit.com/install-local.py | python

cat >>"$HOME"/.pre-commit-config.yaml <<'EOM'
-   repo: git://github.com/pre-commit/pre-commit-hooks
    sha: v0.4.2
    hooks:
    -   id: trailing-whitespace
    -   id: check-byte-order-marker
-   repo: git://github.com/pre-commit/mirrors-eslint
    sha: 3.14.0
    hooks:
    -   id: eslint
EOM

# npm

npm install 'eslint'

# atom config

apm install 'file-icons'
apm install 'linter-csslint'
apm install 'linter-eslint'
apm install 'minimap'
apm install 'minimap-hide'
apm install 'highlight-selected'
apm install 'minimap-highlight-selected'
apm install 'autoclose-html'
apm install 'pigments'

# environment

export CDPATH="$HOME"/Desktop
## n.b. PATH is normally set in one's bashrc or zshrc. This script sets it here for reasons.
export PATH="$PATH:$exec_dir"
exit 0
