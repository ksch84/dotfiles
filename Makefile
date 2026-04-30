.PHONY: all minimal window-manager full delete

all: minimal

minimal:
	mkdir -p ~/.config/backgrounds
	mkdir -p ~/.config/mpd
	mkdir -p ~/.config/ncmpcpp
	mkdir -p ~/.local/share/man/man7
	cd minimal && stow -v --restow --dotfiles --ignore='\.jpg' --target $$HOME home
	cd minimal && stow -v --restow --target ~/.config/backgrounds backgrounds
	ln -sf $$(realpath minimal/mpd/mpd.conf) ~/.config/mpd/mpd.conf
	ln -sf $$(realpath minimal/ncmpcpp/config) ~/.config/ncmpcpp/config
	cp minimal/ncmpcpp.cheat ~/.local/share/man/man7/ncmpcpp-cheat.7

window-manager:
	cd window-manager && stow -v --restow --dotfiles --ignore='\.jpg' --target $$HOME */

full: minimal window-manager

delete:
	[ -d ~/.config/backgrounds ] && cd minimal && stow -v --delete --target ~/.config/backgrounds backgrounds 2>/dev/null; true
	cd minimal && stow -v --delete --dotfiles --target $$HOME home 2>/dev/null; true
	rm -f ~/.config/mpd/mpd.conf
	rm -f ~/.config/ncmpcpp/config
	rmdir ~/.config/mpd 2>/dev/null; true
	rmdir ~/.config/ncmpcpp 2>/dev/null; true
	rm -rf ~/.config/backgrounds
	rm -f ~/.local/share/man/man7/ncmpcpp-cheat.7
	cd window-manager && stow -v --delete --dotfiles --target $$HOME */ 2>/dev/null; true
