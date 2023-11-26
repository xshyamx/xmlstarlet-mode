;;; xmlstarlet-mode.el --- XML format & XPath        -*- lexical-binding: t; -*-

(defgroup xmlstarlet nil
  "Group for XMLStarlet minor mode customizations"
  :prefix 'xmlstarlet
  :group 'xml)

(defcustom xmlstarlet-command "xml"
  "Path to the XMLStarlet command line utility"
  :type 'string
  :group 'xmlstarlet)

(defcustom xmlstarlet-xpath-format-xml t
  "Format XPath XML results"
  :type 'boolean
  :group 'xmlstarlet)

(defconst xmlstarlet-xml-format-process "xml-format"
  "Process name for formatting xml")

(defconst xmlstarlet-xml-format-buffer "*xml-format*"
  "Buffer name for formatting xml")

(defconst xmlstarlet-xpath-process-name "xpath"
  "Name for the XPath process")

(defconst xmlstarlet-xpath-buffer-name "*XPath-Result*"
  "Buffer name to display the XPath results")

(defconst xmlstarlet-xpath-process-buffer "*xpath*"
  "Buffer name for the Xpath process")

(defun xmlstarlet-format-cmd ()
  (list
   (executable-find xpath-command)
   "fo"))

(defun xmlstarlet-xpath-cmd (xpath &optional is-value)
  (list
   (executable-find xpath-command)
   "sel"
   (if is-value "" "-R") ; add root element
   (if (and (not is-value) xpath-format-xml) "-I" "")
   "-t"
   (if is-value "-v" "-c")
   xpath))

(defun xmlstarlet--xml-format-buffer-sentinel (ps status)
  (if (and (string= "finished\n" status)
	   (memq (process-status ps) '(exit signal)))
      (when-let (tsb (process-get ps :target-buffer))
	(let ((psb (process-buffer ps)))
	  (with-current-buffer tsb
	    (erase-buffer)
	    (insert-buffer-substring-no-properties psb 1 (buffer-size psb))
	    (nxml-mode)
	    (goto-char (point-min)))
	  (kill-buffer psb))
	(unless (eql (current-buffer) tsb)
	  (switch-to-buffer-other-window tsb)))
    (display-buffer (process-buffer ps))))


(defun xmlstarlet-xml-format-buffer (prefix)
  "Formats current buffer contents with XMLStarlet command"
  (interactive "p")
  (let ((obuf (generate-new-buffer xml-format-buffer))
	(ps))
    ;(message "Starting %s" (string-join (xmlstarlet-format-cmd) " "))
    (setq ps (make-process
	      :name xml-format-process
	      :buffer obuf
	      :command (xmlstarlet-format-cmd)
	      :connection-type 'pipe))
    (process-send-region ps (point-min) (point-max))
    (process-put ps :target-buffer (if (eql 4 prefix) (current-buffer)
				     (get-buffer-create xml-format-buffer)))
    (process-send-eof ps)
    (set-process-sentinel ps #'xmlstarlet--xml-format-buffer-sentinel)))

(defun xmlstarlet--xpath-query-sentinel (ps status)
  (if (and (string= "finished\n" status)
	   (memq (process-status ps) '(exit signal)))
      (when-let (tsb (process-get ps :target-buffer))
	(let ((psb (process-buffer ps)))
	  (with-current-buffer tsb
	    (erase-buffer)
	    (insert-buffer-substring-no-properties psb 1 (buffer-size psb))
	    (if (process-get ps :is-value)
		(text-mode)
	      (nxml-mode))
	    (goto-char (point-min))
	    )
	  (kill-buffer psb))
	(unless (eql (current-buffer) tsb)
	  (switch-to-buffer-other-window tsb)))
    (display-buffer (process-buffer ps))))

(defun xmlstarlet-xpath-query-buffer (xpath)
  "Runs XPath query on the current buffer"
  (interactive "sXPath: ")
  (let ((obuf (generate-new-buffer xpath-process-buffer))
	(ps))
    ;(message "Starting %s" (string-join (xpath-xmlstarlet-cmd xpath current-prefix-arg) " "))
    (setq ps (make-process
	      :name xpath-process-name
	      :buffer obuf
	      :command (xpath-xmlstarlet-cmd xpath current-prefix-arg)
	      :connection-type 'pipe))
    (process-send-region ps (point-min) (point-max))
    (process-put ps :target-buffer (get-buffer-create xpath-buffer-name))
    (process-put ps :is-value current-prefix-arg)
    (process-send-eof ps)
    (set-process-sentinel ps #'xmlstarlet--xpath-query-sentinel)))

(define-minor-mode xmlstarlet-mode
  "Provide XML formatting & XPath querying using the XMLStarlet
command line utility"
  :lighter " XS"
  (define-key nxml-mode-map (kbd "C-c C-c") #'xmlstarlet-xpath-query-buffer)
  (define-key nxml-mode-map (kbd "C-c f") #'xmlstarlet-xml-format-buffer))

;;;###autoload
(add-hook nxml-mode-hook #'xmlstarlet-mode)

(provide 'xmlstarlet-mode)
;;; xmlstarlet-mode.el -- Ends here
