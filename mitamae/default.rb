home_dir = "/Users/#{run_command('whoami').stdout.strip}"

template "#{home_dir}/.zshrc" do
  source "templates/.zshrc"
end

template "#{home_dir}/.gitconfig" do
  source "templates/.gitconfig"
end

template "#{home_dir}/.gitignore" do
  source "templates/.gitignore"
end

template "#{home_dir}/.tmux.conf" do
  source "templates/.tmux.conf"
end

template "#{home_dir}/.gemrc" do
  source "templates/.gemrc"
end

template "#{home_dir}/.pryrc" do
  source "templates/.pryrc"
end

template "#{home_dir}/.vimrc" do
  source "templates/.vimrc"
end

template "#{home_dir}/.dein.toml" do
  source "templates/.dein.toml"
end

template "#{home_dir}/.dein_lazy.toml" do
  source "templates/.dein_lazy.toml"
end

