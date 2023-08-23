SHELL := /bin/bash

build_dir := build

.PHONY build-dep:
build-dep:
	@echo "Building and installing libmoon and MoonGen dependencies..."
#update and init only libmoon, libmoon's Makefile will do the rest recursivly
	git submodule update --init

	cd libmoon && \
	$(MAKE) build-dep

	@echo "Building libmoon"
	cd libmoon && \
	$(MAKE) build

	cd libmoon && \
	$(MAKE) install

.PHONY: build
build:
	@echo "Building MoonGen..."
	meson setup $(build_dir)
	cd $(build_dir) && \
	meson compile
	@echo "Successfully built MoonGen"

.PHONY: install
install: ## Install MoonGen
	@echo "Installing MoonGen..."
	cd $(build_dir) && \
	sudo meson install
	@echo "Successfully installed MoonGen"

.PHONY: uninstall
uninstall: ## Uninstall MoonGen (use uninstall-all to uninstall the dependencies too)
	cd $(build_dir) && \
	sudo ninja uninstall || true

	@echo "Uninstalled MoonGen"

.PHONY: uninstall-all
uninstall-all: uninstall ## Uninstall MoonGen and all dependencies
	cd libmoon && \
	sudo $(MAKE) uninstall || true

	@echo "Uninstalled all dependencies"

.PHONY: clean
clean: ## Clean the build directory of MoonGen, not the dependencies (this does NOT delete all build files, use wipe for this)
	@echo "Cleaning up build files of MoonGen..."
	cd $(build_dir) && \
	meson compile --clean || true

.PHONY: wipe
wipe: ## Deletes all build files of MoonGen (not the dependencies)
	@echo "Wiping build files of MoonGen"
	rm -rf $(build_dir)

.PHONY: clean-all
clean-all: clean ## Clean the build directory of MoonGen and dependencies (this does NOT delete all build files, use wipe for this)
	@echo "Cleaning up build files of MoonGen and dependencies..."
	cd libmoon && \
	$(MAKE) clean-all || true

.PHONY: wipe-all
wipe-all: wipe ## Deletes all build files (of MoonGen and dependencies)
	@echo "Wiping build files of MoonGen and dependencies"
	cd libmoon && \
	$(MAKE) wipe-all || true
