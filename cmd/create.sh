cmd_create_help() {
    cat <<_EOF
    create
        Create the monit container '$CONTAINER'.

_EOF
}

rename_function cmd_create orig_cmd_create
cmd_create() {
    mkdir -p logs conf.d
    touch logs/monit.log
    orig_cmd_create \
        --mount type=bind,src=$(pwd)/conf.d,dst=/etc/monit/conf.d \
        --mount type=bind,src=$(pwd)/logs/monit.log,dst=/var/log/monit.log
}
