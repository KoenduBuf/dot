#!/bin/bash

case "$1" in
    "lite") INSTALL=1 ;;
    "base") INSTALL=2 ;;
    "desk") INSTALL=3 ;;
    * ) INSTALL=0 ;;
esac

if [ ! $INSTALL -ge 1 ]; then
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


# Remember where the scripts are, and make them executable
export KDOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "Installing 'dot'. Files based in '$KDOT_DIR'"
chmod +x $KDOT_DIR/*


# Add sourcing the '.dotrc' to both bashrc and zshrc
SOURCELINE="[ -f \"\$HOME/.dotrc\" ] && . \"\$HOME/.dotrc\""
if [ -f "$HOME/.bashrc" ]; then
    if ! grep -Fxq "$SOURCELINE" "$HOME/.bashrc"; then
        echo "$SOURCELINE" >> "$HOME/.bashrc"
    fi
fi
if [ -f "$HOME/.zshrc" ]; then
    if ! grep -Fxq "$SOURCELINE" "$HOME/.zshrc"; then
        echo "$SOURCELINE" >> "$HOME/.zshrc"
    fi
fi


# For each install, add the required data to .dotrc
if [ $INSTALL -ge 1 ]; then
    echo "# Install '$1' of kdot files:" > "$HOME/.dotrc"
    echo "export KDOT_DIR=\"$KDOT_DIR\"" >> "$HOME/.dotrc"
    echo ". '$KDOT_DIR/dot-scripts/functions-lite.sh'" >> "$HOME/.dotrc"
fi

if [ $INSTALL -ge 2 ]; then
    echo ". '$KDOT_DIR/dot-scripts/functions-base.sh'" >> "$HOME/.dotrc"
fi

if [ $INSTALL -ge 3 ]; then
    echo ". '$KDOT_DIR/dot-scripts/functions-desk.sh'" >> "$HOME/.dotrc"
fi







