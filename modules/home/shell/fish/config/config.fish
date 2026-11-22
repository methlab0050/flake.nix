if status is-interactive
    # Commands to run in interactive sessions can go here
    if not set -q LARP
        if string match -q $TERM "linux"
            set -gx LARP "fish_logo"
            fish_logo magenta brmagenta blue
        else
            set -gx LARP "fastfetch"
            fastfetch
            echo
        end
    end
 
    if set -q ZELLIJ_PANE_ID; and test $ZELLIJ_PANE_ID -eq 0; and not string match $LARP "zellij"
        set -gx LARP "zellij"
        set altk (set_color 'blue')Alt
        set ctrlk (set_color 'purple')Ctrl
        set txt (set_color -d 'white')
        set key (set_color 'yellow')
        set end (set_color --reset)
        set pls (set_color -d 'brwhite')+$end

        echo Zellij quickhelp
        echo ================================
        echo $ctrlk$pls$altk$pls$key"←↑↓→"$txt" change focus"$end
        echo $ctrlk$pls"   "$pls$key"t   "$txt" add tab"$end
        echo "    "$pls$altk$pls$key"[]  "$txt" change layout"$end
        echo
    end

end

set -gx EDITOR vim
direnv hook fish | source
devenv hook fish -- --no-reload | source
zoxide init fish | source
set -l config_dir (path resolve (status filename))
