function nix-shell --description 'alias nix-shell=nix-shell --command "fish -C \'fish_config theme choose dracula\'"'
    command nix-shell --command "fish -C 'fish_config theme choose dracula'" $argv
end
