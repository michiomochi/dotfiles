# Looks up /usr/bin first
# because some machines use GNU coreutils as a primary POSIX command set, which
# are not compatible with the OSX"s build-in
ENV["PATH"] = "/usr/bin:#{ENV['PATH']}"

node.reverse_merge!(
  ruby: "2.6.0",
  nodejs: "10.15.0", # exclude "v" prefix. (e.g. "7.2.0")
  brew: {
    enable_update: false,
    enable_upgrade: false,
    add_repositories: [],
    install_packages: [
      "autoconf",
      "cmake",
      "coreutils",
      "direnv",
      "envchain",
      "ghq",
      "hub",
      "jq",
      "nodebrew",
      "packer",
      "peco",
      "rbenv",
      "readline",
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

# -- nodebrew --
execute "mkdir -p ~/.nodebrew/src/v#{node[:nodejs]}" do
  not_if "test -d ~/.nodebrew/src/v#{node[:nodejs]}"
end

execute "brew upgrade nodebrew" do
  not_if "nodebrew ls-remote | grep #{node[:nodejs]}"
end

execute "nodebrew install #{node[:nodejs]}" do
  not_if "nodebrew ls | grep #{node[:nodejs]}"
end

execute "nodebrew use #{node[:nodejs]}" do
  not_if "node -v | grep #{node[:nodejs]}"
end
