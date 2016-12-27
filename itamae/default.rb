# Looks up /usr/bin first
# because some machines use GNU coreutils as a primary POSIX command set, which
# are not compatible with the OSX"s build-in
ENV["PATH"] = "/usr/bin:#{ENV['PATH']}"

node.reverse_merge!(
  ruby: "2.3.1",
  nodejs: "7.2.0", # exclude "v" prefix. (e.g. "7.2.0")
  brew: {
    enable_update: false,
    enable_upgrade: false,
    add_repositories: %w(
      "homebrew/services"
    ),
    install_packages: %w(
      autoconf
      cmake
      coreutils
      direnv
      envchain
      ghq
      hub
      imagemagick
      jq
      memcached
      nodebrew
      packer
      peco
      phantomjs
      postgresql
      rbenv
      redis
      tmux
      wget
    )
  }
)

require "itamae/secrets"
node[:vault] = Itamae::Secrets(File.join(__dir__, "vault"))

include_recipe "homebrew::package"

# -- ruby --
execute "brew upgrade ruby-build" do
  not_if "rbenv install --list | grep #{node[:ruby]}"
end

execute "rbenv install #{node[:ruby]}" do
  not_if "rbenv versions | grep #{node[:ruby]}"
end

execute "rbenv global #{node[:ruby]}" do
  not_if "rbenv version | grep #{node[:ruby]}"
end

template "/Users/#{run_command('whoami').stdout.strip}/.gemrc" do
  source "templates/dotfiles/.gemrc"
end

# -- nodebrew --
execute "mkdir -p ~/.nodebrew/src/v#{node[:nodejs]}" do
  not_if "test -d ~/.nodebrew/src/v#{node[:nodejs]}"
end

execute "brew upgrade nodebrew" do
  not_if "nodebrew ls-remote | grep #{node[:nodejs]}"
end

execute "nodebrew install-binary #{node[:nodejs]}" do
  not_if "nodebrew ls | grep #{node[:nodejs]}"
end

execute "nodebrew use #{node[:nodejs]}" do
  not_if "node -v | grep #{node[:nodejs]}"
end

# -- shell --
template "/Users/#{run_command('whoami').stdout.strip}/.zshrc" do
  source "templates/dotfiles/.zshrc"
end

execute "echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells" do
  not_if "cat /etc/shells | grep '/usr/local/bin/zsh'"
end

# -- tmux --
template "/Users/#{run_command('whoami').stdout.strip}/.tmux.conf" do
  source "templates/dotfiles/.tmux.conf"
end

# -- git --
template "/Users/#{run_command('whoami').stdout.strip}/.gitconfig" do
  source "templates/dotfiles/.gitconfig"
end

template "/Users/#{run_command('whoami').stdout.strip}/.gitignore" do
  source "templates/dotfiles/.gitignore"
end
