function sys-update --description 'Update system packages (DNF) and Flatpaks'
    echo "========================================"
    echo "      Starting System Updates"
    echo "========================================"

    # 1. System Upgrade
    echo ""
    echo "--> Checking for DNF (system) updates..."
    sudo dnf upgrade --refresh -y

    if test $status -eq 0
        echo "✔ DNF updates completed successfully."
    else
        echo "❌ Something went wrong with DNF updates."
        return 1
    end

    # 2. Flatpak Upgrade
    echo ""
    echo "--> Checking for Flatpak updates..."
    flatpak update -y --noninteractive

    if test $status -eq 0
        echo "✔ Flatpak updates completed successfully."
    else
        echo "❌ Something went wrong with Flatpak updates."
        return 1
    end

    # 3. Flatpak Cleanup
    echo ""
    echo "--> Cleaning up unused Flatpak dependencies..."
    flatpak uninstall --unused -y

    echo ""
    echo "========================================"
    echo "      All updates finished!"
    echo "========================================"
end
