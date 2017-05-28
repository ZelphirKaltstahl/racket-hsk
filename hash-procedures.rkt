#lang racket

(provide (all-defined-out))

(define (my-hash-map h f)
  (make-immutable-hash
   (hash-map h
             (lambda (k v) (f k v)))))

(define (nested-hash-get a-hash . keys)
  (cond
    [(empty? keys) a-hash]
    [else
     (apply nested-hash-get
            (hash-ref a-hash (first keys))
            (rest keys))]))
