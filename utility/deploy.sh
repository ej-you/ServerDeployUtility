function print_doc {
    echo -e "Usage:  deploy [-h | --help] [-v | --verbose] [custom_script]\n"
    printf "\t%-20s %-15s\n" "without options" "Run default script using your config."
    printf "\t%-20s %-15s\n" "[custom_script]" "Run your custom script from \"custom_scripts\" subdir."
    printf "\t%-20s %-15s\n" "-v, --verbose" "Show detailed output while re-deploy"
    printf "\t%-20s %-15s\n" "-h, --help" "Show this message"
    echo -e "\nExamples:\n"
    printf "\t%-20s %-15s\n" "deploy -v" "Run default script using detailed output."
    printf "\t%-20s %-15s\n" "deploy project" "Run script \"project.sh\" from \"custom_scripts\" subdir."
    echo -e "\nDescription:\n"
    exit 0
}
