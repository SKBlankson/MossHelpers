#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'  # No color

# Directory containing the zip files
ZIP_DIR="./"

# Count the number of .zip files in the directory
zip_count=$(find "$ZIP_DIR" -maxdepth 1 -name "*.zip" | wc -l)

# Report the number of zip files found
echo -e "${CYAN}-------------------------------------------------${NC}"
echo -e "${CYAN}
██████╗ ███████╗   ███████╗██╗██████╗ 
██╔══██╗██╔════╝   ╚══███╔╝██║██╔══██╗
██║  ██║█████╗█████╗ ███╔╝ ██║██████╔╝
██║  ██║██╔══╝╚════╝███╔╝  ██║██╔═══╝ 
██████╔╝███████╗   ███████╗██║██║     
╚═════╝ ╚══════╝   ╚══════╝╚═╝╚═╝
Unzip and Re-name files easily [v 1.1]
#B22
${NC}"
echo -e "${CYAN}-------------------------------------------------${NC}"
echo -e "${BLUE}Found ${zip_count} zip file(s) in the directory.${NC}"
sleep 2  # Add a 2-second delay

# Exit if no zip files are found
if [ "$zip_count" -eq 0 ]; then
    echo -e "${YELLOW}No zip files to process. Exiting.${NC}"
    exit 0
fi

# Counter for successfully unzipped and renamed folders
unzipped_count=0

# Iterate over all .zip files in the directory
for zip_file in "$ZIP_DIR"/*.zip; do
    # Get the base name of the zip file (e.g., hw from hw.zip)
    base_name=$(basename "$zip_file" .zip)

    echo -e "${CYAN}-------------------------------------------------${NC}"
    echo -e "${BLUE}Processing: $zip_file${NC}"

    # Check for read and write permissions before trying to unzip
    if [ ! -r "$zip_file" ] || [ ! -w "$ZIP_DIR" ]; then
        echo -e "${RED}Permission denied for $zip_file. Attempting to fix...${NC}"
        chmod 777 "$zip_file"  # Grant full access to the zip file itself
        chmod -R 777 "$ZIP_DIR"  # Grant full access to the whole directory (non-recursive restrictions)
        if [ $? -ne 0 ]; then
            echo -e "${RED}Error: Failed to change permissions for files in $ZIP_DIR. Skipping.${NC}"
            continue
        fi
        echo -e "${GREEN}Permissions updated to full (777) for the zip file and all files in $ZIP_DIR. Retrying...${NC}"
    fi

    # Unzip the file to a temporary directory
    unzip -q "$zip_file" -d "$base_name-temp"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Failed to unzip $zip_file. Skipping.${NC}"
        rm -rf "$base_name-temp"  # Clean up temporary directory if created
        continue
    fi

    # Apply full permissions to the extracted content (set 777 for all files/folders)
    chmod 777 "$base_name-temp"/*  # Ensure full access to all extracted files
    chmod 777 "$base_name-temp"    # Apply full access on the directory itself

    # Handle extracted contents
    extracted=$(find "$base_name-temp" -mindepth 1 -maxdepth 1)

    if [ -z "$extracted" ]; then
        echo -e "${YELLOW}Warning: No files or directories found in $zip_file. Skipping.${NC}"
        rm -rf "$base_name-temp"
        continue
    fi

    # If there are multiple items found in the temporary folder, handle them
    if [ $(echo "$extracted" | wc -l) -gt 1 ]; then
        # Create the new base directory
        mkdir "$base_name"
        chmod 777 "$base_name"  # Ensure full permissions for the new folder
        # Move all extracted items into the new directory
        for item in $extracted; do
            mv "$item" "$base_name/"
        done
        chmod -R 777 "$base_name"  # Ensure full permissions for the moved files
        echo -e "${GREEN}Multiple items found in $zip_file. Consolidated into $base_name.${NC}"
    else
        # Handle the case where there's only one item (file or folder)
        extracted_item=$(echo "$extracted" | head -n 1)
        if [ -d "$extracted_item" ]; then
            mv "$extracted_item" "$base_name"
        else
            mkdir "$base_name"
            mv "$extracted_item" "$base_name/"
        fi
        chmod -R 777 "$base_name"  # Ensure full permissions for the moved files
        echo -e "${GREEN}Unzipped and renamed to $base_name. Permissions set to 777.${NC}"
    fi

    # Clean up the temporary folder
    chmod -R 777 "$base_name-temp"  # Ensure permissions are adequate for cleanup
    rm -rf "$base_name-temp"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Failed to delete temporary folder $base_name-temp.${NC}"
    fi

    # Delete the original zip file if unzipping and renaming succeeded
    if [ -d "$base_name" ]; then
        rm -f "$zip_file"
        echo -e "${GREEN}Deleted original zip file: $zip_file${NC}"
        ((unzipped_count++))
    else
        echo -e "${YELLOW}Skipping deletion of $zip_file due to errors.${NC}"
    fi
done

# Final report
echo -e "${CYAN}-------------------------------------------------${NC}"
echo -e "${BLUE}All zip files processed.${NC}"
echo -e "${GREEN}$unzipped_count folder(s) successfully unzipped and renamed.${NC}"
echo -e "${CYAN}-------------------------------------------------${NC}"
