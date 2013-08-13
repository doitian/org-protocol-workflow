# org-protocol workflow #

## Usage

Use your favorite shortcut manager to add a binding to run `main.sh` in **this directory**.

## Config

-   `emacsclient`: default is `/usr/local/bin/emacsclient`. Update `CONFIG_EMACSCLIENT` directly

        CONFIG_EMACSCLIENT=/Applications/Emacs.app/

    , or set environment variable `EMACSCLIENT`

        export EMACSCLIENT=/Applications/Emacs.app/Contents/MacOS/bin/emacsclient
        ./main.sh

-   `browser`: default is `Google Chrome`. Update `CONFIG_BROWSER` directly

        CONFIG_BROWSER='Safari'

    , or set environment variable `BROSWER`

        export BROWSER='Safari'
        ./main.sh

-   Fluid: It is assumed that you have created an App with name "Feedly" using Fluid. If you don't want to install Feedly as an Fluid app, change it in `capture.applescript`

## Emacs

-   Create an `org-capture` template using key "b", it's better to set `:immediate-finish`

        ("b" "org-protocol" entry (file+headline (concat org-directory "/inbox.org") "Bookmarks")
         "* TODO %:description\n  :PROPERTIES:\n  :CREATED: %U\n  :END:\n  %c\n\n  %i"
         :prepend t :empty-lines 1 :immediate-finish t)

-   Add `org-mac-link-grabber` into `org-modules`. 

        ;; If you have other modules in `org-modules', append these two to existing list.
        (custom-set-variables '(org-modules '(org-protocol org-mac-link-grabber)))

    or just require it

        (require 'org-mac-link-grabber)

-   Add customer link protocol in org:

        (defun org--call-process-open (path)
          "Open PATH using system open command."
          (call-process "open" nil nil nil path))

        (org-add-link-type "open" 'org--call-process-open)

## For Alfred Power Pack User

### Installation

- Link the directory directly: `make link`.
- Create a package and import it: `make install`.
- Download [org-protocol.alfredworkflow](https://github.com/doitian/org-protocol-workflow/releases/download/v1.0.1/org-protocol.alfredworkflow) and import it.

### Configuration

-   Set the keyboard shortcut
-   Double click "Run Script", and change `EMACSCLIENT` there.
-   If you don't want to install "Feedly" as a Fluid app template, double click
    "Run Script", then "open workflow folder". Update "Feedly" in
    `capture.applescript` in the folder.
-   Setup Emacs the same as above

## Support Applications

- Finder
- Path Finder
- DEVONthink Pro
- Google Chrome
- Chromium
- Fluid Apps (require creating a Fluid app with name "Feedly")
- Mail
- Contacts
- Dash
