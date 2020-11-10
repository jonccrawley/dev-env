
install: install-homebrew force-restore 
restore: brew-cleanup git-pull-changes brew-bundle

install-homebrew:
	/usr/bin/ruby -e "`curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install`" || true

force-restore:
	git fetch
	echo "" > .Brewfile
	brew-cleanup	
	git-reset
	restore

git-reset:
	git reset --hard origin/master	

git-pull-changes:
	git pull origin master

brew-bundle:
	brew bundle --verbose --global

brew-dump:
	brew bundle dump --force --global

brew-cleanup:
	brew bundle cleanup --force --global


