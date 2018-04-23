$(eval CURRENT_DIR := $(shell pwd))
$(eval BUILD_FILE := $(CURRENT_DIR)/_build/gitignore.native)

build:
	corebuild gitignore.native -package core,lwt,cohttp,cohttp.lwt,ansiterminal

install:
	@echo "Generating symlink under /usr/local/bin/gitignore for $(BUILD_FILE)"
	ln -s $(BUILD_FILE) /usr/local/bin/gitignore

uninstall:
	rm /usr/local/bin/gitignore
