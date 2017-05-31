#lang racket

(require)

(provide ajax)

(define (my-hash-map a-proc a-hash)
  (hash-map a-hash
            (lambda (a-key a-value)
              (a-proc a-key a-value))))

(define (x-string a-string times)
  (define (iter remaining-times result)
    (cond [(> remaining-times 0)
           (iter (- remaining-times 1)
                 (string-append a-string result))]
          [else
           result]))
  (iter times ""))

(define (ajax handler-url
              dom-element-selector
              #:event-type [event-type "click"]
              #:server-side-procedure [server-side-procedure
                                       (lambda ()
                                         (displayln "Route requested!"))]
              #:method [method "POST"]
              #:request-data [request-data (hash)]
              #:target-selector [target-selector false]
              #:prettify [prettify false])

  (define (cnl [times 1])
    (if prettify (x-string "\n" times) ""))

  (define (ct [times 1])
    (if prettify (x-string "    " times) ""))

  (define (hash->json a-hash)
    (string-join
     (my-hash-map
      (lambda (a-key a-value)
        (string-append (ct)(ct)(ct) "'" a-key "'" ": " a-value "," (cnl)))
      request-data) ""))

  (define (insert-into-target target result-var-name)
    (if target
        (string-append "$('" target "').html(" (cnl)
                       (ct 3) result-var-name (cnl)
                       (ct 2) ");" (cnl))
        ""))

  (define EVENT-VAR-NAME "event")
  (define AJAX-RESULT-VAR-NAME "result")
  (define EVENT-HANDLED "false")
  (define EVENT-NOT-HANDLED "false")

  (string-append "$('" dom-element-selector "')"
                 ".on('" event-type "', function(" EVENT-VAR-NAME ") {" (cnl)
                 (ct) "$.ajax({" (cnl)
                 (ct 2) "url: '" handler-url "', " (cnl)
                 (ct 2) "type: '" method "', " (cnl)
                 (ct 2) "data: {" (cnl)
                 (hash->json request-data)
                 (ct 2) "}, " (cnl)
                 (ct 2) "dataType: 'html'," (cnl)
                 (ct) "})" (cnl)

                 (ct) ".done(function(" AJAX-RESULT-VAR-NAME "){" (cnl)
                 (ct 2) "console.log('AJAX request successful!');" (cnl)
                 ;; res is xml result which needs to be inserted at the correct place
                 (ct 2) (insert-into-target target-selector AJAX-RESULT-VAR-NAME)
                 (ct) "})" (cnl)
                 (ct) ".fail(function(" AJAX-RESULT-VAR-NAME ") {" (cnl)
                 (ct 2) "console.log('AJAX request failed!');" (cnl)
                 (ct) "})" (cnl)
                 (ct) ".always(function(" AJAX-RESULT-VAR-NAME ") {" (cnl)
                 (ct 2) "console.log('AJAX request finished. (success / failure)');" (cnl)
                 (ct) "});" (cnl)
                 (ct) "return " EVENT-HANDLED ";" (cnl)
                 "});" (cnl)))
