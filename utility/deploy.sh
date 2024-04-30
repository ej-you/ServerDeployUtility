#!/bin/bash

# basedir for all project
basedir=$(dirname "$(dirname "$(realpath "$0")")")

if [ ! -f "$basedir/utility/config" ]; then
    echo 'project_dir=""' > "$basedir/utility/config"
fi
# load config's variables
source "$basedir/utility/config"

# colored output formats
red_text="\033[31m"
yellow_text="\033[33m"
green_text="\033[32m"
default_text="\033[0m"


function print_doc_usage {
    # print usage of utility
    printf "Usage:  deploy [ run [custom_script] [-v | --verbose] ] | [status] | [logs] | [set-config] | [add] | [-h | --help]\n"
}
function print_doc {
    # print all documentations of utility
    print_doc_usage

    echo -e "\nOptions and Arguments:\n"
    printf "\t%-25s %-15s\n" "run custom_script" "Run your custom script from \"custom_scripts\" subdir."
    printf "\t%-25s %-15s\n" "run" "default script using your configurated project dir."
    printf "\t%-25s %-15s\n" "-v, --verbose" "Show detailed output for command \"run\""
    printf "\t%-25s %-15s\n" "status" "Show detailed status of \"deploy utility\""
    printf "\t%-25s %-15s\n" "add" "Add custom script using utility's interactive mode"
    printf "\t%-25s %-15s\n" "set-config" "Configure project dir for run default script using utility's interactive mode."
    printf "\t%-25s %-15s\n" "-h, --help" "Show this message"

    echo -e "\nExamples:\n"
    printf "\t%-25s %-15s\n" "deploy run -v" "Run default script using detailed output."
    printf "\t%-25s %-15s\n" "deploy run project" "Run script \"project.sh\" from \"custom_scripts\" subdir."
    printf "\t%-25s %-15s\n" "deploy status" "Show detailed status of \"deploy utility\"."
    printf "\t%-25s %-15s\n" "deploy set-config" "Start interactive mode for configure project dir."
    printf "\t%-25s %-15s\n" "deploy add" "Start interactive mode for adding custom script."

    echo -e "\nDescription:\n"
    printf "\t%-20s \n" "To use \"deploy utility\" you need to configured project dir. Use \"deploy set-config\"."
    printf "\t%-20s \n" "Project dir is directory from which \"deploy utility\" will start all deploy scripts"
    printf "\t%-20s \n" "If you want to add new custom script use \"deploy add\"."
    printf "\t%-20s \n" "If actions from custom script must execute in the directory other than project dir, use \"cd\" instruction in your custom script"
    printf "\t%-20s \n" "All important paths and variables you can see using \"deploy status\""
    exit 0
}

function unexpected_arg_error() {
    # handle given unexpected argument
    echo -e "${red_text}ERROR: unexpected argument \"$1\"${default_text}"
    # print usage of utility
    print_doc_usage
    exit 1
}
function bad_command_error() {
    # handle invalid using flag without using command
    echo -e "${red_text}ERROR: command was not specified${default_text}"
    # print usage of utility
    print_doc_usage
    exit 1
}


function handle_command_run() {
    # run script to re-deploy project
    echo -e "Use detailed output: ${yellow_text}$command_verbose${default_text}"

    # run default script
    if [ -z "$script_to_run" ]; then
        echo -e "${yellow_text}Running default script...${default_text}\n"

        # if project_dir is configured then move into it
        if [ -n "$project_dir" ]; then
            cd "$project_dir" || { echo -e "${red_text}ERROR: \"cd\" to configured project dir was failed${default_text}"; exit 1; }
        fi

        # if verbose flag was specified, use detailed output, else run script without output
        if [ "$command_verbose" = "true" ]; then
            "$basedir/utility/default_script.sh"
        else
            "$basedir/utility/default_script.sh" &> /dev/null
        fi

        # command exit status
        command_status=$?
        if [ "$command_status" != "0" ]; then
            echo -e "[$(date +"%d/%b/%Y %H:%M:%S")] (Failed) run default script in project dir \"$project_dir\"" >> "$basedir"/logs/all-deploy.log
            exit 1
        else
            echo -e "[$(date +"%d/%b/%Y %H:%M:%S")] (Successfully) run default script in project dir \"$project_dir\"" >> "$basedir"/logs/all-deploy.log
            exit 0
        fi

    # run custom script
    else
        echo -e "${yellow_text}Running custom script \"$script_to_run\"...${default_text}\n"

        # if project_dir is configured then move into it
        if [ -n "$project_dir" ]; then
            cd "$project_dir" || { echo -e "${red_text}ERROR: \"cd\" to configured project dir was failed${default_text}"; exit 1; }
        fi

        # check custom script file is existing
        if [ ! -f "$basedir/custom_scripts/$script_to_run.sh" ]; then
            echo -e "${red_text}ERROR: invalid custom script was specified${default_text}"
            exit 1
        fi

        # if verbose flag was specified, use detailed output, else run script without output
        if [ "$command_verbose" = "true" ]; then
            "$basedir/custom_scripts/$script_to_run.sh"
        else
            "$basedir/custom_scripts/$script_to_run.sh" &> /dev/null
        fi

        # command exit status
        command_status=$?
        if [ "$command_status" != "0" ]; then
            echo -e "[$(date +"%d/%b/%Y %H:%M:%S")] (Failed) run custom script \"$script_to_run\" in project dir \"$project_dir\"" >> "$basedir"/logs/all-deploy.log
            exit 1
        else
            echo -e "[$(date +"%d/%b/%Y %H:%M:%S")] (Successfully) run custom script \"$script_to_run\" in project dir \"$project_dir\"" >> "$basedir"/logs/all-deploy.log
            exit 0
        fi
    fi
}

function handle_command_logs() {
    # print all logs of "deploy utility"
    cat "$basedir"/logs/all-deploy.log
    exit 0
}

function handle_command_status() {

    echo -e "${yellow_text}Project dir for deploy scripts:${default_text}"
    printf "\t"
    cat "$basedir"/utility/config

    echo -e "${yellow_text}Custom scripts list:${default_text}"
    scripts_list=( $(ls -A "$basedir"/custom_scripts) )
    for arr_index in ${!scripts_list[*]}
    do
        printf "\t%s\n" "${scripts_list["$arr_index"]}"
    done
    echo

    echo -e "${yellow_text}Dir contains \"deploy utility\" runner:${default_text}"
    printf "\t"
    echo "$basedir"/utility

    echo -e "${yellow_text}Dir contains custom scripts:${default_text}"
    printf "\t"
    echo -e "$basedir/custom_scripts"

    echo -e "\n${yellow_text}Default script file:${default_text}"
    printf "\t"
    echo "$basedir"/utility/default_script.sh

    echo -e "${yellow_text}Log file:${default_text}"
    printf "\t"
    echo "$basedir"/logs/all-deploy.log

    echo -e "${yellow_text}\"Deploy utility\" manager:${default_text}"
    printf "\t"
    echo "$basedir"/manager.sh

    exit 0
}

function handle_command_set_config() {
    echo "Set project dir for default deploy script..."
    read -p "Enter full path to your project: " -r full_path_to_project

	  if [ ! -d "$full_path_to_project" ]; then
	      echo -e "${red_text}ERROR: invalid path to project dir!${default_text}"
	      exit 1
	  fi

    echo "project_dir=\"$full_path_to_project\"" > "$basedir"/utility/config

    # command exit status
    command_status=$?
    # something wrong
    if [ "$command_status" != '0' ]; then
        echo -e "${red_text}Something went wrong!!! Please, check your project dir \"$full_path_to_project\"${default_text}"
        exit 1
    # alright
    else
        echo -e "${green_text}Successfully configured default project dir!${default_text}"
        exit 0
    fi
}

function handle_command_add() {
    echo "Adding new custom script..."
    read -p "Enter path to your script file: " -r path_to_new_custom_command

    if [ ! -f "$path_to_new_custom_command" ]; then
	      echo -e "${red_text}ERROR: invalid path to file!${default_text}"
	      exit 1
	  fi

    cp "$path_to_new_custom_command" "$basedir"/custom_scripts/"$(basename "$path_to_new_custom_command")"
    chmod +x "$basedir"/custom_scripts/"$(basename "$path_to_new_custom_command")"

    # command exit status
    command_status=$?
    # something wrong
    if [ "$command_status" != '0' ]; then
        echo -e "${red_text}Something went wrong!!! Please, check your file \"$path_to_new_custom_command\"${default_text}"
        exit 1
    # alright
    else
        echo -e "${green_text}Successfully added new custom script!${default_text}"
        exit 0
    fi
}

# print instruction if run script without argument
if [ -z "$1" ]; then
    print_doc
fi

command_verbose="false"
command_run="false"
script_to_run=""

while [ -n "$1" ]
do
    case "$1" in
        status) handle_command_status;;
        logs) handle_command_logs;;
        set-config) handle_command_set_config;;
        add) handle_command_add;;
        -h | --help) print_doc;;
        -v | --verbose) command_verbose="true";;
        run) command_run="true";;
        *) unexpected_arg_error "$@";;
    esac

    if [ "$1" = "run" ] && [ "$2" != "-v" ] && [ "$2" != "--verbose" ]; then
        shift
        script_to_run="$1"
    fi
    shift
done

if [ "$command_run" = "true" ]; then
    handle_command_run script_to_run command_verbose
else
    bad_command_error
fi
