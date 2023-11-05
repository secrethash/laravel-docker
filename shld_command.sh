#!/usr/bin/env bash

# Bash Functions
shld_help_header () {
    echo " "
    echo "HELP for Secrethash Laravel Docker"
    echo "Package: https://github.com/secrethash/Laravel-Docker"
    echo " "
}

shld_service () {

    while test $# -gt 0; do
        case "$1" in
            -h|--help|help)
                shld_help_header
                echo "shld [options] [arguments]"
                echo "EXAMPLE:"
                echo -e "\t shld up --build \n\t shld down \n\t shld artisan about \n\t shld help"
                echo " "
                echo "shld [options] [?service=core] [arguments]"
                echo " "
                echo "(i) The [service] defaults to core if not specified and supported arguments (listed below) are provided."
                echo " "
                echo "arguments:"
                echo "artisan, php artisan      Run php artisan commands in a container"
                echo "php                       Run php commands in a container"
                echo "composer                  Run composer commands in a container"
                echo "yarn                      Run yarn commands in a container"
                echo "npm                       Run npm commands in a container"
                echo "unit, phpunit             Run phpunit tests in a container"
                echo "pint                      Run pint in a container"
                echo "git                       Run git commands in a container"
                echo " "
                echo "options:"
                echo "-h, --help                shows this help page"
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
                    echo "Bring up the docker containers by running."
                    echo " "
                    echo "shld up [options]"
                    echo "EXAMPLE:"
                    echo -e "\t shld up -b \n\t shld up -r \n\t shld up -h"
                    echo " "
                    echo "options:"
                    echo "-h, --help                shows this help"
                    echo "-b, --build               Build images before starting containers."
                    echo "-r, --force-recreate      Recreate containers even if their configuration and image haven't changed."
                    return
                    ;;
                -b|--build)
                    shift
                        BUILD=1
                    shift
                    ;;
                -r|--force-recreate)
                    shift
                        RECREATE=1
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
        append=(-d --remove-orphans )
        if [[ $BUILD -eq 1 ]]; then
            append+=( --build )
        fi
        if [[ $RECREATE -eq 1 ]]; then
            append+=( --force-recreate )
        fi
    elif [[ "$1" == "down" || "$1" == "d" ]]; then
        while test $# -gt 0; do
            case "$2" in
                -h|--help)
                    shld_help_header
                    echo "Shutdown (gracefully) and remove the docker containers"
                    echo " "
                    echo "shld down [options]"
                    echo "EXAMPLE:"
                    echo -e "\t shld down \n\t shld down -h"
                    echo " "
                    echo "options:"
                    echo "-h, --help                shows this help"
                    return
                    ;;
            esac
        done
        shift $(expr $OPTIND + 1 )
        docker_cmd=(docker)
        service=(compose)
        executable=(down)
        append=()
        # append=("$@")
    elif [[ "$1" == "ps" ]]; then
        while test $# -gt 0; do
            case "$2" in
                -h|--help)
                    shld_help_header
                    echo "List all the created and running docker containers"
                    echo " "
                    echo "shld down [options]"
                    echo "EXAMPLE:"
                    echo -e "\t shld down \n\t shld down -h"
                    echo " "
                    echo "options:"
                    echo "-h, --help                shows this help"
                    return
                    ;;
            esac
        done
        docker_cmd=(docker)
        service=(compose)
        executable=(ps)
        append=()
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

    # echo "${docker_cmd[@]} ${service[@]} ${executable[@]} ${append[@]}"
    # exit 1;

    "${docker_cmd[@]}" "${service[@]}" "${executable[@]}" "${append[@]}"

}

shld () {
    if [ "$1" == "artisan" ] || \
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
    else
        command=(shld_service)
        append=("$@")
    fi

    "${command[@]}" "${append[@]}"

}