function make-appimage --argument file name
    # 1. Require both arguments to prevent silent failures
    if test -z "$file"; or test -z "$name"
        echo "Error: Missing arguments."
        echo "Usage: make-appimage <path-to-appimage> \"<App Name>\""
        return 1
    end

    # 2. Define and guarantee target directories exist
    set target_dir "$HOME/AppImages"
    set applications_dir "$HOME/.local/share/applications"

    mkdir -p "$target_dir"
    mkdir -p "$applications_dir"

    # 3. Create a clean slug for the filename (e.g., "Capacities App" -> "capacities-app")
    set slug (string lower "$name" | string replace -a ' ' '-')
    set dest "$target_dir/$slug.AppImage"

    # 4. Move the file and make executable (Quotes prevent breakage on paths with spaces)
    mv "$file" "$dest"
    chmod +x "$dest"

    # 5. Build the XDG Desktop Entry
    set desktop_file "$applications_dir/$slug.desktop"
    echo "[Desktop Entry]
Type=Application
Name=$name
Exec=$dest
Terminal=false
Categories=Utility;" > "$desktop_file"

    # 6. Force the desktop environment to refresh its application menu immediately
    update-desktop-database "$applications_dir" 2>/dev/null

    echo "Success! $name is now registered in your application menu."
    echo "Moved to: $dest"
end
