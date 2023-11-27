# xmlstarlet-mode #

Minor mode providing XPath querying and XML formatting via the
[xmlstarlet](https://xmlstar.sourceforge.net/docs.php) command line
utility.

Adds the following keybindings

| Keybinding         | Feature     |
|--------------------|-------------|
| <kbd>C-c C-c</kbd> | XPath query |
| <kbd>C-c f</kbd>   | Format XML  |

**NOTE**: Use <kbd>C-u C-c f</kbd> to replace current buffer contents
with formatted XML

## Installation ##

1. Install [XMLStarlet](https://xmlstar.sourceforge.net/download.php) and make it available from on the ~PATH~
2. Clone the repo to ~site-lisp~ directory
3. Add to ~load-path~

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
