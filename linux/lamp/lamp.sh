#!/usr/bin/env bash
# Copyright (C) 2013 - 2022 Teddysun <i@teddysun.com>
# 
# This file is part of the LAMP script.
#
# LAMP is a powerful bash script for the installation of 
# Apache + PHP + MySQL/MariaDB and so on.
# You can install Apache + PHP + MySQL/MariaDB in an very easy way.
# Just need to input numbers to choose what you want to install before installation.
# And all things will be done in a few minutes.
#
# System Required:  CentOS 7+ / Debian 9+ / Ubuntu 18+
# Description:  Install LAMP(Linux + Apache + MySQL/MariaDB + PHP )
# Website:  https://lamp.sh
# Github:   https://github.com/teddysun/lamp

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

cur_dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

include(){
    local include=${1}
    if [[ -s ${cur_dir}/include/${include}.sh ]];then
        . ${cur_dir}/include/${include}.sh
    else
        echo "Error: ${cur_dir}/include/${include}.sh not found, shell can not be executed."
        exit 1
    fi
}

version(){
    _info "Version: $(_green 20220415)"
}

show_parameters(){
    local soft=${1}
    eval local arr=(\${${soft}_arr[@]})
    for ((i=1;i<=${#arr[@]};i++ )); do
        vname="$(get_valid_valname ${arr[$i-1]})"
        hint="$(get_hint $vname)"
        [[ "$hint" == "" ]] && hint="${arr[$i-1]}"
        echo -e "  ${i}. ${hint}"
    done
}

show_help(){
    echo
    echo "+-------------------------------------------------------------------+"
    echo "| Auto Install LAMP(Linux + Apache + MySQL/MariaDB + PHP )          |"
    echo "| Website: https://lamp.sh                                          |"
    echo "| Author : Teddysun <i@teddysun.com>                                |"
    echo "+-------------------------------------------------------------------+"
    echo
    printf "
Usage  : $0 [Options] [Parameters]
Options:
-h, --help                      Print this help text and exit
-v, --version                   Print program version and exit
--apache_option [1-2]           Apache server version
--apache_modules [mod name]     Apache modules: mod_wsgi, mod_security, mod_jk
--db_option [1-9]               Database version
--db_data_path [location]       Database Data Location. for example: /data/db
--db_root_pwd [password]        Database root password. for example: lamp.sh
--php_option [1-4]              PHP version
--php_extensions [ext name]     PHP extensions:
                                apcu, ioncube, pdflib, imagick, xdebug
                                memcached, redis, mongodb, libsodium, swoole
                                yaf, yar, phalcon, grpc
--db_manage_modules [mod name]  Database management modules: phpmyadmin, adminer
--kodexplorer_option [1-2]      KodExplorer version

Parameters:
"
    echo "--apache_option [1-2], please select a available Apache version"
    show_parameters apache
    echo "--db_option [1-9], please select a available Database version"
    show_parameters mysql
    echo "--php_option [1-4], please select a available PHP version"
    show_parameters php
    echo "--kodexplorer_option [1-2], please select a available KodExplorer version"
    show_parameters kodexplorer
}

process(){
    apache_option=""
    apache_modules=""
    php_option=""
    php_extensions=""
    db_option=""
    db_data_path=""
    db_root_pwd=""
    db_manage_modules=""
    kodexplorer_option=""
    while [ ${#} -gt 0 ]; do
        case "$1" in
        -h|--help)
            show_help && exit 0
            ;;
        -v|--version)
            version && exit 0
            ;;
        --apache_option)
            apache_option="$2"
            if ! is_digit ${apache_option}; then
                _error "Option --apache_option input error, please only input a number"
            fi
            [[ "${apache_option}" -lt 1 || "${apache_option}" -gt 2 ]] && _error "Option --apache_option input error, please only input a number between 1 and 2"
            eval apache=${apache_arr[${apache_option}-1]}
            ;;
        --apache_modules)
            apache_modules="$2"
            apache_modules_install=""
            [ -n "$(echo ${apache_modules} | grep -w mod_wsgi)" ] && apache_modules_install="${mod_wsgi_filename}"
            [ -n "$(echo ${apache_modules} | grep -w mod_security)" ] && apache_modules_install="${apache_modules_install} ${mod_security_filename}"
            [ -n "$(echo ${apache_modules} | grep -w mod_jk)" ] && apache_modules_install="${apache_modules_install} ${mod_jk_filename}"
            ;;
        --php_option)
            php_option="$2"
            if ! is_digit ${php_option}; then
                _error "Option --php_option input error, please only input a number"
            fi
            [[ "${php_option}" -lt 1 || "${php_option}" -gt 4 ]] && _error "Option --php_option input error, please only input a number between 1 and 4"
            eval php=${php_arr[${php_option}-1]}
            ;;
        --php_extensions)
            php_extensions="$2"
            php_modules_install=""
            [ -n "$(echo ${php_extensions} | grep -w ioncube)" ] && php_modules_install="${ionCube_filename}"
            [ -n "$(echo ${php_extensions} | grep -w pdflib)" ] && php_modules_install="${php_modules_install} ${pdflib_filename}"
            [ -n "$(echo ${php_extensions} | grep -w imagick)" ] && php_modules_install="${php_modules_install} ${php_imagemagick_filename}"
            [ -n "$(echo ${php_extensions} | grep -w memcached)" ] && php_modules_install="${php_modules_install} ${php_memcached_filename}"
            [ -n "$(echo ${php_extensions} | grep -w redis)" ] && php_modules_install="${php_modules_install} ${php_redis_filename}"
            [ -n "$(echo ${php_extensions} | grep -w mongodb)" ] && php_modules_install="${php_modules_install} ${php_mongo_filename}"
            [ -n "$(echo ${php_extensions} | grep -w libsodium)" ] && php_modules_install="${php_modules_install} ${php_libsodium_filename}"
            [ -n "$(echo ${php_extensions} | grep -w swoole)" ] && php_modules_install="${php_modules_install} ${swoole_filename}"
            [ -n "$(echo ${php_extensions} | grep -w yaf)" ] && php_modules_install="${php_modules_install} ${yaf_filename}"
            [ -n "$(echo ${php_extensions} | grep -w yar)" ] && php_modules_install="${php_modules_install} ${yar_filename}"
            [ -n "$(echo ${php_extensions} | grep -w phalcon)" ] && php_modules_install="${php_modules_install} ${phalcon_filename}"
            [ -n "$(echo ${php_extensions} | grep -w xdebug)" ] && php_modules_install="${php_modules_install} ${xdebug_filename}"
            [ -n "$(echo ${php_extensions} | grep -w apcu)" ] && php_modules_install="${php_modules_install} ${apcu_filename}"
            [ -n "$(echo ${php_extensions} | grep -w grpc)" ] && php_modules_install="${php_modules_install} ${grpc_filename}"
            ;;
        --db_option)
            db_option="$2"
            if ! is_digit ${db_option}; then
                _error "Option --db_option input error, please only input a number"
            fi
            [[ "${db_option}" -lt 1 || "${db_option}" -gt 9 ]] && _error "Option --db_option input error, please only input a number between 1 and 9"
            eval mysql=${mysql_arr[${db_option}-1]}
            if [[ "${mysql}" == "${mariadb10_3_filename}" || \
                  "${mysql}" == "${mariadb10_4_filename}" || \
                  "${mysql}" == "${mariadb10_5_filename}" || \
                  "${mysql}" == "${mariadb10_6_filename}" || \
                  "${mysql}" == "${mariadb10_7_filename}" ]] \
                  && version_lt $(get_libc_version) 2.14; then
                _error "Option --db_option input error, ${mysql} is not be supported in your OS, please input a correct number"
            fi
            if ! is_64bit && [[ "${mysql}" == "${mariadb10_6_filename}" || "${mysql}" == "${mariadb10_7_filename}" ]]; then
                _error "Option --db_option input error, ${mysql} is not be supported in your OS, please input a correct number"
            fi
            ;;
        --db_data_path)
            db_data_path="$2"
            if ! echo ${db_data_path} | grep -q "^/"; then
                _error "Option --db_data_path input error, please input a correct location"
            fi
            ;;
        --db_root_pwd)
            db_root_pwd="$2"
            if printf '%s' "${db_root_pwd}" | LC_ALL=C grep -q '[^ -~]\+'; then
                _error "Option --db_root_pwd input error, please do not contain non-ASCII characters"
            fi
            [ -n "$(echo ${db_root_pwd} | grep '[+|&]')" ] && _error "Option --db_root_pwd input error, please do not contain special characters like + and &"
            if (( ${#db_root_pwd} < 5 )); then
                _error "Option --db_root_pwd input error, must more than 5 characters"
            fi
            ;;
        --db_manage_modules)
            db_manage_modules="$2"
            phpmyadmin_install=""
            [ -n "$(echo ${db_manage_modules} | grep -w phpmyadmin)" ] && phpmyadmin_install="${phpmyadmin_filename}"
            [ -n "$(echo ${db_manage_modules} | grep -w adminer)" ] && phpmyadmin_install="${phpmyadmin_install} ${adminer_filename}"
            ;;
        --kodexplorer_option)
            kodexplorer_option="$2"
            if ! is_digit ${kodexplorer_option}; then
                _error "Option --kodexplorer_option input error, please only input a number"
            fi
            [[ "${kodexplorer_option}" -lt 1 || "${kodexplorer_option}" -gt 2 ]] && _error "Option --kodexplorer_option input error, please only input a number between 1 and 2"
            eval kodexplorer=${kodexplorer_arr[${kodexplorer_option}-1]}
            ;;
        *)
            _error "unknown argument: $1"
            ;;
        esac
        shift 2
    done
}

set_parameters(){
    [ -z "${apache_option}" ] && apache="do_not_install"
    [ -z "${apache_modules_install}" ] && apache_modules_install="do_not_install"
    [ "${apache}" == "do_not_install" ] && apache_modules_install="do_not_install"

    [ -z "${php_option}" ] && php="do_not_install"
    [ "${apache}" == "do_not_install" ] && php="do_not_install"
    [ -z "${php_extensions}" ] && php_modules_install="do_not_install"
    [ -z "${php_modules_install}" ] && php_modules_install="do_not_install"
    [ "${php}" == "do_not_install" ] && php_modules_install="do_not_install"
    if [ -n "${php_modules_install}" ]; then
        if [[ "${php}" =~ ^php-8.[0-1].+$ ]]; then
            if_in_array "${phalcon_filename}" "${php_modules_install}" && _error "${phalcon_filename} is not support ${php}, please remove php extension: phalcon"
            if_in_array "${ionCube_filename}" "${php_modules_install}" && _error "${ionCube_filename} is not support ${php} now, please remove php extension: ioncube"
            if_in_array "${php_memcached_filename}" "${php_modules_install}" && _error "${php_memcached_filename} is not support ${php} now, please remove php extension: memcached"
        fi
        if [[ "${php}" =~ ^php-8.1.+$ ]]; then
            if_in_array "${php_libsodium_filename}" "${php_modules_install}" && _error "${php_libsodium_filename} is not support ${php}, please remove php extension: libsodium"
        fi
    fi

    [ -z "${db_option}" ] && mysql="do_not_install"
    if echo "${mysql}" | grep -qi "mysql"; then
        mysql_data_location=${db_data_path:=${mysql_location}/data}
        mysql_root_pass=${db_root_pwd:=lamp.sh}
    elif echo "${mysql}" | grep -qi "mariadb"; then
        mariadb_data_location=${db_data_path:=${mariadb_location}/data}
        mariadb_root_pass=${db_root_pwd:=lamp.sh}
    fi

    [ -z "${db_manage_modules}" ] && phpmyadmin_install="do_not_install"
    [ "${php}" == "do_not_install" ] && phpmyadmin_install="do_not_install"
    [ -z "${kodexplorer_option}" ] && kodexplorer="do_not_install"
    [ "${php}" == "do_not_install" ] && kodexplorer="do_not_install"

    phpConfig=${php_location}/bin/php-config
}

#lamp auto process
lamp_auto(){
    check_os
    check_ram
    display_os_info
    last_confirm
    lamp_install
}

main() {
    if [ -z "$1" ]; then
        pre_setting
    else
        process "$@"
        set_parameters
        lamp_auto
    fi
}

include config
include public
include apache
include mysql
include php
include php-modules
load_config
rootness

#Run it
main "$@" 2>&1 | tee ${cur_dir}/lamp.log