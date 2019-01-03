# vim:ft=zsh ts=2 sw=2 sts=2

rvm_current() {
  rvm current 2>/dev/null
}

rbenv_version() {
  rbenv version 2>/dev/null | awk '{print $1}'
}

# ZSH_PROMPT_BASE_COLOR="%{$fg[blue]%}"

PROMPT='
%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[yellow]%}%M:%{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%} $(git_prompt_info)$(svn_prompt_info)
⇒ '

# Must use Powerline font, for \uE0A0 to render.
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}git %{$fg[magenta]%}\uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_REPO_NAME_COLOR="%{$fg[magenta]%}"
ZSH_THEME_SVN_PROMPT_PREFIX="svn %{$fg[magenta]%}\uE0A0 "
ZSH_THEME_SVN_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_SVN_PROMPT_DIRTY="%{$fg[red]%}!%{$reset_color%}"
ZSH_THEME_SVN_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_SVN_PROMPT_CLEAN=""



