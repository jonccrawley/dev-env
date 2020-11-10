
install: install-homebrew
restore: brew-cleanup git-pull-changes brew-bundle

install-homebrew:
	/usr/bin/ruby -e "`curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install`" || true

force-restore:
	git fetch
	echo "" > .Brewfile
	brew bundle cleanup --force --global	
	git reset --hard origin/master
	make restore

git-pull-changes:
	git pull origin master

brew-bundle:
	brew bundle --verbose --global

brew-dump:
	brew bundle dump --force --global

brew-cleanup:
	brew bundle cleanup --force --global


