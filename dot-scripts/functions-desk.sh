
alias feh="feh --scale-down --auto-zoom"
alias class='xprop | grep WM_CLASS'
alias xclip='xclip -sel clip'

screenshot() { # Take a screenshot, then save it to your clipboard and to file
    maim --hidecursor -s | tee ~/.screenshot.png | xclip -selection clipboard -t image/png
}

remindme() {
    local TIME_TO_SLEEP=$1
    if [[ $TIME_TO_SLEEP == *m ]]; then
        TIME_TO_SLEEP=$(echo "$TIME_TO_SLEEP" | sed 's/.$//')
        TIME_TO_SLEEP=$((60 * $TIME_TO_SLEEP))
    fi
    echo "I will remind you in $TIME_TO_SLEEP seconds ($1)"
    (sleep $1 && notify-send ${@:2} -u critical) &
    disown %-
}

dockerx() {
    xhost local:root
    docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix $@
}

. "$KDOT_DIR/dot-scripts/util-peripherals.sh"


