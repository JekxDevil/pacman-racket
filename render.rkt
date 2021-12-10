;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname render) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; TODO (conversion-char) requires only pacman and pp-active, no need to have full appstate (less memory usage)
;; plug-in (pause button, music on/off, sxf on/off, quit)
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
; return the correspondent image of a map element (char)
; header :
; (define (conversion-char appstate char) Image)

;; Examples
(check-expect (conversion-char INIT-APPSTATE MAP-DOT) SKIN-DOT)
(check-expect (conversion-char INIT-APPSTATE MAP-CHERRY) SKIN-CHERRY)
(check-expect (conversion-char INIT-APPSTATE MAP-WALL) SKIN-WALL)
(check-expect (conversion-char INIT-APPSTATE MAP-PACMAN) SKIN-PACMAN-OPEN)
(check-expect (conversion-char INIT-APPSTATE MAP-GHOST-RED) SKIN-GHOST-RED)
(check-expect (conversion-char INIT-APPSTATE MAP-GHOST-ORANGE) SKIN-GHOST-ORANGE)
(check-expect (conversion-char INIT-APPSTATE MAP-GHOST-PINK) SKIN-GHOST-PINK)
(check-expect (conversion-char INIT-APPSTATE MAP-GHOST-CYAN) SKIN-GHOST-CYAN)
(check-expect (conversion-char INIT-APPSTATE MAP-POWERPELLET) SKIN-POWERPELLET)
(check-expect (conversion-char INIT-APPSTATE MAP-GATE) SKIN-GATE)
(check-expect (conversion-char INIT-APPSTATE MAP-EMPTY) SKIN-BG)

;; Template
; (define (conversion-char appstate char)
;   (cond
;     [(char=? char MAP-EMPTY)           ...]
;     [(char=? char MAP-WALL)            ...]
;     [(char=? char MAP-DOT)             ...]
;     [(char=? char MAP-PP)              ...]
;     [(char=? char MAP-PACMAN)          (... appstate ...)]
;     [(char=? char MAP-CHERRY)          ...]
;     [(char=? char MAP-GATE)            ...]
;       [(or (char=? char MAP-GHOST-ORANGE)
;            (char=? char MAP-GHOST-RED)
;            (char=? char MAP-GHOST-PINK)
;            (char=? char MAP-GHOST-CYAN)) (... appstate char ...)]))


;; Code - used by (conversion-row)
(define (conversion-char appstate char)
  (cond
    [(char=? char MAP-EMPTY) SKIN-BG]
    [(char=? char MAP-WALL) SKIN-WALL]
    [(char=? char MAP-DOT) SKIN-DOT]
    [(char=? char MAP-POWERPELLET) SKIN-POWERPELLET]
    [(char=? char MAP-PACMAN) (conversion-pacman (appstate-pacman appstate))]
    [(char=? char MAP-CHERRY) SKIN-CHERRY]
    [(char=? char MAP-GATE) SKIN-GATE]
    [(or (char=? char MAP-GHOST-ORANGE)
         (char=? char MAP-GHOST-RED)
         (char=? char MAP-GHOST-PINK)
         (char=? char MAP-GHOST-CYAN)) (conversion-ghosts appstate char)]))

;*********************************************************************************
;; Input/Output
; conversion-pacman: Pacman -> Image
; given pacman struct, returns its image according to the direction he is facing and if his mouth is open or close
; header :
; (define (conversion-pacman appstate) Image)

;; Examples
(define TEST-PAC0 (make-pacman (make-character MAP-PACMAN DIRECTION-LEFT (make-posn 1 8) INIT-ITEM-BELOW) #false))
(define TEST-PAC1 (make-pacman (make-character MAP-PACMAN DIRECTION-LEFT (make-posn 1 8) INIT-ITEM-BELOW) #true))
(define TEST-PAC2 (make-pacman (make-character MAP-PACMAN DIRECTION-UP (make-posn 1 8) INIT-ITEM-BELOW) #true))
(define TEST-PAC3 (make-pacman (make-character MAP-PACMAN DIRECTION-DOWN (make-posn 1 8) INIT-ITEM-BELOW) #true))

(check-expect (conversion-pacman (appstate-pacman INIT-APPSTATE)) SKIN-PACMAN-OPEN)
(check-expect (conversion-pacman TEST-PAC0) SKIN-PACMAN-CLOSE)
(check-expect (conversion-pacman TEST-PAC1) (rotate 180 SKIN-PACMAN-OPEN))
(check-expect (conversion-pacman TEST-PAC2) (rotate 90 SKIN-PACMAN-OPEN))
(check-expect (conversion-pacman TEST-PAC3) (rotate -90 SKIN-PACMAN-OPEN))

;; Template
; (define (conversion-pacman appstate)
;   (local [(define direction (... (... appstate)))
;           (define pacman-mouth (... appstate))
;           (define pacman-skin (... pacman-mouth))]
;     (cond
;       [(equal? ... direction) (... .... pacman-skin)]
;       [(equal? ... direction) (... .... pacman-skin)]
;       [(equal? ... direction) (... .... pacman-skin)]
;       [(equal? ... direction) (... .... pacman-skin)])))

;; Code - used by (conversion-char)
(define-values (UPWARDS DOWNWARDS LEFTWARDS RIGHTWARDS) (values 90 -90 180 0))
(define (conversion-pacman pacman)
  (local [(define direction (character-direction (pacman-character pacman)))
          (define skin (conversion-pacman-mouth (pacman-mouth pacman)))]
    (cond
      [(equal? DIRECTION-UP direction) (rotate UPWARDS skin)]
      [(equal? DIRECTION-DOWN direction) (rotate DOWNWARDS skin)]
      [(equal? DIRECTION-LEFT direction) (rotate LEFTWARDS skin)]
      [(equal? DIRECTION-RIGHT direction) (rotate RIGHTWARDS skin)])))

;*********************************************************************************
;; Input/Output
; conversion-pacman-mouth: Mouth -> Image
; given the mouth boolean state, return the image of pacman with the mouth open or closed 
; header :
; (define (conversion-pacman-mouth pacman-mouth) Image)

;; Examples
(check-expect (conversion-pacman-mouth (pacman-mouth TEST-PAC0)) SKIN-PACMAN-CLOSE)
(check-expect (conversion-pacman-mouth (pacman-mouth TEST-PAC1)) SKIN-PACMAN-OPEN)

;; Template
; (define (conversion-pacman-mouth pacman-mouth)
;   (if pacman-mouth ... ...))

;; Code - used by (conversion-pacman)
(define (conversion-pacman-mouth mouth)
  (if mouth SKIN-PACMAN-OPEN SKIN-PACMAN-CLOSE))

;*********************************************************************************
;; Input/Output
; conversion-ghosts: Appstate Char -> Image
; given a ghost element as char and appstate, return the correspondent image
; header :
; (define (conversion-ghosts appstate char) Image)

;; Examples
(check-expect (conversion-ghosts INIT-APPSTATE MAP-GHOST-RED) SKIN-GHOST-RED)
(check-expect (conversion-ghosts INIT-APPSTATE MAP-GHOST-ORANGE) SKIN-GHOST-ORANGE)
(check-expect (conversion-ghosts INIT-APPSTATE MAP-GHOST-PINK) SKIN-GHOST-PINK)
(check-expect (conversion-ghosts INIT-APPSTATE MAP-GHOST-CYAN) SKIN-GHOST-CYAN)
(check-expect (conversion-ghosts EX-APPSTATE-EDIBLE MAP-GHOST-RED) SKIN-GHOST-EDIBLE)

;; Template
; (define (conversion-ghosts appstate char)
;   (local [(define pp-active (... appstate))]
;     (if pp-active
;         ...
;         (cond
;           [(equal? char ...) ...]
;           [(equal? char ...) ...]
;           [(equal? char ...) ...]
;           [(equal? char ...) ...]))))

;; Code - used by (conversion-char)
(define (conversion-ghosts appstate char)
  (local [(define edible (powerpellet-effect-active (appstate-powerpellet-effect appstate)))]
    (if edible
        SKIN-GHOST-EDIBLE
        (cond
          [(equal? char MAP-GHOST-ORANGE) SKIN-GHOST-ORANGE]
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
(check-expect (conversion-row INIT-APPSTATE (string->list ".WWYW"))
              (beside SKIN-DOT SKIN-WALL SKIN-WALL SKIN-CHERRY SKIN-WALL))

(check-expect (conversion-row INIT-APPSTATE (string->list "@..@."))
              (beside SKIN-POWERPELLET SKIN-DOT SKIN-DOT SKIN-POWERPELLET SKIN-DOT))

(check-expect (conversion-row INIT-APPSTATE (string->list "Prcpo"))
              (beside SKIN-PACMAN-OPEN SKIN-GHOST-RED SKIN-GHOST-CYAN SKIN-GHOST-PINK SKIN-GHOST-ORANGE))

;; Template
; (define (conversion-row appstate list-row)
;   (cond [(... (rest list-row)) (... appstate (first list-row))]
;         [else (... (... appstate (first list-row)) (conversion-row appstate (rest list-row)))]))

;; Code - used by (conversion-map)
(define (conversion-row appstate list-row)
  (cond
    [(empty? (rest list-row)) (conversion-char appstate (first list-row))]
    [else (beside (conversion-char appstate (first list-row)) (conversion-row appstate (rest list-row)))]))

;*********************************************************************************
;; Input/Output
; conversion-map : Appstate Map-list -> Image
; given the state, converts map to its correspondent image
; header :
; (define (conversion-map appstate map-list) Image)

;; Examples
(check-expect (conversion-map INIT-APPSTATE (list ".WWYW" "..@YW"))
              (above (beside SKIN-DOT SKIN-WALL SKIN-WALL SKIN-CHERRY SKIN-WALL)
                     (beside SKIN-DOT SKIN-DOT SKIN-POWERPELLET SKIN-CHERRY SKIN-WALL)))

(check-expect (conversion-map INIT-APPSTATE (list "WWWWW" "Pproc" "Y.@Y@"))
              (above (beside SKIN-WALL SKIN-WALL SKIN-WALL SKIN-WALL SKIN-WALL)
                     (beside SKIN-PACMAN-OPEN SKIN-GHOST-PINK SKIN-GHOST-RED SKIN-GHOST-ORANGE SKIN-GHOST-CYAN)
                     (beside SKIN-CHERRY SKIN-DOT SKIN-POWERPELLET SKIN-CHERRY SKIN-POWERPELLET)))

(check-expect (conversion-map EX-APPSTATE-EDIBLE (list "WWWWW" "Pproc" "Y.@Y@"))
              (above (beside SKIN-WALL SKIN-WALL SKIN-WALL SKIN-WALL SKIN-WALL)
                     (beside SKIN-PACMAN-OPEN SKIN-GHOST-EDIBLE SKIN-GHOST-EDIBLE SKIN-GHOST-EDIBLE SKIN-GHOST-EDIBLE)
                     (beside SKIN-CHERRY SKIN-DOT SKIN-POWERPELLET SKIN-CHERRY SKIN-POWERPELLET)))

;; Template
; (define (conversion-map appstate map-list)
;   (local [(define list-row (... (first map-list)))]
;   (cond
;     [(... (rest map-list)) (... appstate list-row)]
;     [else (... (... appstate list-row) (conversion-map appstate (rest map-list)))])))


;; Code - used by (render)
(define (conversion-map appstate map-list)
  (local [(define list-row (string->list (first map-list)))]
  (cond
    [(empty? (rest map-list)) (conversion-row appstate list-row)]
    [else (above (conversion-row appstate list-row) (conversion-map appstate (rest map-list)))])))

;*********************************************************************************
;; Input/Output
; render-score : Score -> Image
; given the score, render the corresponding display image in its rectangle
; header :
; (define (render-score score) Image)

;; Examples
(check-expect (render-score 4) (overlay (text (string-append "SCORE : 4") 18 "white") SCORE-RECTANGLE))
(check-expect (render-score 3) (overlay (text (string-append "SCORE : 3") 18 "white") SCORE-RECTANGLE))
(check-expect (render-score 100010) (overlay (text (string-append "SCORE : 100010") 18 "white") SCORE-RECTANGLE))

;; Template
; (define (render-score score)
;   (overlay ... SCORE-RECTANGLE)

;; Code - used by (render)
(define (render-score score)
  (overlay (text (string-append "SCORE : " (~v score)) 18 "white") SCORE-RECTANGLE))




;*********************************************************************************
;; Input/Output
; render : Appstate -> Image
; given the appstate, return its correponding visual representation as image
; header:
; (define (render appstate) Image)

;; Constants
(define OFFSET-X-SCORE 1515)
(define OFFSET-Y-SCORE 7)
(define RATIO 0.6)

;; Examples
(define PAC-TEST1 (make-appstate (vector "WWWWWWW"
                                         "WW@W..."
                                         "YPcpro.")
                                 TEST-PAC0 INIT-GHOSTS INIT-SCORE INIT-POWERPELLET-EFFECT INIT-QUIT))

(define PAC-TEST2 (make-appstate (vector "WWWWWWW"
                                         "WW@W..."
                                         "YPcpro.")
                                 TEST-PAC1 INIT-GHOSTS INIT-SCORE INIT-POWERPELLET-EFFECT INIT-QUIT))

(define PAC-TEST3 (make-appstate (vector "WWWWWWW"
                                         "WW@W..."
                                         "YPcpro.")
                                 TEST-PAC2 INIT-GHOSTS INIT-SCORE INIT-POWERPELLET-EFFECT INIT-QUIT))

(define PAC-TEST4 (make-appstate (vector "WWWWWWW"
                                         "WW@W..."
                                         "YPcpro.")
                                 TEST-PAC3 INIT-GHOSTS INIT-SCORE INIT-POWERPELLET-EFFECT INIT-QUIT))

(check-expect (render PAC-TEST1)
              (scale RATIO (underlay/xy (above (beside SKIN-WALL SKIN-WALL SKIN-WALL SKIN-WALL SKIN-WALL SKIN-WALL SKIN-WALL)
                                               (beside SKIN-WALL SKIN-WALL SKIN-POWERPELLET SKIN-WALL SKIN-DOT SKIN-DOT SKIN-DOT)
                                               (beside  SKIN-CHERRY SKIN-PACMAN-CLOSE SKIN-GHOST-CYAN SKIN-GHOST-PINK SKIN-GHOST-RED SKIN-GHOST-ORANGE SKIN-DOT))
                                        OFFSET-X-SCORE OFFSET-Y-SCORE (render-score 0))))

;; Template
; (define (render appstate)
;   (underlay/xy ...)

;; Code - used by (big-bang)
(define (render appstate)
  (local [(define map-image (conversion-map appstate (vector->list (appstate-map appstate))))
          (define score-image (render-score (appstate-score appstate)))]
    (scale RATIO (underlay/xy map-image OFFSET-X-SCORE OFFSET-Y-SCORE score-image))))

;*********************************************************************************
;GAME OVER RENDER

;game-over: appstate --> Image
;the functions takes an appstate and return an image with the text "game over" and the score overlayed on the map
;header: (define game-over appstate) Image)

(define (game-over state)
  (local (
          (define rendered-appstate (render state))
          (define render-width (image-width rendered-appstate))
          (define render-length (image-width (rotate 90 rendered-appstate)))
          (define score  (render-score (appstate-score state)))
          (define mask (rectangle render-width render-length "solid" (color 0 0 0 127))))
    (overlay/align/offset "middle" "middle"
                        (scale  2  score)
                        0 -100 (overlay (text "GAME OVER" 100 "white") (text "GAME OVER" 105 "steel blue") mask rendered-appstate))))