#!/bin/bash
#
# DIGRESS Shell Functions
# Source this in your .zshrc or .bashrc:
#   source ~/.digress-functions.sh
#

# Quick fork - opens new window with forked session
fork() {
    local label="${1:-tangent}"
    local dir="${2:-$(pwd)}"
    digress "$label" --dir "$dir"
}

# Alias
alias digress-here='digress'

# Fork from a specific named session
fork_from() {
    local parent="$1"
    local label="${2:-tangent}"

    if [[ -z "$parent" ]]; then
        echo "Usage: fork_from <parent-session-name> [new-label]"
        return 1
    fi

    osascript <<EOF
tell application "iTerm2"
    create window with default profile
    tell current session of current window
        set name to "🐟 ${label}"
        write text "cd '$(pwd)' && claude --resume '${parent}' --fork-session"
    end tell
end tell
EOF
    echo "🌊 Forked from '${parent}' to '${label}'"
}

# Resume a session by name
back() {
    local session="$1"
    if [[ -z "$session" ]]; then
        echo "Usage: back <session-name>"
        echo "Or run 'claude --resume' for interactive picker"
        return 1
    fi
    claude --resume "$session"
}

# Show the tree
alias digress-tree='digress --tree'
