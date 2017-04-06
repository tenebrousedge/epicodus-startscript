#!/bin/zsh -u

# clone prezto

git clone --recursive 'https://github.com/tenebrousedge/prezto' "$HOME"/.zprezto

# the way prezto does this is much more elegant. This should be more robust.
declare -a ZSH_DOTFILES=('zshrc' 'zshenv' 'zshlogin' 'zshlogout' 'zprofile' 'zpreztorc')
for dotfile in "${ZSH_DOTFILES[@]}"; do ln -s "$HOME/.zprezto/runcoms/$dotfile" "$HOME/.$dotfile"; done

# Make zsh the login shell

echo '[ -f /bin/zsh ] && exec /bin/zsh -l' >> "$HOME/.profile"

# clone the repo creator
exec_dir="$HOME/.local/bin"
if [[ ! -d "$exec_dir" ]]; then
mkdir "$exec_dir"
fi

np_dir="$HOME/new_project_script"
git clone 'https://github.com/tenebrousedge/new_project_script' "$np_dir"
ln -s "$np_dir/repo_init.sh" "$exec_dir/new_project" 
# set up nano

(brew install nano >/dev/null 2>&1)
git clone 'https://github.com/scopatz/nanorc' "$HOME"/.nano
mv "$HOME/.nano/nanorc" "$HOME/.nanorc"

# git config

git config --global 'core.editor' $(which nano)
git config --global 'core.autocrlf' 'input'
git config --global 'alias.ignore'  'update-index --assume-unchanged'
git config --global 'alias.unignore' 'update-index --no-assume-unchanged'
git config --global 'alias.ignored' '!git ls-files -v | grep "^h\"'

# git hooks

curl 'http://pre-commit.com/install-local.py' | python

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

npm install -g 'eslint'

# atom config

apm install 'file-icons'
apm install 'linter-csslint'
apm install 'linter-eslint'
apm install 'highlight-selected'
apm install 'autoclose-html'
apm install 'pigments'

# environment

export CDPATH="$HOME"/Desktop
## n.b. PATH is normally set in one's bashrc or zshrc. This script sets it here for reasons.
if [[ !":$PATH:" == *":$exec_dir:"* ]]; then
export PATH="$PATH:$exec_dir"
fi

return 0
