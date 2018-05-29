PACKAGE_NAME = luavlna
BUILD_DIR = build
BUILD_LUAVLNA = $(BUILD_DIR)/$(PACKAGE_NAME)
# There must be also subdirectory for Lua files
LUA_DIR = $(PACKAGE_NAME)
DOC_FILE = luavlna-doc.pdf
DOC_SOURCE = luavlna-doc.tex
README = README.md
DIST_FILE = $(PACKAGE_NAME).zip

VERSION:= undefined
DATE:= undefined

ifeq ($(strip $(shell git rev-parse --is-inside-work-tree 2>/dev/null)),true)
	VERSION:= $(shell git --no-pager describe --abbrev=0 --tags --always )
	DATE:= $(firstword $(shell git --no-pager show --date=short --format="%ad" --name-only))
endif

.PHONY: build

doc: $(DOC_FILE)

ifeq ($(strip $(shell git rev-parse --is-inside-work-tree 2>/dev/null)),true)
	git fetch --tags
endif

$(DOC_FILE): $(DOC_SOURCE)
	latexmk -pdf -pdflatex='lualatex "\def\version{${VERSION}}\def\gitdate{${DATE}}\input{%S}"' $(DOC_SOURCE)

build: $(DOC_FILE)
	@rm -rf $(BUILD_DIR)
	@mkdir -p $(BUILD_LUAVLNA)
	@mkdir -p $(BUILD_LUAVLNA)/$(LUA_DIR)
	@# copy system files to the build dir, excluding Makefile
	@cp --parents `git ls-tree --full-tree -r --name-only HEAD | grep -v Makefile` $(BUILD_LUAVLNA)
	@sed -e "s/{{version}}/${VERSION}/" < $(README) | sed -e "s/{{date}}/$(DATE)/" > $(BUILD_LUAVLNA)/$(README)
	@cd $(BUILD_DIR) && zip -r $(DIST_FILE) $(PACKAGE_NAME)

