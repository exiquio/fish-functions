function make-appimage --argument file name
    # Require both arguments to prevent silent failures
    if test -z "$file"; or test -z "$name"
        echo "Error: Missing arguments."
        echo "Usage: make-appimage <path-to-appimage> \"<App Name>\""
        return 1
    end

    # Define and guarantee target directories exist
    set target_dir "$HOME/AppImages"
    set applications_dir "$HOME/.local/share/applications"
    set icons_dir "$HOME/.local/share/icons"

    mkdir -p "$target_dir"
    mkdir -p "$applications_dir"
    mkdir -p "$icons_dir"

    # Create a clean slug for the filename (e.g., "Capacities App" -> "capacities-app")
    set slug (string lower "$name" | string replace -a ' ' '-')
    set dest "$target_dir/$slug.AppImage"

    # Move the file and make executable
    mv "$file" "$dest"
    chmod +x "$dest"

    # Extract the built-in icon from the AppImage
    echo "Extracting icon..."
    set temp_dir (mktemp -d)
    pushd "$temp_dir" >/dev/null

    # Executing with this flag dumps the contents into a local 'squashfs-root' directory
    "$dest" --appimage-extract >/dev/null

    set icon_path "$icons_dir/$slug.png"
    if test -e "squashfs-root/.DirIcon"
        # The -L flag resolves the symlink and copies the actual underlying image file
        cp -L "squashfs-root/.DirIcon" "$icon_path"
    else
        echo "Warning: No standard .DirIcon found inside the AppImage."
        set icon_path "" # Leave blank if extraction fails so the .desktop file doesn't break
    end

    # Clean up the extraction workspace
    popd >/dev/null
    rm -rf "$temp_dir"

    # Build the XDG Desktop Entry
    set desktop_file "$applications_dir/$slug.desktop"
    echo "[Desktop Entry]
Type=Application
Name=$name
Exec=$dest
Icon=$icon_path
Terminal=false
Categories=Utility;" >"$desktop_file"

    # Force the desktop environment to refresh its application menu immediately
    update-desktop-database "$applications_dir" 2>/dev/null

    echo "Success! $name is now registered in your application menu."
    echo "Moved to: $dest"
    if test -n "$icon_path"
        echo "Icon saved: $icon_path"
    end
end
