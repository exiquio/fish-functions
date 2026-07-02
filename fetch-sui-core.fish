function fetch-sui-core
    set output_file "sui-core-framework.md"
    
    # Base URLs for raw file downloads
    set sui_base "https://raw.githubusercontent.com/MystenLabs/sui/main/crates/sui-framework/packages/sui-framework/sources"
    set stdlib_base "https://raw.githubusercontent.com/MystenLabs/sui/main/crates/sui-framework/packages/move-stdlib/sources"

    # Define the target files
    set sui_files object.move transfer.move coin.move balance.move tx_context.move
    set stdlib_files vector.move option.move

    echo "Building $output_file for NotebookLM..."
    echo "# Sui Core Framework & Standard Library" > $output_file

    # Process Sui Framework files
    for file in $sui_files
        echo "Fetching $file..."
        # Use printf for clean cross-platform newline injection
        printf "\n\n## Source: sui-framework/%s\n\n" $file >> $output_file
        echo '```move' >> $output_file
        curl -sL "$sui_base/$file" >> $output_file
        printf "\n```\n" >> $output_file
    end

    # Process Standard Library files
    for file in $stdlib_files
        echo "Fetching $file..."
        printf "\n\n## Source: move-stdlib/%s\n\n" $file >> $output_file
        echo '```move' >> $output_file
        curl -sL "$stdlib_base/$file" >> $output_file
        printf "\n```\n" >> $output_file
    end

    echo "Success: Compiled $output_file. Ready for upload."
end
