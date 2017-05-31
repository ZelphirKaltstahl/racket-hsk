#lang racket

(require xml
         xml/xexpr)
(provide (all-defined-out))

(define DOCTYPE-HTML5 "<!DOCTYPE html>")

(define (xexpr->xml/pretty x)
  (string-trim
   (with-output-to-string
     (lambda ()
       (display-xml/content (xexpr->xml x))))))

(define (render-base-page
         #:content [content "NO CONTENT"]
         #:page-title [page-title "NO TITLE"]
         #:default-css-imports [default-css-imports (list "/css/general.css")]
         #:special-css-imports [special-css-imports empty]
         #:default-js-imports [default-js-imports
                                (list "https://code.jquery.com/jquery-3.2.1.min.js"
                                      "https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.5.2/underscore-min.js")]
         #:special-js-imports [special-js-imports empty]
         #:ajax [ajax empty]
         #:header [header ""]
         #:footer [footer ""]
         #:navigation [navigation ""])
  #| This procedure takes some typical website parameters and returns a string
  containing the HTML code as string for a page. |#
  #;(string-append DOCTYPE-HTML5
                 "\n"
                 (xexpr->string
                  `(html
                    (body ((bgcolor "red"))
  "Hi!" (br) "Bye!"))))
  (string-append DOCTYPE-HTML5
                 "\n\n"
                 (xexpr->xml/pretty
                  `(html
                    ,(render-head page-title
                                  default-css-imports
                                  special-css-imports
                                  default-js-imports
                                  special-js-imports
                                  ajax)
                    ,(render-body content
                                  header
                                  footer
                                  navigation)))))

(define (render-head page-title
                     default-css-imports
                     special-css-imports
                     default-js-imports
                     special-js-imports
                     ajax)
  #| This procedure renders the HTML head.
  page-title         : is supposed to be only the title as a string, not string with tag
  css and js imports : lists of paths to CSS and JS files
  ajax               : string containing the AJAX code |#
  `(head
    (title ,page-title)
    (meta ((http-equiv "Content-Type") (content "text/html; charset=utf-8")))  ; always utf-8
    ,@(map render-css-import default-css-imports)
    ,@(map render-css-import special-css-imports)
    ,@(map render-js-import default-js-imports)
    ,@(map render-js-import special-js-imports)
    ,@(map render-js-inline ajax)))

(define (render-body content header footer navigation)
  `(body ,header
         ,navigation
         ,content
         ,footer))

(define (render-css-import css-path)
  `(link ((rel "Stylesheet")
          (href ,css-path)
          (type "text/css")
          (media "screen"))))
(define (render-js-import js-path)
  `(script ((type "text/javascript")
            (src ,js-path))))

(define (render-css-inline css-code-string)
  `(style ((type "text/css"))
     ,css-code-string))
(define (render-js-inline js-code-string)
  `(script ((type "text/javascript"))
           ,js-code-string))
