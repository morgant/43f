PREFIX = /usr/local

OS = $(shell uname -s)

install: 43f 43f.conf.default
	mkdir -p $(PREFIX)/bin
	install -m755 43f $(PREFIX)/bin
	mkdir -p $(PREFIX)/etc
	cp 43f.conf.default $(PREFIX)/etc/43f.conf
	@echo
	@echo "Please run '43f init /path/to/43f/repository' to initialize repository"
ifeq ($(OS),Darwin)
	cp com.makkintosshu.43f.plist.default /Library/LaunchDaemons/com.makkintosshu.43f.plist
	@echo
	@echo "Please run 'sudo launchctl load /Library/LaunchDaemons/com.makkintosshu.43f.plist' to install the LaunchDaemon"
endif

uninstall:
	rm $(PREFIX)/bin/43f
	rm $(PREFIX)/etc/43f.conf
ifeq ($(OS),Darwin)
	launchctl unload /Library/LaunchDaemons/com.makkintosshu.43f.plist
	rm /Library/LaunchDaemons/com.makkintosshu.43f.plist
endif
