def start_tmux [] {
	if 'TMUX' not-in ($env | columns) {
		tmux
	}
}

start_tmux
