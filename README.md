Last modified : 2013-01-12 13:52:01 tkych

Version: 0.1.00 (beta)


CL-PROJECT-SEARCH - search in Quicklisp, Cliki, Github-Repos
============================================================

Introduction
------------

CL-PROJECT-SEARCH is search-engine for Common Lisp.
The function SEARCH-PROJECT searches for CL project in Quicklisp, Cliki,
Github-Repos.


Examples
--------

```lisp
CL-REPL> (cl-project-search:search-project "prime")

SEARCH-RESULT: "prime"
  SEARCH-SPACE: Quicklisp
  cl-prime-maker
  SEARCH-SPACE: Cliki
  Araneida
; ...
  SEARCH-SPACE: Github-Repos
  Prime-World-Dno
  prime-pi-maxima
  cl-prime-maker
  primes
  cl-primality
; ...
=> T

CL-REPL> (cl-project-search:search-project
          "prime" :description? t)

SEARCH-RESULT: "prime"
  SEARCH-SPACE: Quicklisp
  cl-prime-maker
  SEARCH-SPACE: Cliki
  Araneida
      Araneida is a fairly small free extensible HTTP server for SBCL and many other Common Lisp implementations
; ...
  SEARCH-SPACE: Github-Repos
  Prime-World-Dno
      Строим графики на основе рейтингов в Prime World
  prime-pi-maxima
      prime counting function for maxima, the CAS
  cl-prime-maker
      A simple package to generate big prime numbers.
; ...
=> T

CL-REPL> (cl-project-search:search-project
          "prime" :url? t :description? t)

SEARCH-RESULT: "prime"
  SEARCH-SPACE: Quicklisp
  cl-prime-maker
  SEARCH-SPACE: Cliki
  Araneida
      http://www.cliki.net/Araneida
      Araneida is a fairly small free extensible HTTP server for SBCL and many other Common Lisp implementations
; ...
  SEARCH-SPACE: Github-Repos
  Prime-World-Dno
      https://github.com/hijarian/Prime-World-Dno
      Строим графики на основе рейтингов в Prime World
  prime-pi-maxima
      https://github.com/jlapeyre/prime-pi-maxima
      prime counting function for maxima, the CAS
  cl-prime-maker
      https://github.com/nakrakiiya/cl-prime-maker
      A simple package to generate big prime numbers.
=> T

CL-REPL> (cl-project-search:search-project
           'Supercalifragilisticexpialidocious)

SEARCH RESULT: "supercalifragilisticexpialidocious"
=> NIL
```    

Depends-on
----------

- anaphora
- iterate
- cl-ppcre
- drakma
- flexi-streams
- yason
- do-urlencode
- html-entities


Download & Install
------------------

0. `SHELL>   git clone https://github.com/tkych/cl-project-search.git`
1. `CL-REPL> (push #p"/path-to-cl-project-search/cl-project-search/" asdf:*central-registry*)`
2. `CL-REPL> (ql:quickload :cl-project-search)`


Referece Manual
---------------

#### [Function] SEARCH-PROJECT _search-word_ _&key_ _web?_ _description?_ _url?_ _cliki?_ _github?_ _quicklisp?_

Search for project with SEARCH-WORD in Quicklisp, Cliki, Github-Repos.
SEARCH-WORD must be strings or symbols (symbols will be converted to downcase-strings).
If WEB? is NIL, not search Cliki and Github-Repos.
If QUICKLISP? is NIL, not search Quicklisp (also CLIKI?, GITHUB?).
At least one search-space must be specified.
If DESCRIPTION? is T, display project's description (except for Quicklisp-search).
If URL? is T, display project's url (except for Quicklisp-search).

- Space in SEARCH-WORD:
  In case search-word contains space, Quicklisp-search is OR-search,
  whereas Cliki,Github-search is AND-search.
  e.g. (search-project "foo bar")
       quicklisp-searches "foo" OR "bar",
       cliki,github-searches "foo" AND "bar".

- Max number of search result:
  Quicklisp-search - not limited,
  Github-search - 100,
  Cliki-search  -  50.


TODO
----

- SEARCH-PROJECT: add search-space (bitbucket, google-code, etc.)
- SEARCH-PROJECT: pprint: for discription


Author
------

- Takaya Ochiai  <#.(reverse "moc.liamg@lper.hcykt")>


License
-------

- MIT License

