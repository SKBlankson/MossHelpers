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
███████╗     ██████╗ ██████╗ ██╗     ██╗     ███████╗ ██████╗████████╗
██╔════╝    ██╔════╝██╔═══██╗██║     ██║     ██╔════╝██╔════╝╚══██╔══╝
█████╗█████╗██║     ██║   ██║██║     ██║     █████╗  ██║        ██║   
██╔══╝╚════╝██║     ██║   ██║██║     ██║     ██╔══╝  ██║        ██║   
██║         ╚██████╗╚██████╔╝███████╗███████╗███████╗╚██████╗   ██║   
╚═╝          ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝ ╚═════╝   ╚═╝   
                                                                      
Collect files of a Given file type into a folder [v 1.1]
#B22
                                      
${NC}"
echo -e "${CYAN}-------------------------------------------------${NC}"
sleep 2  # Add a 2-second delay


# Check if there are at least two arguments (for the option and the file types)
if [ $# -lt 2 ]; then
    echo -e "${RED}Usage: $0 -f <extension1> <extension2> ...${NC}"
    exit 1
fi

# Parse the extensions passed as arguments
EXTENSIONS=()
while [ $# -gt 0 ]; do
    case "$1" in
        -f)
            shift
            while [ $# -gt 0 ] && [[ "$1" != -* ]]; do
                EXTENSIONS+=("$1")
                shift
            done
            ;;
        *)
            echo -e "${RED}Invalid option or argument: $1${NC}"
            exit 1
            ;;
    esac
done

# Relative directory for collected files
COLLECTED_DIR="./collected_files"

# Clean or create the collected files directory
rm -rf "$COLLECTED_DIR"
mkdir -p "$COLLECTED_DIR"

# Count the number of directories (student folders) in the root directory
student_count=$(find . -mindepth 1 -maxdepth 1 -type d | wc -l)

# Report the number of student directories found
echo -e "${BLUE}Found ${student_count} student folder(s) in the directory.${NC}"

# Loop through each student folder in the root directory
for student_folder in */; do
    # Check if it's a directory (skip if it's not)
    if [ -d "$student_folder" ]; then
        # Get the student's name (or folder name) to create a subdirectory in collected_files
        student_name=$(basename "$student_folder")
        student_collected_dir="$COLLECTED_DIR/$student_name"

        # Create a subdirectory for the student inside collected_files
        mkdir -p "$student_collected_dir"

        # Collect specified files for this student
        for ext in "${EXTENSIONS[@]}"; do
            echo -e "${CYAN}Collecting ${ext} files for ${student_name}...${NC}"
            find "$student_folder" -type f -name "*$ext" -exec cp {} "$student_collected_dir" \;
        done
    fi
done

# Final report: Number of folders collected
collected_count=$(find "$COLLECTED_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l)
echo -e "${BLUE}Collected ${collected_count} student folder(s) into $COLLECTED_DIR.${NC}"

# Check the contents of the collected directory
echo -e "${CYAN}Contents of $COLLECTED_DIR:${NC}"
ls -R "$COLLECTED_DIR"  # List files to ensure collection
echo -e "${CYAN}-------------------------------------------------${NC}"
echo -e "${GREEN}File Collection Complete:"
# Report the number of student folders initially discovered
initial_folders=$(find . -mindepth 1 -maxdepth 1 -type d | wc -l)
echo -e "${BLUE}Number of folders initially discovered: $initial_folders${NC}"

# Report the number of student folders collected
collected_folders=$(find "$COLLECTED_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l)
echo -e "${BLUE}Number of folders collected: $collected_folders${NC}"



# Clean up (optional: remove collected files after submission)
# rm -rf "$COLLECTED_DIR"
