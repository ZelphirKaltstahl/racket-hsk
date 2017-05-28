#lang racket

(require json)
(provide HSK-1 HSK-2 HSK-3 HSK-4 HSK-5 HSK-6)

(define (read-json-file a-path)
  (call-with-input-file a-path read-json))

#; (define (read-yaml-file a-path)
  (let ([a-port (open-input-file a-path)])
    (yaml-load a-port)))

(define HSK-1 (read-json-file "data/hsk-1.json"))
(define HSK-2 (read-json-file "data/hsk-2.json"))
(define HSK-3 (read-json-file "data/hsk-3.json"))
(define HSK-4 (read-json-file "data/hsk-4.json"))
(define HSK-5 (read-json-file "data/hsk-5.json"))
(define HSK-6 (read-json-file "data/hsk-6.json"))

;; (define HSK-1-YAML (read-yaml-file "data/vocabulary/hsk-1.yaml"))
;; (define HSK-2-YAML (read-yaml-file "data/vocabulary/hsk-2.yaml"))
;; (define HSK-3-YAML (read-yaml-file "data/vocabulary/hsk-3.yaml"))
;; (define HSK-4-YAML (read-yaml-file "data/vocabulary/hsk-4.yaml"))
;; (define HSK-5-YAML (read-yaml-file "data/vocabulary/hsk-5.yaml"))
;; (define HSK-6-YAML (read-yaml-file "data/vocabulary/hsk-6.yaml"))
