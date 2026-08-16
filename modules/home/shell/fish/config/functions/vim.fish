function vim --description 'alias vim vim'
    if test (count $argv) -eq 0
        command vim ~/todo.md
    else
        command vim $argv
    end
end
