require 'fileutils'

start_time = Time.now
output=''

# Set variables

# snag the user's home directory
home = Dir.home

# set the root folder for whatever scripts we download
#
# .local/share is specified by the open desktop specification
# this is not completely unknown on OSX but it may not
# but it works as well as anything else
data_home = ENV['XDG_DATA_HOME'] == "" ? "#{home}/.local/share" : ENV['XDG_DATA_HOME']

# set the folder where we symlink executables
#
# we will add this to the $PATH later
# nonstandard except for Debian/Ubuntu, but whatever works
exec_dir = "#{home}/.local/bin"

# directory for new project script
np_dir="$data_home/new_project_script"

# pairfile location
pairfile = File.join(home, '.pairs')

puts "Installing Prezto"

%x( git clone --recursive 'https://github.com/tenebrousedge/prezto' #{home}/.zprezto )

['zshrc', 'zshenv', 'zshlogin', 'zshlogout', 'zprofile', 'zpreztorc'].each do |name|
  File.symlink("#{home}/.zprezto/runcoms/#{name}", "#{home}/.#{name}" )
end

puts 'Creating Directories'

[exec_dir, data_home].each { |dir| FileUtils.mkdir_p(dir) if !Dir.exist?(dir) }

%x(git clone 'https://github.com/tenebrousedge/new_project_script' #{np_dir})

File.symlink("#{np_dir}/repo_init.sh", "#{exec_dir}/new_project")
File.symlink("#{np_dir}/new_ruby_project.sh", "#{exec_dir}/new_ruby_project")

puts 'Installing nano'

%x(brew install nano)
%x(git clone 'https://github.com/scopatz/nanorc' #{home}/.nano)
FileUtils.mv("#{home}/.nano/nanorc", "#{home}/.nanorc")

puts 'Configuring git'

%x( git config --global 'core.editor' `which nano`)
%x( git config --global 'core.autocrlf' 'input')
%x( git config --global 'alias.ignore'  'update-index --assume-unchanged')
%x( git config --global 'alias.unignore' 'update-index --no-assume-unchanged')
%x( git config --global 'alias.ignored' '!git ls-files -v | grep "^h\\"')

enable_pre_commit = gets "Enable pre-commit hooks for javascript, css, and ruby? [y/N]"
if enable_pre_commit.casecmp('y') == 0
    %x(curl 'http://pre-commit.com/install-local.py' | python)
    File.open(File.join(Dir.home, '.pre-commit-config.yaml')) << <<-EOM
-   repo: git://github.com/pre-commit/pre-commit-hooks
    sha: v0.4.2
    hooks:
    -   id: trailing-whitespace
    -   id: check-byte-order-marker
-   repo: git://github.com/pre-commit/mirrors-eslint
    sha: '5bf6c09bfa1297d3692cadd621ef95f1284e33c0'
    hooks:
    -   id: eslint
-   repo: git://github.com/pre-commit/mirrors-csslint
    sha: '818b64c6bf19ca1e089b4dabc8dc74059b405814'
    hooks:
    -   id: csslint
-   repo: https://github.com/jordant/rubocop-pre-commit-hook.git
    sha: 'ae431551f703fff928bfabe2b440a9a8048e962b'
    hooks:
    -   id: check-rubocop
EOM
end

%x(npm install -g 'eslint')
%x(apm install 'file-icons')
%x(apm install 'linter-csslint')
%x(apm install 'linter-eslint')
%x(apm install 'highlight-selected')
%x(apm install 'autoclose-html')
%x(apm install 'pigments')

unless ENV['PATH'].include? exec_dir
  output << <<-EOL
Info: #{exec_dir} is not in your $PATH.
Set it using the following command:
PATH=$PATH:#{exec_dir}
EOL
end

unless ENV['CDPATH']
  output << "Info: CDPATH is not set.\n"
end

if !File.exist(pairfile)
    create_pairfile = gets "Do you want to create a pairfile? [Y/n]"
    unless create_pairfile.casecmp('n') == 0
        `atom #{pairfile}`
    end
end

output << "Script Finished! Type 'zsh' into the command line to begin working."
output << "Script execution time: #{Time.now - start_time}"
