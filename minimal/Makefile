all:
	mkdir -p ~/.config/backgrounds
	mkdir -p ~/.config/mpd
	mkdir -p ~/.config/ncmpcpp
	mkdir -p ~/.local/share/man/man7
	stow -v --restow --dotfiles --ignore='\.jpg' --target $$HOME home
	stow -v --restow --target ~/.config/backgrounds backgrounds
	ln -sf $(realpath mpd/mpd.conf) ~/.config/mpd/mpd.conf
	ln -sf $(realpath ncmpcpp/config) ~/.config/ncmpcpp/config
	cp ncmpcpp.cheat ~/.local/share/man/man7/ncmpcpp-cheat.7
delete:
	[ -d ~/.config/backgrounds ] && stow -v --delete --target ~/.config/backgrounds backgrounds 2>/dev/null; true
	stow -v --delete --dotfiles --target $$HOME home 2>/dev/null; true
	rm -f ~/.config/mpd/mpd.conf
	rm -f ~/.config/ncmpcpp/config
	rmdir ~/.config/mpd 2>/dev/null; true
	rmdir ~/.config/ncmpcpp 2>/dev/null; true
	rm -rf ~/.config/backgrounds
	rm -f ~/.local/share/man/man7/ncmpcpp-cheat.7

