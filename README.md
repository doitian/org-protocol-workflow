# org-protocol workflow #

## Usage

Use your favorite shortcut manager to add a binding to run `main.sh` in **this directory**.

## Config

-   `emacsclient`: default is `/usr/local/bin/emacsclient`. Update `CONFIG_EMACSCLIENT` directly

        CONFIG_EMACSCLIENT=/Applications/Emacs.app/

    , or set environment variable `EMACSCLIENT`

        export EMACSCLIENT=/Applications/Emacs.app/Contents/MacOS/bin/emacsclient
        ./main.sh

-   Fluid: It is assumed that you have created an App with name "Feedly" using Fluid. If you don't want to install Feedly as an Fluid app, change it in `capture.applescript`

-   Create an `org-capture` template using key "b", it's better to set `:immediate-finish`

        ("b" "org-protocol" entry (file+headline (concat org-directory "/inbox.org") "Bookmarks")
         "* TODO %:description\n  :PROPERTIES:\n  :CREATED: %U\n  :END:\n  %c\n\n  %i"
         :prepend t :empty-lines 1 :immediate-finish t)

## For Alfred Power Pack User

### Installation

- Link the directory directly: `make link`.
- Create a package and import it: `make install`.
- Download [org-protocol.alfredworkflow](#) and import it.

### Configuration

-   Set the keyboard shortcut
-   Double click "Run Script", and change `EMACSCLIENT` there.
-   If you don't want to install "Feedly" as a Fluid app template, double click
    "Run Script", then "open workflow folder". Update "Feedly" in
    `capture.applescript` in the folder.
-   Create an `org-capture` template using key "b", it's better to set `:immediate-finish`

        ("b" "org-protocol" entry (file+headline (concat org-directory "/inbox.org") "Bookmarks")
         "* TODO %:description\n  :PROPERTIES:\n  :CREATED: %U\n  :END:\n  %c\n\n  %i"
         :prepend t :empty-lines 1 :immediate-finish t)

## Support Applications

- Finder
- Path Finder
- DEVONthink Pro
- Google Chrome
- Chromium
- Fluid Apps (require creating a Fluid app with name "Feedly")
- Mail
- Contacts
