function set-workspaces --description 'Set GNOME workspace names'
    # Check if arguments were provided
    if test (count $argv) -eq 0
        echo "Usage: set_workspaces <name1> <name2> ... <nameN>"
        return 1
    end

    # Format arguments into a Python-style list string for gsettings
    # Example: '["Web", "Organize", "Research"]'
    set -l formatted_names "['" (string join "', '" $argv) "']"
    
    # Apply the setting
    gsettings set org.gnome.desktop.wm.preferences workspace-names "$formatted_names"
    
    echo "Workspaces updated to: $argv"
end
