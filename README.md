Last modified : 2013-02-22 19:47:57 tkych

Version: 0.1.11 (beta)


CL-SEEK-PROJECT : Seek Project in Quicklisp, Cliki, Github
==========================================================

Introduction
------------

CL-SEEK-PROJECT is a search-engine-interface for Common Lisp.
The function SEEK searches for cl project in Quicklisp, Cliki, Github-Repos at REPL.


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

0. SHELL$   `git clone https://github.com/tkych/cl-seek-project.git`
1. CL-REPL> `(push #p"/path-to-cl-seek-project/cl-seek-project/" asdf:*central-registry*)`
2. CL-REPL> `(ql:quickload :cl-seek-project)`


Examples
--------

```lisp
CL-REPL> (use-package :cl-seek-project)
T

CL-REPL> (seek 'Supercalifragilisticexpialidocious)

SEARCH RESULT: "supercalifragilisticexpialidocious"
=> NIL

CL-REPL> (seek "graphviz")

SEARCH-RESULT: "graphviz"

 SEARCH-SPACE: Quicklisp
  com.informatimago.common-lisp.graphviz

 SEARCH-SPACE: Cliki
  cl-graphviz
  cl-dot
  clod
  graph-utils
  Grapher-Server
  s-dot

 SEARCH-SPACE: Github-Repos
  cl-graphviz
  donuts
  cl-dot
  motion-grammar-kit
  protocl
  sn-explorer
  compass
  graph-utils
  wo-git-gui

=> T

CL-REPL> (seek "graphviz" :description? t :cliki? nil)

SEARCH-RESULT: "graphviz"

 SEARCH-SPACE: Quicklisp
  com.informatimago.common-lisp.graphviz

 SEARCH-SPACE: Github-Repos
  cl-graphviz
      Adaptaion of an outdated cl-graphviz by Attila Lendvai to the modern version of libgvc.so.6.
  donuts
      Graph Drawing DSL (or Graphviz Interface) for Common Lisp.
  cl-dot
      Common Lisp package for generating GraphViz (dot) files
  motion-grammar-kit
      Formal Language Tools for Robots
  protocl
      Native Common Lisp compiler infrastructure for Google's protocol buffers
  sn-explorer
      A simple web crawler for social networks
  compass
      Recursive, k-width tree clusterer based on the Cardinal Directions
  graph-utils
      graph analysis tools
  wo-git-gui
      WebGUI for git commit graphs, will mainly focus on trying to reduce the commit graph into manageable overviews

=> T

CL-REPL> (seek "graphviz" :url? t :description? t :github? nil :quicklisp? nil)

SEARCH-RESULT: "graphviz"

 SEARCH-SPACE: Cliki
  cl-graphviz
      http://www.cliki.net/cl-graphviz
      cl-graphviz is a CFFI interface to graphviz with cl-graph integration
  cl-dot
      http://www.cliki.net/cl-dot
      CL-DOT is a library for easily generating dot (Graphviz) output from arbitrary Lisp data
  clod
      http://www.cliki.net/clod
      CLOD is a Common Lisp doc-generator, similar to Albert, Cldoc and so on
  graph-utils
      http://www.cliki.net/graph-utils
      graph-utils:  graph analysis utilities for Common Lisp
  Grapher-Server
      http://www.cliki.net/Grapher-Server
      Grapher-Server is an AJAX application combining AllegroServe, CL-Graph and GraphViz by Gary King
  s-dot
      http://www.cliki.net/s-dot
      S-Dot by Martin Loetzsch is a Common Lisp interface to the 'dot' tool of the GraphViz graphics library

=> T
```    


Referece Manual
---------------

#### [Function] SEEK _search-word_ _&key_ _web?_ _description?_ _url?_ _cliki?_ _github?_ _quicklisp?_

Search for cl project with _search-word_ in Quicklisp, Cliki, Github-Repos.
_search-word_ must be string or symbol (symbol will be converted to downcase-string).
If _web?_ is NIL, not search Cliki and Github-Repos.
If _quicklisp?_ is NIL, not search Quicklisp (also _cliki?_, _github?_).
At least one search-space must be specified.
If _description?_ is T, display project's description (except for Quicklisp-search).
If _url?_ is T, display project's url (except for Quicklisp-search).

- Space in _search-word_:
  If _search-word_ contains #\space, Quicklisp-search is OR-search,
  whereas Cliki,Github-search is AND-search.
  e.g. (seek "foo bar")
       quicklisp-searches    - "foo" OR "bar"
       cliki,github-searches - "foo" AND "bar"

- Max number of search result:
  Quicklisp - unlimited
  Github    - 100
  Cliki     - 50


TODO
----

- SEARCH-PROJECT: add search-space (bitbucket, google-code, etc.)
- SEARCH-PROJECT: pprint: for discription


Author, License, Copyright
--------------------------

* Takaya Ochiai  <#.(reverse "moc.liamg@lper.hcykt")>

* MIT License

* Copyright (C) 2013 Takaya Ochiai
