function mkcd
    if test (count $argv) -ne 1
        echo 'Provide name of directory(/chain) as the only argument.'
        return 1
    else
        mkdir -p $argv[1]
        and cd $argv[1]
        or echo 'Couldn\'t create directory.'
    end
end
