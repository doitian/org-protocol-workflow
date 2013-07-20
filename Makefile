NAME := org-protocol
WORKFLOWS_DIR := $(HOME)/Library/Application Support/Alfred 2/Alfred.alfredpreferences/workflows

# .SUFFIXES: .applescript .scpt

# .applescript.scpt:
#	osacompile -o $@ $<

# compile: capture.scpt

link:
	rm -rf "$(WORKFLOWS_DIR)/user.workflow.$(NAME)"
	mkdir -p "$(WORKFLOWS_DIR)"
	ln -snf "$$(pwd)" "$(WORKFLOWS_DIR)/user.workflow.$(NAME)"

package:
	rm -f org-protocol.alfredworkflow
	zip org-protocol.alfredworkflow capture.applescript icon.png info.plist main.sh

install: package
	open org-protocol.alfredworkflow

.PHONY: compile link package install
