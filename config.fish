# functions {{{1
function load_file_if_exists
  if [ -f $argv ]
      source $argv
  end
end
# }}}
# PATH {{{1
# }}}
# general {{{1
# 表示言語設定
export LANG=en_US.UTF-8

# historyの設定

# pecoを使用したincremental searchの有効化
# }}}
# aliases {{{1
balias ls "gls -F --color=auto"
balias ll 'ls -l -a -G'
balias la 'ls -A -G'
balias l  'ls -v -A -G'
balias updatedb '/usr/libexec/locate.updatedb'
balias vi 'vim'
balias gg 'git grep -n'
balias gc 'git commit -v'
balias gd 'git diff'
balias gl 'git pull'
balias ga 'git add'
balias gss 'git status -s'
balias gch 'git checkout'
balias gp 'git push -u'
balias gb 'git branch'
balias grh 'git reset HEAD'
balias glg 'git log --stat'
balias gca 'git commit -v --amend'
balias rm 'rm -i'
balias cp 'cp -i'
balias mv 'mv -i -v'
balias be 'bundle exec'
balias rs 'bundle exec rails server -b 0.0.0.0'
balias webpack "./node_modules/.bin/webpack-dev-server --config config/webpack.config.js"
balias sidekiq "bundle exec sidekiq -C config/sidekiq.yml"

# prompts {{{1
function fish_prompt
  set_color ff6f6b
  echo (whoami)"@"(hostname)
  set_color 6a76fc
  echo "["(pwd)"]"
  set_color white
  echo "> "
end

function fish_right_prompt
  if git_is_repo
    if git_is_dirty
      set_color ac50ef
      echo "☂ "
    else if git_untracked_files > /dev/null 2 >&1
      set_color ac50ef
      echo "☂ "
    else
      set_color ffd467
      echo "☀ "
    end
  end
  set_color 00a50e
  echo "["(git_branch_name)"]"
end
# }}}

# ターミナルの定義
export TERM=xterm-256color
# import local settings
[ -s {$HOME}/config.fish.local ]; and source {$HOME}/config.fish.local

# direnv
eval (direnv hook fish)

# vim: foldmethod=marker
# vim: foldcolumn=3
# vim: foldlevel=0
