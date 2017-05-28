#lang racket

(require "render-base.rkt"
         "response.rkt")
(provide (all-defined-out))

(define (overview-app request)
  (send-success-response
   (render-overview-page)))

(define (render-overview-page)
  (render-base-page #:page-title "Overview"))
