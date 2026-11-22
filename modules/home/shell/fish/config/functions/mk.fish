function mk --description "make and enter a directory"
    if not set -q argv[1]
        echo "No directory provided!"
        return 1
    end

    if test -d $argv[1]
        echo "Directory \"$argv[1]\" already exists!"
        return 1
    end

    mkdir -p $argv[1]
    cd $argv[1]
end
