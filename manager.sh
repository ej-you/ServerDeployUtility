#!/bin/bash

basedir=$(dirname "$(realpath "$0")")


red_text="\033[31m"
yellow_text="\033[33m"
green_text="\033[32m"
default_text="\033[0m"


function print_doc() {
    echo -e "Usage:  bash ./manager.sh [command]\n"
    printf "\t%-20s %-15s\n" "install" "Start installation \"deploy utility\" on your system."
    printf "\t%-20s %-15s\n" "uninstall" "Uninstall \"deploy utility\"."
    printf "\t%-20s %-15s\n" "status" "Show status of \"deploy utility\"."
    echo -e "\nDescription:\n"
    printf "\t%-20s \n" "You can make this file executable and use it like \"./manager.sh\"."
    printf "\t%-20s \n" "To use \"deploy utility\" you need to install it with the command \"./manager.sh install\"."
    printf "\t%-20s \n" "To uninstall \"deploy utility\" use the command \"./manager.sh install\"."
    printf "\t%-20s \n" "To see if the \"deploy utility\" is installed, use \"./manager.sh status\"."
    exit 0
}

function unexpected_arg_error() {
    echo -e "${red_text}ERROR: unexpected argument \"$1\"${default_text}"
    echo -e "${yellow_text}HINT: use \"bash ./manager.sh\" for read help manual"
    exit 1
}

function install() {
    # check bashrc if ServerDeployUtility already installed
    bashrc_alias="$(grep --max-count=1 --only-matching ^'# >>> ServerDeployUtility from Ej_you >>>' ~/.bashrc)"
    if [ -n "$bashrc_alias" ]; then
        echo -e "${yellow_text}ServerDeployUtility already installed${default_text}"
        exit 0
    fi

    echo "Start installation..."
    # make main script executable
    chmod +x "$basedir"/utility/deploy.sh
    chmod +x "$basedir"/utility/default_script.sh
    chmod +x "$basedir"/custom_scripts/test.sh
    # add alias "deploy" for script file "./utility/deploy.sh" into ~/.bashrc
    {
        echo -e "\n# >>> ServerDeployUtility from Ej_you >>>"
        echo "alias deploy=\"$basedir/utility/deploy.sh\""
        echo "# <<< ServerDeployUtility <<<"
    } >> ~/.bashrc

    if [ ! -f "$basedir/utility/config" ]; then
        echo 'project_dir=""' > "$basedir/utility/config"
    fi

    # command exit status
    command_status=$?
    if [ "$command_status" != '0' ]; then
        echo -e "${red_text}Something went wrong!!! Please, check your file \"~/.bashrc\"${default_text}"
        exit 1
    else
        echo -e "${green_text}ServerDeployUtility installed successfully!${default_text}"
    fi
}

function uninstall() {
    # find strings with alias "deploy" in ~/.bashrc
    str_start_del="$(grep --line-number --max-count=1 --only-matching ^'# >>> ServerDeployUtility from Ej_you >>>' ~/.bashrc | sed -e s/:.*//)"
    str_end_del=$((str_start_del+2))

    if [ -n "$str_start_del" ]; then
        echo "Uninstalling ServerDeployUtility..."
        # remove alias "deploy" from ~/.bashrc
        sed -i "$str_start_del,${str_end_del}d" ~/.bashrc
    else
        echo -e "${yellow_text}ServerDeployUtility not installed${default_text}"
        exit 0
    fi

    # command exit status
    command_status=$?
    # something wrong
    if [ "$command_status" != '0' ]; then
        echo -e "${red_text}Something went wrong!!! Please, check your file \"~/.bashrc\"${default_text}"
        exit 1
    # alright
    else
        echo -e "${green_text}ServerDeployUtility uninstalled successfully!${default_text}"
    fi
}

function status() {
    bashrc_alias="$(grep --max-count=1 --only-matching ^'# >>> ServerDeployUtility from Ej_you >>>' ~/.bashrc)"

    if [ -n "$bashrc_alias" ]; then
        echo -e "ServerDeployUtility status: ${green_text}installed${default_text}"
    else
        echo -e "ServerDeployUtility status: ${yellow_text}not installed${default_text}"
    fi
}


# print instruction if run script without argument
if [ -z "$1" ]; then
    print_doc
fi

# select manager's mode
case "$1" in
    install) install;;
    uninstall) uninstall;;
    status) status;;
    *) unexpected_arg_error "$@";;
esac
