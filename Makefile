all:
	stow -v --restow --dotfiles --ignore \.jpg --target $$HOME  */
	stow -v --restow --target /usr/share/backgrounds backgrounds
delete:
	stow -v --delete --dotfiles --target $$HOME */
	stow -v --delete --target /usr/share/backgrounds backgrounds
