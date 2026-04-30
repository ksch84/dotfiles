.PHONY: all minimal window-manager full delete deps wm-deps full-deps

all: minimal

deps:
	@echo "Installing minimal dependencies..."
	@sudo ./install.sh minimal

wm-deps:
	@echo "Installing window manager dependencies..."
	@sudo ./install.sh window-manager

full-deps: deps wm-deps

minimal: deps
	mkdir -p ~/.config/backgrounds
	mkdir -p ~/.config/mpd
	mkdir -p ~/.config/mpd/playlists
	mkdir -p ~/.config/ncmpcpp
	mkdir -p ~/.local/share/man/man7
	mkdir -p ~/.config/systemd/user
	cd minimal && stow -v --restow --dotfiles --ignore='\.jpg' --target $$HOME home
	cd minimal && stow -v --restow --target ~/.config/backgrounds backgrounds
	ln -sf $(CURDIR)/minimal/mpd/mpd.conf ~/.config/mpd/mpd.conf
	ln -sf $(CURDIR)/minimal/ncmpcpp/config ~/.config/ncmpcpp/config
	cp minimal/ncmpcpp.cheat ~/.local/share/man/man7/ncmpcpp-cheat.7
	ln -sf $(CURDIR)/minimal/systemd/user/mpd.service ~/.config/systemd/user/mpd.service
	systemctl --user daemon-reload
	systemctl --user enable --now mpd

window-manager: wm-deps
	cd window-manager && stow -v --restow --dotfiles --ignore='\.jpg' --target $$HOME */

full: full-deps minimal window-manager

delete:
	[ -d ~/.config/backgrounds ] && cd minimal && stow -v --delete --target ~/.config/backgrounds backgrounds 2>/dev/null; true
	cd minimal && stow -v --delete --dotfiles --target $$HOME home 2>/dev/null; true
	rm -f ~/.config/mpd/mpd.conf
	rm -f ~/.config/ncmpcpp/config
	rm -f ~/.config/systemd/user/mpd.service
	systemctl --user stop mpd 2>/dev/null; true
	systemctl --user disable mpd 2>/dev/null; true
	systemctl --user daemon-reload 2>/dev/null; true
	rmdir ~/.config/mpd 2>/dev/null; true
	rmdir ~/.config/ncmpcpp 2>/dev/null; true
	rmdir ~/.config/systemd/user 2>/dev/null; true
	rm -rf ~/.config/backgrounds
	rm -f ~/.local/share/man/man7/ncmpcpp-cheat.7
	cd window-manager && stow -v --delete --dotfiles --target $$HOME */ 2>/dev/null; true
