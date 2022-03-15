
resetaudio() {
    pulseaudio --kill
    sleep 2
    echo "Started pulse audio"
    pulseaudio &
}

resetmouse() {
    sudo rmmod i2c_hid
    sudo modprobe i2c_hid
    sleep 1
    xinput --set-prop "SYNA307B:00 06CB:CD46 Touchpad" "libinput Natural Scrolling Enabled" 1
}

hdmi(){
    xrandr --output HDMI-0 --auto
}

bluetooth() {
    echo "1/3 - Starting bluetooth service"
    sudo rfkill unblock bluetooth
    sudo systemctl start bluetooth.service
    echo "2/3 - Using bluetoothctl"
    bluetoothctl power on
    bluetoothctl agent on
    echo "3/3 - Scanning devices"
    bluetoothctl scan on
    echo "To connect to any device, run:"
    echo "  bluetooth-connect [ MAC ]"
}

bluetooth-connect() {
    echo "1/2 - Pairing"
    bluetoothctl pair $1
    echo "2/2 - Connecting"
    bluetoothctl connect $1
}

#############
####### Sound
#############

for_all_sinks() {
    for SINK in $(pacmd list-sinks | grep 'index:' | cut -b12-); do
        /usr/bin/pactl "$1" $SINK "$2"
    done
}

all_change_volume() {
    for_all_sinks "set-sink-volume" "$1"
    [[ $1 == "+"* ]] && all_mute 0
    local vols=$(pacmd list-sinks | awk '/^\svolume:/ {printf $5 " "}')
    notify-send -u low "Volumes $vols" -h string:private-synchronous:light_sound
}

all_are_muted() {
    pacmd list-sinks | grep "muted: no" >/dev/null # 1 means muted: yes
    return $(( 1 - $? )) # 0 means muted: yes -> returns 1 when true
}

all_mute() {
    # Default: $1 OR if any are unmuted, then mute all
    all_are_muted
    local now_set_all=${1:-$?} # 1 means now mute
    for_all_sinks "set-sink-mute" $now_set_all

    [[ $now_set_all == 1 ]] && local noti="Sound muted" || local noti="Sound unmuted"
    [ -z "$1" ] && notify-send -u low "$noti" -h string:private-synchronous:light_sound
    return $now_set_all
}

play_warn_sound() {
    if all_are_muted; then
        all_mute 0
        mpv ~/.low_bat.mp3
        all_mute 1
    else
        mpv ~/.low_bat.mp3
    fi
}

##############
### Brightness
##############

brightness_get() {
    local value=$(light)
    echo ${value%.*}
}

brightness_notify() {
    notify-send -u low "Brightness: $(light)" -h string:private-synchronous:light_sound
}

brightness_up() {
    value=$(brightness_get)
    if (( value == 0 )); then
        light -S 1
    elif (( value < 10 )); then
        light -A 1
    else
        light -A 10
    fi
    brightness_notify
}

brightness_down() {
    value=$(brightness_get)
    if (( value <= 1 )); then
        light -S 0.5
    elif (( value <= 10 )); then
        light -U 1
    else
        light -U 10
    fi
    brightness_notify
}

