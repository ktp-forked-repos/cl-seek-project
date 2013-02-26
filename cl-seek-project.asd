;;;; Last modified : 2013-02-26 19:26:51 tkych

;; cl-seek-project/cl-seek-project.asd


;;====================================================================
;; CL-SEEK-PROJECT: in Quicklisp, Cliki, GitHub, BitBucket
;;====================================================================
;; cl-seek-project/
;;   cl-seek-project.asd
;;   core.lisp
;;   README.md
;;   LICENSE
;;   CHANGELOG


;;====================================================================
;; System for CL-SEEK-PROJECT
;;====================================================================

(in-package :cl-user)

(asdf:defsystem #:cl-seek-project
  :name        "cl-seek-project"
  :description "Seek for CL project in Quicklisp, Cliki, GitHub-Repos, BitBucket-Repos."
  :version     "0.1.13"
  :licence     "MIT License"
  :author      "Takaya Ochiai <tkych.repl@gmail.com>"
  :depends-on  (#:cl-ppcre #:iterate #:anaphora #:drakma
                #:flexi-streams #:yason #:do-urlencode #:html-entities)
  :serial      t
  :components  ((:file "core"))
  )

;;====================================================================
