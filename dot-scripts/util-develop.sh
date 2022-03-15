

pyenv() { # Either create a python environment, or activate one if we have one
    if [ ! -d "./venv" ]; then
        if [ $# -eq 0 ]; then
            echo "No environment yet, to setup one,"
            echo "run 'pyenv <python_interprenter>'"
            return 1
        fi
        $1 -m venv venv
    fi
    source venv/bin/activate
}

hex() { # print the hex value of a number 'hex 11 = b'
   emulate -L zsh
   if [[ -n "$1" ]]; then
       printf "%x\n" $1
   else
       print 'Usage: hex <dec-number-to-convert>'
       return 1
   fi
}

dec() { # print dec value of a number, type as 0x: 'dec 0xb = 11'
    emulate -L zsh
    if [[ -n "$1" ]]; then
        printf "%d\n" $1
    else
        print 'Usage: dec 0x<hex-number-to-convert>'
        return 1
    fi
}

mr() { # Pushes, and immediately creates a merge request, then opens a browser to it
    if [ $# -eq 0 ]; then
        echo "Give 1 argument: The branch name to merge into"
    else
        echo "Pushing and making merge request..."
        git push -o merge_request.create -o merge_request.target="$1" 2>&1 |\
            \grep -o "https:.*" | xargs xdg-open
    fi
}

alias pr="mr"

