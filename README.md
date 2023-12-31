# xmlstarlet-mode #

Minor mode providing XPath querying and XML formatting via the
[xmlstarlet](https://xmlstar.sourceforge.net/docs.php) command line
utility.

Adds the following keybindings

| Keybinding         | Feature     | With <kbd>C-u</kbd> prefix argument               |
|--------------------|-------------|---------------------------------------------------|
| <kbd>C-c C-c</kbd> | Runs XPath query and displays results in the `*XPath-Result*` buffer | Displays results in text mode instead of nxml mod |
| <kbd>C-c f</kbd>   | Formats XML and displays in the `*xml-format*` buffer  | Replaces current buffer contents                  |

## Installation ##

1. Install [XMLStarlet](https://xmlstar.sourceforge.net/download.php) and make it available from on the `PATH`
2. Clone the repo to `site-lisp` directory
3. Add to `load-path`

    ```emacs-lisp
    (add-to-list
    	'load-path
    	(expand-file-name "site-lisp/xmlstarlet-mode" user-emacs-directory))
    ```

4. Load & configure

	```emacs-lisp
	(require 'xmlstarlet-mode)
	(setq xmlstarlet-command "xmlstarlet")
	```
