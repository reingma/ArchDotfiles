def start_tmux [] {
	let session = "home"
	 # tmux new-session -s $session -n home -d err> /dev/null
	# print $has_session
	if 'TMUX' not-in ($env | columns) {
		# tmux attach -t $session
		tmux
	}
}

start_tmux
