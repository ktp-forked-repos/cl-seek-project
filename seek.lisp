;;;; Last modified : 2013-02-21 21:39:14 tkych

;; cl-project-search/seek.lisp


;;====================================================================
;; Seek
;;====================================================================

(In-package #:cl-project-search)


(defparameter *output-description-p* t)
(defparameter *output-url-p* t)

;; !! TODO !! add search-space: bitbucket, google-code
;; !! TODO !! pprint: *display-col-max-num-chars*
;; !! TODO !! limit output num:
;;            *display-max-num-projects*, if over limit, y-or-n?
(defun seek (search-word &key (web? t) (description? nil) (url? nil)
                              (cliki? t) (github? t) (quicklisp? t))
  "Search for cl project with SEARCH-WORD in Quicklisp, Cliki, Github-Repos.
SEARCH-WORD must be string or symbol (symbol will be converted to downcase-string).

If WEB? is NIL, not search in Cliki and Github-Repos.
If QUICKLISP? is NIL, not search in Quicklisp (also CLIKI?, GITHUB?).
At least one search-space must be specified.

If DESCRIPTION? is T, display project's description (except for Quicklisp-search).
If URL? is T, display project's url (except for Quicklisp-search).

N.B.
 * #\\Space in SEARCH-WORD:
   In case search-word contains #\\Space, Quicklisp-search is OR-search,
   whereas Cliki,Github-search is AND-search.

   e.g. (seek \"foo bar\")
        quicklisp-search for \"foo\" OR \"bar\",
        cliki,github-search for \"foo\" AND \"bar\".

 * Max number of search result:
   Quicklisp-search - not limited,
   Github-search - 100,
   Cliki-search  -  50."
  (unless (or (stringp search-word) (symbolp search-word))
    (error "~S is not strings or symbols." search-word))
  (unless (or quicklisp?
              (and web? (or cliki? github?)))
    (error "There is no search-space."))
  (let ((found? nil)
        (*output-url-p* url?)
        (word-string
         (write-to-string search-word :case :downcase :escape nil)))
    (format t "~&SEARCH-RESULT: ~S~%" word-string)
    (when (and quicklisp? (search-quicklisp word-string))
      (setf found? t))
    (when web?
      (let ((drakma:*drakma-default-external-format* :utf-8)
            (*output-description-p* description?))
        (when (and cliki? (search-cliki word-string))
          (setf found? t))
        (when (and github? (search-github word-string))
          (setf found? t))))
    (terpri)
    found?))

;;--------------------------------------
(defun search-quicklisp (word-string)
  (let ((found? nil))
    (dolist (wd (ppcre:split " " word-string))
      (awhen (search-ql-systems wd)
        (unless found?
          (format t "~% SEARCH-SPACE: Quicklisp~%")
          (setf found? t))
        (output-ql-results it)))
    found?))

(defun search-ql-systems (word-string)
  (loop :for system :in (ql-dist:provided-systems t)
        :when (or (search word-string (ql-dist:name system))
                  (search word-string
                          (ql-dist:name (ql-dist:release system))))
        :collect system))

(defun output-ql-results (systems)
  (dolist (system systems)
    (format t "~&  ~A" (ql-dist:name system))
    ;; (when *output-url-p*
    ;;   (format t "~%      "
    ;;           ))
    ;; (when *output-description-p*
    ;;   (format t "~%      ~A"
    ;;           (ql-dist:short-description system)))
    (terpri)))


;;--------------------------------------
(defun gen-cliki-query (word-string)
  (format nil "http://www.cliki.net/site/search?query=~A"
          (ppcre:regex-replace-all " " word-string "+")))

(defun search-cliki (word-string)
  (let* ((query   (gen-cliki-query word-string))
         (res     (drakma:http-request query))
         (results (extract-cliki-results res)))
    (when results
      (format t "~% SEARCH-SPACE: Cliki~%")
      (output-cliki-results results)
      (awhen (extract-cliki-next-query res)
        (loop :for q :in it
              :for r := (drakma:http-request q)
              :do (output-cliki-results (extract-cliki-results r))))
      (terpri)
      t)))

(defun extract-cliki-results (res)
  (let ((<li>s (ppcre:all-matches-as-strings "(?s)<li>(.+?)</li>"
                 (ppcre:scan-to-strings
                  "(?s)<ol start=.+?>(.+?)</ol>" res))))
    (when <li>s
      (iter (for <li> :in <li>s)
            (ppcre:register-groups-bind (url title description)
                ("(?s)<li><a href=\"(.+?)\" class=\"internal\">(.+?)</a>\\s?<br\\s?/?>(.+?)</li>"
                 <li>)
              (collect (list title
                             (when *output-url-p*
                               url)
                             (when *output-description-p*
                               (strip (remove-tags description))))))))))

(defun strip (string)
  (string-trim '(#\Space #\Return #\Newline) string))

(defun remove-tags (string)
  (ppcre:regex-replace-all "(<.+?>)" string ""))

(defun output-cliki-results (results)
  (loop :for (title url description) :in results
        :do (format t "~&  ~A" (html-entities:decode-entities title))
            (when *output-url-p*
              (format t "~%      http://www.cliki.net~A" url))
            (when *output-description-p*
              (format t "~%      ~A"
                      (html-entities:decode-entities description)))))

(defparameter *cliki-max-page-num* 5)

(defun extract-cliki-next-query (res)
  (let ((acc nil)
        (paginator (ppcre:scan-to-strings
                    "(?s)<div id=\"paginator\">(.+?)</div>" res)))
    (ppcre:do-register-groups (query)
        ("<a href=\"\\\?query=(.+?)\">" paginator)
      (push (gen-cliki-query query) acc))
    (let ((querys (nreverse (rest acc))));first and last is the same.
      (subseq querys 0 (min *cliki-max-page-num* (length querys))))))

;;--------------------------------------
;; drakma's default url-encoder does not support %encoding.
;; e.g. in url, want "Common Lisp" -> "Common%20Lisp"
;;              but  "Common Lisp" -> error
;;                   "Common+Lisp" -> "Common%2BLisp"
;;                   "Common%20Lisp" -> "Common%2520Lisp"
;; so, (do-urlencode:urlencode search-word) in gen-github-query
;;     (drakma:http-request query :preserve-uri t) in search-github

(defun gen-github-query (search-word)
  (format nil "https://api.github.com/legacy/repos/search/~A~
               ?language=Common%20Lisp"
          (do-urlencode:urlencode search-word)))

;; !! TODO !! max num result is 100. <- github api-v3
;;            How to know there exists results more than 100?
(defun search-github (search-word)
  (let* ((query (gen-github-query search-word))
         (res   (drakma:http-request query :preserve-uri t))
         (jason (yason:parse (flexi-streams:octets-to-string
                              res :external-format :utf-8)))
         (repos (gethash "repositories" jason)))
    (when repos
      (format t "~% SEARCH-SPACE: Github-Repos~%")
      (dolist (repo repos)
        (unless (gethash "fork" repo)   ;only master is displayed
          (format t "~&  ~A" (gethash "name" repo))
          (when *output-url-p*
            (format t "~%      https://github.com/~A/~A"
                     (gethash "username" repo) (gethash "name" repo)))
          (awhen (and *output-description-p*
                      (gethash "description" repo))
            (format t "~%      ~A" it))))
      t)))


;;====================================================================
