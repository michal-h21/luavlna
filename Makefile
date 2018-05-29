PACKAGE_NAME = luavlna
BUILD_DIR = build
BUILD_LUAVLNA = $(BUILD_DIR)/$(PACKAGE_NAME)

VERSION:= undefined
DATE:= undefined

ifeq ($(strip $(shell git rev-parse --is-inside-work-tree 2>/dev/null)),true)
	VERSION:= $(shell git --no-pager describe --abbrev=0 --tags --always )
	DATE:= $(firstword $(shell git --no-pager show --date=short --format="%ad" --name-only))
endif

.PHONY: build

build:
	@rm -rf $(BUILD_DIR)
	@mkdir -p $(BUILD_LUAVLNA)
	rsync `git ls-tree --full-tree -r --name-only HEAD | grep -v Makefile` $(BUILD_LUAVLNA)
