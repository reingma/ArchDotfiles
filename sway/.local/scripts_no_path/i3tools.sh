#!/usr/bin/env sh
i3tool() (
	# {{{ Hidden functions
	if [ -n "${BASH_VERSION:-}" ]; then
		is_fn() {
			# shellcheck disable=2039
			[[ "$(type -t "$1")" = function ]]
		}
	elif [ -n "${ZSH_VERSION:-}" ]; then
		is_fn() {
			# shellcheck disable=2039
			typeset -f "$1" >/dev/null
		}
	else
		is_fn() {
			command -V "$1" | grep -Fq ' function'
		}
	fi
	_prog="i3tool"
	unset session class

	test_cmd() {
		for c in "$@"; do
			if command -v "${c%% *}" >/dev/null 2>&1; then
				echo "$c"
				return 0
			fi
		done
		return 1
	}

	with_flag() {
		flag="$1"
		help="$2"
		shift 2
		printf %s "$*"
		"$1" "$help" 2>&1 | grep -Fq -- "$flag" && printf ' %s\n' "$flag"
	}
	# }}}
	# {{{ Utility functions
	help_() {
		cat >&2 <<EOF
$_prog [options] [subcommand [arg ... ]) [, [command [arg ...] ]] ...

Subcommands are separated by a lone comma (,)

Options:
	-h|--help               print this help
	-H|--Help               print long help
	-s|--session [i3|sway]  use this session
	-n|--no-startup-id      disable startup-notification support
	-c|--class [CLASS]      use this WM_CLASS for (focus|switch)launch
	-d|-x|--debug           \`set -x\` for debugging

Subcommands:
	help [*]                        print this help, add any argument for long help
	msg [...]                       pass arguments to (i3-|sway)msg
	flaunch [prog [args ...]]       if a program exists, focus it, otherwise launch
	slaunch [ws] [prog [args ...]]  focus the workspace, launch program if workspace was
	                                already focused or the program was not running there
	exec [prog [args ...]]          alias to 'msg -- exec'
	exit                            alias to 'msg exit'
	sresize                         resize with mouse selection
	lock                            lock screen with a desaturated, pixelized screenshot
	poweroff|reboot                 do the associated loginctl action
	suspend|hibernate|hybridsleep   lock (as above) and do the loginctl action
EOF
		[ -n "$1" ] && cat >&2 <<EOF
	get_(binding_modes
	    |config|outputs
	    |version|workspaces
	    |marks|tree)                alias to 'msg -t get_*'
	get_(config_path|layout
	    |workspace)                 alias to 'msg -t [something] | jq [some filter]'
	get_loginctl                    runs \`cat /proc/1/comm\` to get whether systemctl or (?)
	get_session                     echos back i3 or sway, depending on which is detected
	get_scrot                       prints an installed screenshotting  for SESSION
	get_lock                        prints an installed locking program for SESSION
EOF
	}

	msg_() {
		case "$session" in
		i3) DISPLAY="${DISPLAY:=":0"}" XAUTHORITY="${XAUTHORITY:="$HOME/.Xauthority"}" i3-msg "$@" ;;
		sway) SWAYSOCK="${SWAYSOCK:="${XDG_RUNTIME_DIR:=/run/user/$(id -u)}/sway-ipc.$(id -u).$(pgrep -x sway).sock"}" swaymsg "$@" ;;
		*) return 1 ;;
		esac
	}
	# }}}
	# {{{ System info functions
	get_loginctl_() {
		case "$(cat /proc/1/comm)" in
		systemd) echo systemctl ;;
		*) test_cmd zzz ;;
		esac
	}

	get_session_() {
		case "$DESKTOP_SESSION" in
		i3)
			echo i3
			return
			;;
		sway)
			echo sway
			return
			;;
		esac
		if [ -n "${WAYLAND_DISPLAY:-}" ]; then
			echo sway
			return
		fi
		if pkill -0 '^sway$'; then
			echo sway
			return
		elif pkill -0 '^i3$'; then
			echo i3
			return
		else
			echo >&2 "Could not find i3 or sway."
			return 1
		fi
	}

	get_scrot_() {
		case "$session" in
		i3) test_cmd maim scrot xfce4-screenshooter "import -window root" && return 0 ;;
		sway) test_cmd grim && return 0 ;;
		*)
			echo >&2 "Invalid session: $session"
			return 1
			;;
		esac
		echo >&2 "No screenshot program could be found."
		return 1
	}

	get_lock_() {
		case "$session" in
		sway)
			l="$(test_cmd swaylock)"
			with_flag -m -h "$l -f"
			return 0
			;;
		i3)
			l="$(test_cmd i3lock)"
			with_flag -m -h "$l"
			return 0
			;;
		*)
			echo >&2 "Invalid argument: $session"
			return 1
			;;
		esac
		echo >&2 "No locking program could be found."
		return 1
	}
	# }}}
	# {{{ System action functions

	exit_() {
		msg_ exit
	}

	reboot_() {
		reboot
	}

	poweroff_() {
		poweroff
	}

	suspend_() {
		lock_
		"${loginctl:=$(get_loginctl_)}" suspend
	}

	hybridsleep_() {
		lock_
		"${loginctl:=$(get_loginctl_)}" hybrid-sleep
	}

	hibernate_() {
		lock_
		"${loginctl:=$(get_loginctl_)}" hibernate
	}
	# }}}
	# {{{ $session info functions
	get_binding_modes_() { msg_ -t get_binding_modes; }

	get_config_() { msg_ -t get_config; }

	get_config_path_() {
		msg_ -t get_version | jq --raw-output .loaded_config_file_name
	}

	get_marks_() { msg_ -t get_marks; }

	get_outputs_() { msg_ -t get_outputs; }

	get_tree_() { msg_ -t get_tree; }

	get_workspaces_() { msg_ -t get_workspaces; }

	get_layout_() {
		msg_ -t get_tree | jq --raw-output \
			'recurse(.nodes[]; .nodes != null) | select(.nodes[].focused).layout'
	}

	get_focused_container_() {
		case ${session:=$(get_session)} in
		sway)
			get_tree_ | jq --raw-output \
				'.nodes[].nodes[]|select(.name!="__i3_scratch")|
			.floating_nodes+recurse(.nodes[]).nodes|.[]|select(.focused)'
			;;
		i3)
			get_tree_ | jq --raw-output \
				'.nodes[].nodes[].nodes[]|.floating_nodes[]+recurse(.nodes[])|select(.focused)'
			;;
		esac
	}

	get_workspace_() {
		msg_ -t get_workspaces | jq --raw-output \
			'.[] | select(.focused).name'
	}

	get_version_() {
		msg_ -t get_version | jq --raw-output "\"$session \" + .human_readable"
	}
	# }}}
	# {{{ $session action functions
	exec_() {
		#shellcheck disable=2086
		msg_ -- exec $exec_args "$@"
	}

	flaunch_() {
		#shellcheck disable=2030
		con_id="$(msg_ -t get_tree | jq '
	first(recurse((.nodes + .floating_nodes)[]) |
	select(any(
		.window_properties.class,
		.window_properties.instance,
		.window_properties.window_role,
		.app_id;
		values and match("'"${class:=$1}"'")
	)).id)')"
		echo "$con_id"
		if [ -n "${con_id:-}" ]; then
			msg_ "[con_id=${con_id%% }]" focus
		else exec_ "$@"; fi
	}

	slaunch_() {
		if msg_ -t get_workspaces | jq --exit-status 'any(.visible and .name == "'"$1"'")'; then
			msg_ workspace "$1"
			shift
			con_id="$(msg_ -t get_tree | jq '
		first(recurse((.nodes + .floating_nodes)[]) |
		select(any(
			.window_properties.class,
			.window_properties.instance,
			.window_properties.window_role,
			.app_id;
			values and match("'"${class:=$1}"'")
		)).id)')"
			echo "$con_id"
			if [ -n "${con_id:-}" ]; then
				msg_ "[con_id=${con_id%% }]" focus
			else exec_ "$@"; fi
		else
			msg_ workspace "$1"
			shift
			#shellcheck disable=2031
			msg_ -t get_tree | jq --raw-output --exit-status \
				'recurse(.nodes[]; .nodes != null) |
			select(.focused and any(
				.window_properties.class,
				.window_properties.instance,
				.window_properties.window_role,
				.app_id;
				values and match("'"${class:=$1}"'")
			))' || exec_ "$@"
		fi

	}

	lock_() {
		scrot="$(get_scrot_)" || return 1
		lock="$(get_lock_)" || return 1
		img="$(mktemp --suffix=.png)"
		trap '{ rm "$img"; return $?; }' INT
		$scrot "$img"
		# convert inplace
		convert "$img" -scale 20x20% -modulate 100,50 -scale 500x500% "$img"
		eval "$lock -i \"$img\""
		rm "$img"
	}

	sresize_() {
		case "${session:=$(get_session_)}" in
		i3) eval "$(slop -q -b 4 -c 0.03,0.21,0.26,0.5 -t 0 -f \
			"i3-msg floating enable, move position %x %y, resize set %w %h")" ;;
		sway)
			# -f flag not supported (yet)
			slurp -w 4 -c '#dc322f' | {
				IFS=', x' read -r x y w h
				swaymsg floating enable, move position "$x" "$y", resize set "$w" "$h"
			}
			;;
		*) return 1 ;;
		esac
	}
	# }}}
	# {{{ Main logic
	unset flag
	for a in "$@" ,; do
		# unset arguments on first iteration
		if [ -z "${flag:-}" ]; then
			set --
			flag=1
		fi
		case "$a" in
		,)
			# execute built action
			eval set -- "$(getopt -o nHhdxs:c: -l no-startup-id,help,Help,debug,session:,class: -- "$@")"
			while
				case "$1" in
				-h | --help)
					help_
					return
					;;
				-H | --Help)
					help_ long
					return
					;;
				-n | --no-startup-id) exec_args='--no-startup-id' ;;
				-c | --class)
					class="$2"
					shift
					;;
				-s | --session)
					session="$2"
					shift
					;;
				-d | -x | --debug) set -x ;;
				--)
					shift
					break
					;;
				*)
					help_
					return 1
					;;
				esac
				shift
			do :; done
			action="$1"
			if [ "$#" -ne 0 ] && is_fn "${action}_"; then
				shift
				session="${session:-"$(get_session_)"}" || return 1
				"${action}_" "$@"
			else
				help_
				return 1
			fi
			# unset arguments for next
			set --
			;;
		*)
			# rebuild arguments
			set -- "$@" "$a"
			;;
		esac
	done
	# }}}
)
# vim: foldmethod=marker
