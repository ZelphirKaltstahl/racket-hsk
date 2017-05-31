#lang racket

(require
  web-server/servlet-env
  web-server/servlet)

(provide (all-defined-out))

(define (make-response #:code [code 200]
                       #:message [message #"OK"]
                       #:seconds [seconds (current-seconds)]
                       #:mime-type [mime-type TEXT/HTML-MIME-TYPE]
                       #:headers [headers (list (make-header #"Cache-Control" #"no-cache"))]
                       content)
  (response/full code
                 message
                 seconds
                 mime-type
                 headers
                 (list (string->bytes/utf-8 content))))

(define (send-success-response rendered-page)
  (make-response rendered-page))

(define (send-json-response json)
  (make-response #:mime-type #"application/json"
                 json))
