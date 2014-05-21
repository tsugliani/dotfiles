# Prints tmux session info.
# Assuems that [ -n "$TMUX"].

run_segment() {
	tmux display-message -p '#S:#I'
	return 0
}
