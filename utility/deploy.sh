basedir=$(dirname "$(realpath "$0")")

red_text="\033[31m"
yellow_text="\033[33m"
green_text="\033[32m"
default_text="\033[0m"


function print_doc_usage {
    printf "Usage:  deploy [ run [custom_script] [-v | --verbose] ] | [status] | [set-config] | [add] | [-h | --help]\n"
}
function print_doc {
    print_doc_usage

    echo -e "\nOptions and Arguments:\n"
    printf "\t%-25s %-15s\n" "run custom_script" "Run your custom script from \"custom_scripts\" subdir."
    printf "\t%-25s %-15s\n" "run" "default script using your configurated project dir."
    printf "\t%-25s %-15s\n" "-v, --verbose" "Show detailed output while re-deploy"
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

    exit 0
}

function unexpected_arg_error() {
    echo -e "${red_text}ERROR: unexpected argument \"$1\"${default_text}"
    print_doc_usage
    exit 1
}
function bad_command_error() {
    echo -e "${red_text}ERROR: not used command${default_text}"
    print_doc_usage
    exit 1
}


function handle_command_run() {
    echo -e "\nAAAAAAAAAA\n"
    echo "command_verbose=$command_verbose"
    echo "script_to_run=$script_to_run"

    exit 0
}

function handle_command_status() {
    echo "status"

    exit 0
}

function handle_command_set_config() {
    echo "set-config"

    exit 0
}

function handle_command_add() {
    echo "add"

    exit 0
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
