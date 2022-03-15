
extract () { # Extract any kind of zip file
    if [ ! -f $1 ] ; then
        echo "'$1' is not a valid file"
        exit 1
    fi
    case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *) [ "$2" -ne "-q" ] echo "cannot extract '$1'" ;;
    esac
}

zip-check() {
    local checkdir="./zip-check"
    if [ -d "$checkdir" ]; then
        echo "A zip check dir already exists though..."
        exit 1
    fi
    # Make dir, and maybe copy something
    mkdir "$checkdir"
    [ -z "$@" ] || cp "$@" "$checkdir"
    cd "$checkdir"
    if [ ! -z "$@" ]; then
        for f in ./*; do
            extract "$f"
        done
    fi
}

function wc() {
    /usr/bin/wc "$1" | awk '{print $2 " words, " $1 " lines"}'
}



