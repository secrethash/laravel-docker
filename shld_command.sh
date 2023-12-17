#!/usr/bin/env bash

# Bash Functions
shld_beautify () {
    # Reset
    No_Color='\033[0m'       # Text Reset

    # Regular Colors
    Black='\033[0;30m'        # Black
    Red='\033[0;31m'          # Red
    Green='\033[0;32m'        # Green
    Yellow='\033[0;33m'       # Yellow
    Blue='\033[0;34m'         # Blue
    Purple='\033[0;35m'       # Purple
    Cyan='\033[0;36m'         # Cyan
    White='\033[0;37m'        # White

    # Bold
    BBlack='\033[1;30m'       # Black
    BRed='\033[1;31m'         # Red
    BGreen='\033[1;32m'       # Green
    BYellow='\033[1;33m'      # Yellow
    BBlue='\033[1;34m'        # Blue
    BPurple='\033[1;35m'      # Purple
    BCyan='\033[1;36m'        # Cyan
    BWhite='\033[1;37m'       # White

    # Underline
    UBlack='\033[4;30m'       # Black
    URed='\033[4;31m'         # Red
    UGreen='\033[4;32m'       # Green
    UYellow='\033[4;33m'      # Yellow
    UBlue='\033[4;34m'        # Blue
    UPurple='\033[4;35m'      # Purple
    UCyan='\033[4;36m'        # Cyan
    UWhite='\033[4;37m'       # White

    # Background
    On_Black='\033[40m'       # Black
    On_Red='\033[41m'         # Red
    On_Green='\033[42m'       # Green
    On_Yellow='\033[43m'      # Yellow
    On_Blue='\033[44m'        # Blue
    On_Purple='\033[45m'      # Purple
    On_Cyan='\033[46m'        # Cyan
    On_White='\033[47m'       # White

    # High Intensity
    IBlack='\033[0;90m'       # Black
    IRed='\033[0;91m'         # Red
    IGreen='\033[0;92m'       # Green
    IYellow='\033[0;93m'      # Yellow
    IBlue='\033[0;94m'        # Blue
    IPurple='\033[0;95m'      # Purple
    ICyan='\033[0;96m'        # Cyan
    IWhite='\033[0;97m'       # White

    # Bold High Intensity
    BIBlack='\033[1;90m'      # Black
    BIRed='\033[1;91m'        # Red
    BIGreen='\033[1;92m'      # Green
    BIYellow='\033[1;93m'     # Yellow
    BIBlue='\033[1;94m'       # Blue
    BIPurple='\033[1;95m'     # Purple
    BICyan='\033[1;96m'       # Cyan
    BIWhite='\033[1;97m'      # White

    # High Intensity backgrounds
    On_IBlack='\033[0;100m'   # Black
    On_IRed='\033[0;101m'     # Red
    On_IGreen='\033[0;102m'   # Green
    On_IYellow='\033[0;103m'  # Yellow
    On_IBlue='\033[0;104m'    # Blue
    On_IPurple='\033[0;105m'  # Purple
    On_ICyan='\033[0;106m'    # Cyan
    On_IWhite='\033[0;107m'   # White
}
shld_help_header () {
    echo " "
    echo -e "$BYellow HELP for Secrethash Laravel Docker $No_Color"
    echo -e "$Yellow Package: https://github.com/secrethash/Laravel-Docker $No_Color"
    echo " "
}
shld_service () {
    shld_beautify
    while test $# -gt 0; do
        case "$1" in
            -h|--help|help)
                shld_help_header
                echo -e "$On_Black$BGreen shld [options] [arguments] $No_Color"
                echo " "
                echo -e "$On_Black$BGreen shld [options] [?service=core] [arguments] $No_Color"
                echo " "
                echo -e "$On_Purple$BWhite (i) $No_Color$On_Black$BPurple The [service] defaults to core if not specified and supported arguments (listed below) are provided. $No_Color"
                echo " "
                echo -e "$On_White$BBlack EXAMPLE:          $No_Color"
                echo -e "$On_Black$BIGreen shld up --build           $No_Color"
                echo -e "$On_Black$BIGreen shld down                 $No_Color"
                echo -e "$On_Black$BIGreen shld artisan about        $No_Color"
                echo -e "$On_Black$BIGreen shld help                 $No_Color"
                echo " "
                echo -e "$On_White$BBlack Arguments:        $No_Color"
                echo -e "$On_Black$BIGreen artisan, php artisan     $No_Color$IWhite$On_Black Run php artisan commands in a container   $No_Color"
                echo -e "$On_Black$BIGreen tinker                   $No_Color$IWhite$On_Black Start a new tinker session                $No_Color"
                echo -e "$On_Black$BIGreen php                      $No_Color$IWhite$On_Black Run php commands in a container           $No_Color"
                echo -e "$On_Black$BIGreen composer                 $No_Color$IWhite$On_Black Run composer commands in a container      $No_Color"
                echo -e "$On_Black$BIGreen yarn                     $No_Color$IWhite$On_Black Run yarn commands in a container          $No_Color"
                echo -e "$On_Black$BIGreen npm                      $No_Color$IWhite$On_Black Run npm commands in a container           $No_Color"
                echo -e "$On_Black$BIGreen unit, phpunit            $No_Color$IWhite$On_Black Run phpunit tests in a container          $No_Color"
                echo -e "$On_Black$BIGreen pint                     $No_Color$IWhite$On_Black Run pint in a container                   $No_Color"
                echo -e "$On_Black$BIGreen git                      $No_Color$IWhite$On_Black Run git commands in a container           $No_Color"
                echo " "
                echo -e "$On_White$BBlack Options:          $No_Color"
                echo -e "$On_Black$BIGreen -h, --help               $No_Color$IWhite$On_Black shows this help page                      $No_Color"
                return
                ;;
            *)
            break
            ;;
        esac
    done
    if [[ "$1" == "up" || "$1" == "u" ]]; then
        BUILD=0
        RECREATE=0
        while test $# -gt 0; do
            case "$2" in
                -h|--help)
                    shld_help_header
                    echo -e "$On_Purple$BWhite (i) $No_Color$On_Black$BPurple Bring up the docker containers by running. $No_Color"
                    echo " "
                    echo -e "$On_Black$BGreen shld up [options]  $No_Color"
                    echo " "
                    echo -e "$On_White$BBlack EXAMPLE:          $No_Color"
                    echo -e "$On_Black$BIGreen shld up -b                $No_Color"
                    echo -e "$On_Black$BIGreen shld up -r                $No_Color"
                    echo -e "$On_Black$BIGreen shld up -h                $No_Color"
                    echo " "
                    echo -e "$On_White$BBlack Options:          $No_Color"
                    echo -e "$On_Black$BIGreen -h, --help               $No_Color$IWhite$On_Black shows this help page                                                      $No_Color"
                    echo -e "$On_Black$BIGreen -b, --build              $No_Color$IWhite$On_Black Build images before starting containers.                                  $No_Color"
                    echo -e "$On_Black$BIGreen -r, --force-recreate     $No_Color$IWhite$On_Black Recreate containers even if their configuration and image haven't changed.$No_Color"
                    return
                    ;;
                -b|--build)
                    shift
                    BUILD=1
                    ;;
                -f|--force-recreate)
                    shift
                    RECREATE=1
                    ;;
                -*)
                    for (( i=1; i<${#2}; i++ )); do
                        case "${2:$i:1}" in
                            b)
                                # shift
                                BUILD=1
                                ;;
                            f)
                                # shift
                                RECREATE=1
                                ;;
                            *)
                                echo -e "$BRed Unknown option: -${2:$i:1} $No_Color"
                                ;;
                        esac
                    done
                    shift
                    ;;
                *)
                break
                ;;
            esac
        done

        docker_cmd=(docker)
        service=(compose)
        executable=(up)
        append=("-d")
        append+=("--remove-orphans")
        if [[ $BUILD -eq 1 ]]; then
            append+=("--build")
        fi
        if [[ $RECREATE -eq 1 ]]; then
            append+=("--force-recreate")
        fi
    elif [[ "$1" == "down" || "$1" == "d" ]]; then
        while test $# -gt 0; do
            case "$2" in
                -h|--help)
                    shld_help_header
                    echo -e "$On_Purple$BWhite (i) $No_Color$On_Black$BPurple Shutdown (gracefully) and remove the docker containers. $No_Color"
                    echo " "
                    echo -e "$On_Black$BGreen shld down [options]  $No_Color"
                    echo " "
                    echo -e "$On_White$BBlack EXAMPLE:          $No_Color"
                    echo -e "$On_Black$BIGreen shld down -h                $No_Color"
                    echo " "
                    echo -e "$On_White$BBlack Options:          $No_Color"
                    echo -e "$On_Black$BIGreen -h, --help               $No_Color$IWhite$On_Black shows this help page                                                      $No_Color"
                    return
                    ;;
                *)
                break
                ;;
            esac
        done
        docker_cmd=(docker)
        service=(compose)
        executable=(down)
        append=()
    elif [[ "$1" == "ps" ]]; then
        while test $# -gt 0; do
            case "$2" in
                -h|--help)
                    shld_help_header
                    echo -e "$On_Purple$BWhite (i) $No_Color$On_Black$BPurple List all the created and running docker containers. $No_Color"
                    echo " "
                    echo -e "$On_Black$BGreen shld ps [service]  $No_Color"
                    echo " "
                    echo -e "$On_White$BBlack EXAMPLE:          $No_Color"
                    echo -e "$On_Black$BIGreen shld ps                          $No_Color"
                    echo -e "$On_Black$BIGreen shld ps mariadb                  $No_Color"
                    echo -e "$On_Black$BIGreen shld ps app                      $No_Color"
                    echo " "
                    echo -e "$On_White$BBlack Arguments:        $No_Color"
                    echo -e "$On_Black$BIGreen [service]        $No_Color$IWhite$On_Black Name of the service               $No_Color"
                    echo -e "$On_Black                  $IGreen$On_Black eg: mariadb, nginx, redis, etc.   $No_Color"
                    echo " "
                    echo -e "$On_White$BBlack Options:          $No_Color"
                    echo -e "$On_Black$BIGreen -h, --help       $No_Color$IWhite$On_Black shows this help page              $No_Color"
                    return
                    ;;
                *)
                break
                ;;
            esac
        done
        docker_cmd=(docker)
        service=(compose)
        executable=(ps)
        shift
        append=("$@")
    else
        docker_cmd=(docker exec -it)
        service_append="shld"
        service=(${service_append}-"$1")
        executable=()
        append=()
        remain=()

        if [[ "$2" == "artisan" ]]; then
            shift $(expr $OPTIND + 1 )
            executable=(php)
            append+=(artisan "$@")
        elif [[ "$2" == "tinker" ]]; then
            shift $(expr $OPTIND + 1 )
            executable=(php)
            append+=(artisan tinker "$@")
        elif [[ "$2" == "php" ]]; then
            if [[ "$3" == "artisan" ]]; then
                shift $(expr $OPTIND + 2 )
                executable=(php)
                append+=(artisan "$@")
            else
                shift $(expr $OPTIND + 1 )
                executable=(php)
                append+=("$@")
            fi
        elif [[ "$2" == "yarn" ]]; then
            shift $(expr $OPTIND + 1 )
            executable=(yarn)
            append+=("$@")
        elif [[ "$2" == "npm" ]]; then
            shift $(expr $OPTIND + 1 )
            executable=(npm)
            append+=("$@")
        elif [[ "$2" == "git" ]]; then
            shift $(expr $OPTIND + 1 )
            executable=(git)
            append+=("$@")
        elif [[ "$2" == "composer" ]]; then
            shift $(expr $OPTIND + 1 )
            executable=(composer)
            append+=("$@")
        elif [[ "$2" == "pint" ]]; then
            shift $(expr $OPTIND + 1 )
            executable=(./vendor/bin/pint)
            append+=("$@")
        elif [[ "$2" == "phpunit" || "$2" == "unit" ]]; then
            shift $(expr $OPTIND + 1 )
            executable=(./vendor/bin/phpunit)
            append+=("$@")
        else
            executable=("$2")
            shift $(expr $OPTIND + 1 )
            append+=("$@")
        fi
    fi

    echo " "
    echo -n -e "$On_Green$BIBlack Running Command: $No_Color" &&\
    echo -n -e "$On_Black$BIWhite " && echo -n "${docker_cmd[@]} ${service[@]} ${executable[@]} ${append[@]}" && echo -e " $No_Color"
    echo " "
    
    "${docker_cmd[@]}" "${service[@]}" "${executable[@]}" "${append[@]}"

}

shld () {
    if [ "$1" == "artisan" ] || \
        [ "$1" == "tinker" ] || \
        [ "$1" == "php" ] || \
        [ "$1" == "yarn" ] || \
        [ "$1" == "npm" ] || \
        [ "$1" == "git" ] || \
        [ "$1" == "composer" ] || \
        [ "$1" == "pint" ] || \
        [ "$1" == "phpunit" ] || \
        [ "$1" == "unit" ]; then
        command=(shld_service core)
        append=("$@")
    elif [ -z "$1" ]; then
        command=(shld_service help)
    else
        command=(shld_service)
        append=("$@")
    fi

    "${command[@]}" "${append[@]}"

}
