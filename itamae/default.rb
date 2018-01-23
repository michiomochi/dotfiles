# Looks up /usr/bin first
# because some machines use GNU coreutils as a primary POSIX command set, which
# are not compatible with the OSX"s build-in
ENV["PATH"] = "/usr/bin:#{ENV['PATH']}"

node.reverse_merge!(
  ruby: "2.3.1",
  nodejs: "9.4.0", # exclude "v" prefix. (e.g. "7.2.0")
  brew: {
    enable_update: false,
    enable_upgrade: false,
    add_repositories: %w(
      "homebrew/services"
    ),
    install_packages: [
      "autoconf",
      "cmake",
      "coreutils",
      "direnv",
      "envchain",
      "ghq",
      "hub",
      "imagemagick",
      "jq",
      "memcached",
      "mysql",
      "nodebrew",
      "packer",
      "peco",
      "phantomjs",
      "postgresql",
      "rbenv",
      "readline",
      "redis",
      "reattach-to-user-namespace",
      "tmux",
      "--with-lua vim",
      "wget",
    ]
  }
)

include_recipe "helpers"
include_recipe "homebrew::package"

home_dir = "/Users/#{run_command('whoami').stdout.strip}"

# -- ruby --
execute "brew upgrade ruby-build" do
  not_if "rbenv install --list | grep #{node[:ruby]}"
end

execute "RUBY_CONFIGURE_OPTS='--with-readline-dir=#{run_command("brew --prefix readline")}' rbenv install #{node[:ruby]}" do
  not_if "rbenv versions | grep #{node[:ruby]}"
end

execute "rbenv global #{node[:ruby]}" do
  not_if "rbenv version | grep #{node[:ruby]}"
end

template "#{home_dir}/.gemrc" do
  source "templates/dotfiles/.gemrc"
end

template "#{home_dir}/.pryrc" do
  source "templates/dotfiles/.pryrc"
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
template "#{home_dir}/.zshrc" do
  source "templates/dotfiles/.zshrc"
end

execute "echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells" do
  not_if "cat /etc/shells | grep '/usr/local/bin/zsh'"
end

# -- tmux --
template "#{home_dir}/.tmux.conf" do
  source "templates/dotfiles/.tmux.conf"
end

# -- git --
template "#{home_dir}/.gitconfig" do
  source "templates/dotfiles/.gitconfig"
end

template "#{home_dir}/.gitignore" do
  source "templates/dotfiles/.gitignore"
end

# -- vim --
template "#{home_dir}/.vimrc" do
  source "templates/dotfiles/.vimrc"
end

template "#{home_dir}/.dein.toml" do
  source "templates/dotfiles/.dein.toml"
end

template "#{home_dir}/.dein_lazy.toml" do
  source "templates/dotfiles/.dein_lazy.toml"
end
