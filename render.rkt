;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname render) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; LIBRARIES
(require racket/base)
(require 2htdp/image)
(require racket/format)
(require "data_structures.rkt")
(require "figures.rkt")

;*********************************************************************************
;*********************************************************************************
;; API
(provide render)

;*********************************************************************************
;*********************************************************************************
;;; CONVERSION CHUNK (low level)

;; Input/Output
; conversion-char: Appstate Char -> Image
; 
; header :
; (define (conversion-char appstate char) Image)

;; Examples
(check-expect (conversion-char INIT-APPSTATE #\.) SKIN-DOT)
(check-expect (conversion-char INIT-APPSTATE #\Y) SKIN-CHERRY)
(check-expect (conversion-char INIT-APPSTATE #\W) SKIN-WALL)
(check-expect (conversion-char INIT-APPSTATE #\P) SKIN-PACMAN-OPEN)
(check-expect (conversion-char INIT-APPSTATE #\r) SKIN-GHOST-RED)
(check-expect (conversion-char INIT-APPSTATE #\@) SKIN-PP)
(check-expect (conversion-char INIT-APPSTATE #\_) SKIN-GATE)

;; Template

;(define (conversion-char appstate char)
;  (cond
;    [(char=? char ...) ...]
;    [(char=? char ...) ...]
;    [(char=? char ...) ...]
;    [(char=? char ...) ...]
;    [(char=? char ...) (... appstate)]
;    [(char=? char ...) ...]
;    [(char=? char ...) ...]
;    [(or (char=? char ...)
;         (char=? char ....)
;         (char=? char ...)
;         (char=? char ...)) (... appstate char)]))


;; Code - used by (conversion-row)
(define (conversion-char appstate char)
  (cond
    [(char=? char MAP-EMPTY) SKIN-BG]
    [(char=? char MAP-WALL) SKIN-WALL]
    [(char=? char MAP-DOT) SKIN-DOT]
    [(char=? char MAP-PP) SKIN-PP]
    [(char=? char MAP-PACMAN) (conversion-pacman appstate)]
    [(char=? char MAP-CHERRY) SKIN-CHERRY]
    [(char=? char MAP-GATE) SKIN-GATE]
    [(or (char=? char MAP-GHOST-ORANGE)
         (char=? char MAP-GHOST-RED)
         (char=? char MAP-GHOST-PINK)
         (char=? char MAP-GHOST-CYAN)) (conversion-ghosts appstate char)]))

;*********************************************************************************
;; Input/Output
; conversion-pacman: Appstate -> Image
;the function takes an appstate and returns the image of pacman according to the direction he is facing and with his mouth open or close
;
; header :
; (define (conversion-pacman appstate) Image)

;; Examples
(define PAC-TEST1 (make-appstate (vector "WWWWWWW" "WW@W..." "YPcpro.")
                                 (make-pacman (make-character MAP-PACMAN DIRECTION-LEFT (make-posn 1 8)) #false)
                                 INIT-GHOSTS
                                 INIT-SCORE
                                 INIT-PP-ACTIVE
                                 INIT-QUIT))

(define PAC-TEST2 (make-appstate (vector "WWWWWWW" "WW@W..." "YPcpro.")
                                 (make-pacman (make-character MAP-PACMAN DIRECTION-LEFT (make-posn 1 8)) #true)
                                 INIT-GHOSTS
                                 INIT-SCORE
                                 INIT-PP-ACTIVE
                                 INIT-QUIT))

(define PAC-TEST3 (make-appstate (vector "WWWWWWW" "WW@W..." "YPcpro.")
                                 (make-pacman (make-character MAP-PACMAN DIRECTION-UP (make-posn 1 8)) #true)
                                 INIT-GHOSTS
                                 INIT-SCORE
                                 INIT-PP-ACTIVE
                                 INIT-QUIT))

(define PAC-TEST4 (make-appstate (vector "WWWWWWW" "WW@W..." "YPcpro.")
                                 (make-pacman (make-character MAP-PACMAN DIRECTION-DOWN (make-posn 1 8)) #true)
                                 INIT-GHOSTS
                                 INIT-SCORE
                                 INIT-PP-ACTIVE
                                 INIT-QUIT))

(check-expect (conversion-pacman INIT-APPSTATE) SKIN-PACMAN-OPEN)
(check-expect (conversion-pacman PAC-TEST1) SKIN-PACMAN-CLOSE)
(check-expect (conversion-pacman PAC-TEST2) (rotate 180 SKIN-PACMAN-OPEN))
(check-expect (conversion-pacman PAC-TEST3) (rotate -90 SKIN-PACMAN-OPEN))
(check-expect (conversion-pacman PAC-TEST4) (rotate 90 SKIN-PACMAN-OPEN))

;; Template

;(define (conversion-pacman appstate)
;  (local [(define direction (... (... appstate)))
;          (define pacman-mouth (... appstate))
;          (define pacman-skin (... pacman-mouth))]
;    (cond [(equal? ... direction) (... .... pacman-skin)]
;          [(equal? ... direction) (... .... pacman-skin)]
;          [(equal? ... direction) (... .... pacman-skin)]
;          [(equal? ... direction) (... .... pacman-skin)])))

;; Code - used by (conversion-char)
(define-values (UPWARDS DOWNWARDS LEFTWARDS RIGHTWARDS) (values -90 90 180 0))
(define (conversion-pacman appstate)
  (local [(define direction (character-direction (pacman-character (appstate-pacman appstate))))
          (define mouth (pacman-mouth (appstate-pacman appstate)))
          (define skin (conversion-pacman-mouth pacman-mouth))]
    (cond [(equal? DIRECTION-UP direction) (rotate UPWARDS skin)]
          [(equal? DIRECTION-DOWN direction) (rotate DOWNWARDS skin)]
          [(equal? DIRECTION-LEFT direction) (rotate LEFTWARDS skin)]
          [(equal? DIRECTION-RIGHT direction) (rotate RIGHTWARDS skin)])))

;*********************************************************************************
;; Input/Output
; conversion-pacman-mouth: pacman-mouth -> Image
;
; header :
; (define (conversion-pacman-mouth pacman-mouth) Image)

;; Examples
(check-expect (conversion-pacman-mouth (pacman-mouth (appstate-pacman PAC-TEST1))) SKIN-PACMAN-CLOSE)
(check-expect (conversion-pacman-mouth (pacman-mouth (appstate-pacman PAC-TEST2))) SKIN-PACMAN-OPEN)

;; Template

;(define (conversion-pacman-mouth pacman-mouth)
;  (if pacman-mouth ... ...))

;; Code - used by (conversion-pacman)
(define (conversion-pacman-mouth pacman-mouth)
  (if pacman-mouth SKIN-PACMAN-OPEN SKIN-PACMAN-CLOSE))

;*********************************************************************************
;; Input/Output
; conversion-ghosts: Appstate Char -> Image
;
; header :
; (define (conversion-ghosts appstate char) Image)

;; Examples
(check-expect (conversion-ghosts INIT-APPSTATE #\r) SKIN-GHOST-RED)
(check-expect (conversion-ghosts INIT-APPSTATE #\o) SKIN-GHOST-ORANGE)
(check-expect (conversion-ghosts INIT-APPSTATE #\p) SKIN-GHOST-PINK)
(check-expect (conversion-ghosts INIT-APPSTATE #\c) SKIN-GHOST-CYAN)
(check-expect (conversion-ghosts EX-APPSTATE-EDIBLE #\r) SKIN-GHOST-EDIBLE)

;; Template

;(define (conversion-ghosts appstate char)
;  (local [(define pp-active (... appstate))]
;    (if pp-active
;        ...
;        (cond [(equal? char ...) ...]
;              [(equal? char ...) ...]
;              [(equal? char ...) ...]
;              [(equal? char ...) ...]))))

;; Code - used by (conversion-char)
(define (conversion-ghosts appstate char)
  (local [(define pp-active (appstate-pp-active appstate))]
    (if pp-active
        SKIN-GHOST-EDIBLE
        (cond [(equal? char MAP-GHOST-ORANGE) SKIN-GHOST-ORANGE]
              [(equal? char MAP-GHOST-RED) SKIN-GHOST-RED]
              [(equal? char MAP-GHOST-PINK) SKIN-GHOST-PINK]
              [(equal? char MAP-GHOST-CYAN) SKIN-GHOST-CYAN]))))

;*********************************************************************************
;; Input/Output
; conversion-row : Appstate List-row -> Image
; given the state, converts a row as list of chars, in its correspondent image
; header :
; (define (conversion-row appstate list-row) Image)

;; Example
(check-expect (conversion-row INIT-APPSTATE (list #\. #\W #\W #\Y #\W)) (beside SKIN-DOT SKIN-WALL SKIN-WALL SKIN-CHERRY SKIN-WALL))
(check-expect (conversion-row INIT-APPSTATE (list #\@ #\. #\. #\@ #\.)) (beside SKIN-PP SKIN-DOT SKIN-DOT SKIN-PP SKIN-DOT))
(check-expect (conversion-row INIT-APPSTATE (list #\P #\r #\c #\p #\o)) (beside SKIN-PACMAN-OPEN SKIN-GHOST-RED SKIN-GHOST-CYAN SKIN-GHOST-PINK SKIN-GHOST-ORANGE))

;; Template
;(define (conversion-row appstate list-row)
;  (cond [(... (rest list-row)) (... appstate (first list-row))]
;        [else (... (... appstate (first list-row)) (conversion-row appstate (rest list-row)))]))

;; Code - used by (conversion-map)
(define (conversion-row appstate list-row)
  (cond [(empty? (rest list-row)) (conversion-char appstate (first list-row))]
        [else (beside (conversion-char appstate (first list-row)) (conversion-row appstate (rest list-row)))]))

;*********************************************************************************
;; Input/Output
; conversion-map : Appstate Map-list -> Image
; given the state, converts map to its correspondent image
; header :
; (define (conversion-map appstate map-list) Image)

;; Examples
(check-expect (conversion-map INIT-APPSTATE (list ".WWYW" "..@YW")) (above
                                                                     (beside SKIN-DOT SKIN-WALL SKIN-WALL SKIN-CHERRY SKIN-WALL)
                                                                     (beside SKIN-DOT SKIN-DOT SKIN-PP SKIN-CHERRY SKIN-WALL)))

(check-expect (conversion-map INIT-APPSTATE (list "WWWWW" "Pproc" "Y.@Y@")) (above
                                                                     (beside SKIN-WALL SKIN-WALL SKIN-WALL SKIN-WALL SKIN-WALL)
                                                                     (beside SKIN-PACMAN-OPEN SKIN-GHOST-PINK SKIN-GHOST-RED SKIN-GHOST-ORANGE SKIN-GHOST-CYAN)
                                                                     (beside SKIN-CHERRY SKIN-DOT SKIN-PP SKIN-CHERRY SKIN-PP)))

(check-expect (conversion-map EX-APPSTATE-EDIBLE (list "WWWWW" "Pproc" "Y.@Y@")) (above
                                                                     (beside SKIN-WALL SKIN-WALL SKIN-WALL SKIN-WALL SKIN-WALL)
                                                                     (beside SKIN-PACMAN-OPEN SKIN-GHOST-EDIBLE SKIN-GHOST-EDIBLE SKIN-GHOST-EDIBLE SKIN-GHOST-EDIBLE)
                                                                     (beside SKIN-CHERRY SKIN-DOT SKIN-PP SKIN-CHERRY SKIN-PP)))

;; Template
;(define (conversion-map appstate map-list)
;  (local [(define list-row (... (first map-list)))]
;  (cond [(... (rest map-list)) (... appstate list-row)]
;        [else (... (... appstate list-row) (conversion-map appstate (rest map-list)))])))


;; Code - used by (render)
(define (conversion-map appstate map-list)
  (local [(define list-row (string->list (first map-list)))]
  (cond [(empty? (rest map-list)) (conversion-row appstate list-row)]
        [else (above (conversion-row appstate list-row) (conversion-map appstate (rest map-list)))])))
;test
;(conversion-map INIT-APPSTATE (vector->list EX-MAP))

;*********************************************************************************
;; Input/Output
; render-score : Score -> Image
;
; header :
; (define (render-score score) Image)

;; Examples
(check-expect (render-score 4) (overlay (text (string-append "SCORE : 4") 18 "white") SCORE-RECTANGLE))
(check-expect (render-score 3) (overlay (text (string-append "SCORE : 3") 18 "white") SCORE-RECTANGLE))
(check-expect (render-score 100010) (overlay (text (string-append "SCORE : 100010") 18 "white") SCORE-RECTANGLE))

;; Template

;; Code - used by (render)
(define (render-score score)
  (overlay (text (string-append "SCORE : " (~v score)) 18 "white") SCORE-RECTANGLE))
;*********************************************************************************
; render = score, gui, canvas

;; render should resemble the UI, so the map must be rendered, also the score. 
;; plug-in (pause button, music on/off, sxf on/off, quit)
;*********************************************************************************
;; Input/Output
; render : Appstate -> Image
; given the appstate, return its correponding visual representation as image
; header:
; (define (render appstate) Image)

;; Examples
(check-expect (render PAC-TEST1) (underlay/xy (above (beside SKIN-WALL SKIN-WALL SKIN-WALL SKIN-WALL SKIN-WALL SKIN-WALL SKIN-WALL)
                                                     (beside SKIN-WALL SKIN-WALL SKIN-PP SKIN-WALL SKIN-DOT SKIN-DOT SKIN-DOT)
                                                     (beside  SKIN-CHERRY SKIN-PACMAN-CLOSE SKIN-GHOST-CYAN SKIN-GHOST-PINK SKIN-GHOST-RED SKIN-GHOST-ORANGE SKIN-DOT))
                                              1515 7 (render-score 0)))

;; Template

;; Code - used by (big-bang) 
(define (render appstate)
  (local [(define map-image (conversion-map appstate (vector->list (appstate-map appstate))))
          (define score-image (render-score (appstate-score appstate)))]
    (underlay/xy map-image 1515 7 score-image)))