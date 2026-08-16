if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx EDITOR vim
direnv hook fish | source
set -l config_dir (dirname (status filename))
source $config_dir/devenv-hook.fish
