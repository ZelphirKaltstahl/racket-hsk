#lang racket

;; ==============
;; PREDEFINITIONS
;; ==============
(define (Mb-to-B n) (* n 1024 1024))
(define MAX-BYTES (Mb-to-B 128))
(define nil '())
(custodian-limit-memory (current-custodian) MAX-BYTES)

;; =======================
;; PROVIDING AND REQUIRING
;; =======================
(provide/contract
 (start (-> request? response?)))

(require web-server/templates
         web-server/servlet-env
         web-server/servlet
         web-server/dispatch
         racket/date
         "response.rkt"
         "render-base.rkt"
         "overview-app.rkt"
         "hsk-app.rkt")
;; ====================
;; ROUTES MANAGING CODE
;; ====================
(define (start request)
  ;; for now only calling the dispatch
  ;; we could put some action here, which shall happen before each dispatching
  (hsk-dispatch request))

(define-values (hsk-dispatch a-url)
  (dispatch-rules [("") #:method "get" overview-app]
                  [("index") #:method "get" overview-app]
                  [("home") #:method "get" overview-app]
                  [("hsk") #:method "get" hsk-app]
                  [("ajax" "hsk-1-data") #:method "get" hsk-1-data]
                  [("ajax" "hsk-2-data") #:method "get" hsk-2-data]
                  [("ajax" "hsk-3-data") #:method "get" hsk-3-data]
                  [("ajax" "hsk-4-data") #:method "get" hsk-4-data]
                  [("ajax" "hsk-5-data") #:method "get" hsk-5-data]
                  [("ajax" "hsk-6-data") #:method "get" hsk-6-data]))

;; This procedure is still here, because it belongs to the main functionality of the whole page, to display a page, when something could not be found.
(define (respond-unknown-file req)
  (make-response #:code 404
                 #:message #"ERROR"
                 (render-base-page #:content "unknown route"
                                   #:page-title "unknown route")))

;; ===========================
;; ADDED FOR RUNNING A SERVLET
;; ===========================
(serve/servlet
  start
  #:servlet-path "/index"  ; default URL
  #:extra-files-paths (list (build-path (current-directory) "static"))  ; directory for static files
  #:port 8000 ; the port on which the servlet is running
  #:servlet-regexp #rx""
  #:launch-browser? false  ; should racket show the servlet running in a browser upon startup?
  ;; #:quit? false  ; ???
  #:listen-ip false  ; the server will listen on ALL available IP addresses, not only on one specified
  #:server-root-path (current-directory)
  #:file-not-found-responder respond-unknown-file)

;; from the Racket documentation:
;; When you use web-server/dispatch with serve/servlet, you almost always want to use the #:servlet-regexp argument with the value "" to capture all top-level requests. However, make sure you don’t include an else in your rules if you are also serving static files, or else the filesystem server will never see the requests.
;; https://docs.racket-lang.org/web-server/dispatch.html
