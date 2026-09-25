if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx EDITOR vim
direnv hook fish | source
devenv hook fish -- --no-reload | source
set -l config_dir (dirname (status filename))
