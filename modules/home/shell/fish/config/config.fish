if status is-interactive
    # Commands to run in interactive sessions can go here
    if not set -q FASTFETCH
        fastfetch
        echo
        set -gx FASTFETCH
    end
end

set -gx EDITOR vim
direnv hook fish | source
devenv hook fish -- --no-reload | source
zoxide init fish | source
set -l config_dir (path resolve (status filename))
