
function fish_logo \
    --description="Fish-shell colorful ASCII-art logo" \
    --argument-names outer_color medium_color inner_color mouth eye
    # defaults:
    [ $outer_color  ]; or set outer_color  'red'
    [ $medium_color ]; or set medium_color 'f70'
    [ $inner_color  ]; or set inner_color  'yellow'
    [ $mouth ]; or set mouth '['
    [ $eye   ]; or set eye   'O'
    
    set usage 'Usage: fish_logo <outer_color> <medium_color> <inner_color> <mouth> <eye>
    See set_color --help for more on available colors.'
    
    if contains -- $outer_color '--help' '-h' '-help'
    echo $usage
    return 0
    end
    
    # shortcuts:
    set o (set_color $outer_color)
    set m (set_color $medium_color)
    set i (set_color $inner_color)
    set n (set_color normal)
    
    if test (count $o) != 1; or test (count $m) != 1; or test (count $i) != 1
    echo 'Invalid color argument'
    echo $usage
    return 1
    end
    
    echo '
|===========================================|
|                    '$o'___'$n'                    |
|'$o'     ___======____='$m'-'$i'-'$m'-='$o')'$n'                   |
|'$o'   /T            \\_'$i'--='$m'=='$o')'$n'                  |
|'$o'   '$mouth' \\ '$m'('$i$eye$m')   '$o'\\~    \\_'$i'-='$m'='$o')'$n'                  |
|'$o'    \\      / )J'$m'~~    '$o'\\\\'$i'-='$o')'$n'                 |
|'$o'     \\\\\\\\___/  )JJ'$m'~'$i'~~   '$o'\\)'$n'                 |
|'$o'      \\_____/JJJ'$m'~~'$i'~~    '$o'\\\\'$n'                 |
|'$o'      '$m'/ '$o'\\  '$i', \\\\'$o'J'$m'~~~'$i'~~     '$m'\\\\'$n'               |
|'$m'     (-'$i'\\)'$o'\\='$m'|'$i'\\\\\\\\\\\\'$m'~~'$i'~~       '$m'L_'$i'_'$n'           |
|'$i'     '$m'('$o'\\\\'$m'\\\\)  ('$i'\\\\'$m'\\\\\\)'$o'_           '$i'\\=='$m'__'$n'      |
|'$m'      '$o'\\V    '$m'\\\\\\\\'$o'\\) =='$m'=_____   '$i'\\\\\\\\\\\\\\\\'$m'\\\\\\\\'$n' |
|'$m'             '$o'\\V)     \\_) '$m'\\\\\\\\'$i'\\\\\\\\JJ\\\\'$m'J\\)'$n'   |
|'$m'                         '$o'/'$m'J'$i'\\\\'$m'J'$o'T\\\\'$m'JJJ'$o'J)'$n'     |
|'$o'                         (J'$m'JJ'$o'| \\UUU)'$n'       |
|'$o'                          (UU)'$n'             |
|===========================================|
             boxed like a fish
'
end

