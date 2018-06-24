set -x KN_CMD_START_TIME_NS 0
set -x KN_CMD_END_TIME_NS 0

function fish_prompt
    rusty-prompt $status
end

function __set_command_start_time --on-event fish_preexec
    set -x KN_CMD_START_TIME_NS (date +%s%N)
end

function __set_command_end_time --on-event fish_postexec
    set -x KN_CMD_END_TIME_NS (date +%s%N)
end

# vim: set filetype=fish:
