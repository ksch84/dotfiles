all:
	mkdir -p ~/.config/backgrounds
	stow -v --restow --dotfiles --ignore \.jpg --target $$HOME  */
	stow -v --restow --target ~/.config/backgrounds backgrounds
delete:
	stow -v --delete --dotfiles --target $$HOME */
	stow -v --delete --target ~/.config/backgrounds backgrounds
	rm -rf ~/.config/backgrounds
