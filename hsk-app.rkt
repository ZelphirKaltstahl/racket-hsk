#lang racket

(require "hash-procedures.rkt"
         "render-base.rkt"
         "response.rkt"
         "data.rkt"
         "vocabulary.rkt")
(provide (all-defined-out))


(define (hsk-app request)
  (send-success-response
   (render-hsk-page)))

(define (hsk-1-data request)
  (send-json-response HSK-1-STRING))
(define (hsk-2-data request)
  (send-json-response HSK-2-STRING))
(define (hsk-3-data request)
  (send-json-response HSK-3-STRING))
(define (hsk-4-data request)
  (send-json-response HSK-4-STRING))
(define (hsk-5-data request)
  (send-json-response HSK-5-STRING))
(define (hsk-6-data request)
  (send-json-response HSK-6-STRING))

;; ===============
;; RENDERING STUFF
;; ===============
(define (render-hsk-page)
  (render-base-page #:page-title "HSK-1"
                    #:special-css-imports (list "/css/hiding.css")
                    #:special-js-imports (list "/js/main.js")
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
                       (div ((class "float-right-container"))
                            (div ((class "hanzi-hide-container"))
                                 ,@(render-hanci (word-simplified a-word))))))

               (tr (td ((class "latinletters-cell"))
                       (div (p ((class "word-attribute-label"))
                               ,"Pīnyīn:")
                            (p ,(word-pinyin a-word))))
                   (td ((class "hanci-cell"))
                       (div ((class "float-right-container"))
                            (div ((class "hanzi-hide-container"))
                                 ,@(render-hanci (word-traditional a-word))))))

               (tr (td (p ((class "word-id-label"))
                          ,(string-append "id: "
                                          (word-id a-word))))
                   (td (div ((class "float-right-container"))
                            (img ((class "word-controls-image") (src "/img/word-explain.svg")))
                            (img ((class "word-controls-image") (src "/img/word-not-memorized.svg")))
                            (img ((class "word-controls-image") (src "/img/word-memorized.svg")))))))))

(define (render-words-list words-list)
  `(div ((class "content-container"))
        #;(div ((class "words-container"))
             ,@(map render-word-table words-list))))

(define (render-hsk-1)
  `(div ((class "content-container"))
        (h1 "HSK 1")
        (noscript (div ((class "words-container"))
                       ,@(map render-word-table (vocabulary-words-list HSK-1))))))
