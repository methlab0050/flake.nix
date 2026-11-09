function reload --wraps='devenv shell --no-reload' --description 'alias reload devenv shell --no-reload'
    devenv shell --no-reload $argv
end