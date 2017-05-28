#lang racket

(require "hash-procedures.rkt"
         "render-base.rkt"
         "response.rkt"
         "data.rkt"
         "vocabulary.rkt")
(provide (all-defined-out))


(define (hsk-1-app request)
  (send-success-response
   (render-hsk-1-page)))

;; ===============
;; RENDERING STUFF
;; ===============
(define (render-hsk-1-page)
  (render-base-page #:page-title "HSK-1"
                    #:default-css-imports (list "/css/general.css")
                    #:special-css-imports (list "/css/hiding.css")
                    #:content (render-hsk-1)))


(define (render-hanci hanci)
  (define (render-hanzi hanzi)
    `(div ((class "hanzi-container"))
          (p ((class "hanzi"))
             ,hanzi)))
  (map render-hanzi (map string (string->list hanci))))

(define (render-word-table a-word)
  `(div ((id ,(string-append "word-" (word-id a-word)))
         (class "word-table-container"))
        (table ((class "word-table"))
               (tr (td ((class "latinletters-cell"))
                       (div (p ((class "word-attribute-label"))
                               ,"English:")
                            (p ,(word-english a-word))))
                   (td ((class "hanci-cell"))
                       (div ((class "hanzi-hide-container"))
                            ,@(render-hanci (word-simplified a-word)))))

               (tr (td ((class "latinletters-cell"))
                       (div (p ((class "word-attribute-label"))
                               ,"Pīnyīn:")
                            (p ,(word-pinyin a-word))))
                   (td ((class "hanci-cell"))
                       (div ((class "hanzi-hide-container"))
                            ,@(render-hanci (word-traditional a-word)))))

               (tr (td (p ((class "word-id-label"))
                          ,(string-append "id: "
                                          (word-id a-word))))
                   (td (img ((src "")))
                       (img ((src "")))
                       (img ((src ""))))))))

(define (render-words-list words-list)
  `(div ((class "content-container"))
        (div ((class "words-container"))
             ,@(map render-word-table words-list))))

(define (render-hsk-1)
  (render-words-list (vocabulary-words-list HSK-1)))
