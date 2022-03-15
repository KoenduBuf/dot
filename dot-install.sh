#!/bin/bash


if [ -z "$1" ]; then
    echo "Please select what you want to install:"
    echo ""
    echo "lite - Installs some stuff that is useful all the time when in"
    echo "       the terminal, like 'll', 'del', 'extract' and more"
    echo ""
    echo "base - Installs 'lite' and adds specific commands for if you"
    echo "       are me, like some ssh stuff and 'dot-notify'"
    echo ""
    echo "desk - Installs 'lite', 'base' and adds things for if this is a"
    echo "       pc with a desktop. Includes notifications, brightness and"
    echo "       sound controls, 'screenshot', 'xclip' and more"
    echo ""
    echo "Use: '$0 [ install mode ]'"
    exit 1
fi

add_to_rc() {
    if [ -f "$HOME/.bashrc" ]; then
        if ! grep -Fxq "$1" "$HOME/.bashrc"; then
            echo "$1" >> "$HOME/.bashrc"
        fi
    fi
    if [ -f "$HOME/.zshrc" ]; then
        if ! grep -Fxq "$1" "$HOME/.zshrc"; then
            echo "$1" >> "$HOME/.zshrc"
        fi
    fi
}

export KDOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "Installing 'dot'. Files based in '$KDOT_DIR'"
chmod +x $KDOT_DIR/*

if [ "$1" == "lite" ] || [ "$1" == "base" ] || [ "$1" == "desk" ]; then
    add_to_rc "# Install '$1' of kdot files:"
    add_to_rc "export KDOT_DIR=\"$KDOT_DIR\""
    add_to_rc ". '$KDOT_DIR/dot-scripts/functions-lite.sh'"
fi

if [ "$1" == "base" ] || [ "$1" == "desk" ]; then
    add_to_rc ". '$KDOT_DIR/dot-scripts/functions-base.sh'"
fi

if [ "$1" == "desk" ]; then
    add_to_rc ". '$KDOT_DIR/dot-scripts/functions-desk.sh'"
fi







