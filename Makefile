PREFIX=/usr/local

install: 43f 43f.conf.default
	mkdir -p $(PREFIX)/bin
	install -m755 43f $(PREFIX)/bin
	mkdir -p $(PREFIX)/etc
	cp 43f.conf.default $(PREFIX)/etc/43f.conf
	@echo
	@echo "Please run '43f init /path/to/43f/repository' to initialize repository"

uninstall:
	rm $(PREFIX)/bin/43f
	rm $(PREFIX)/etc/43f.conf
