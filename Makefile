# Edited by ved0el
# Insprited by @b4b4r07 [https://github.com/b4b4r07]

DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*)
EXCLUSIONS := .DS_Store .git .gitmodules .travis.yml .gitignore .vscode
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.DEFAULT_GOAL := help

all:

list: ## Show list of dotfiles in this reporitory
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

install: ## Create symlink to $HOME
	@echo '==> Start to deploy dotfiles to $(HOME).'
	@echo ''
	@$(foreach val, $(DOTFILES), ln -sfnv $(realpath $(val)) $(HOME)/$(val);)
	@ln -snvf $(CURDIR)/.config/*$< $(HOME)/.config/$<

update: ## Fetch changes for this reporitory
	git pull origin main
	git submodule init
	git submodule update
	git submodule foreach git pull origin main

clean: ## Remove the dotfile symlinks
	@echo 'Remove dotfile symlinks from $HOME...'
	@-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(val);)

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'
