function print_doc {
    echo -e "Usage:  bash ./manager.sh [command]\n"
    printf "\t%-20s %-15s\n" "install" "Start installation \"deploy utility\" on your system."
    printf "\t%-20s %-15s\n" "uninstall" "Uninstall \"deploy utility\"."
    printf "\t%-20s %-15s\n" "status" "Show detailed status of \"deploy utility\"."
    echo -e "\nDescription:\n"
    exit 0
}
