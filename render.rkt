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
(provide render-game-over)

;*********************************************************************************
;*********************************************************************************
;;; CONVERSION CHUNK (low level)
;Datatypes
;appstate is an Appstate
;Char is a char 

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
;CONVERSION-PACMAN
;Datatypes
; pacman is a Pacman

;; Input/Output
; conversion-pacman: Pacman -> Image
; given pacman struct, returns its image according to the direction he is facing and if his mouth is open or close
; header :
; (define (conversion-pacman pacman) Image)

;; Examples
(define TEST-PAC0 (make-pacman (make-character MAP-PACMAN DIRECTION-LEFT (make-posn 1 8) INIT-ITEM-BELOW) #false))
(define TEST-PAC1 (make-pacman (make-character MAP-PACMAN DIRECTION-LEFT (make-posn 1 8) INIT-ITEM-BELOW) #true))
(define TEST-PAC2 (make-pacman (make-character MAP-PACMAN DIRECTION-UP (make-posn 1 8) INIT-ITEM-BELOW) #true))
(define TEST-PAC3 (make-pacman (make-character MAP-PACMAN DIRECTION-DOWN (make-posn 1 8) INIT-ITEM-BELOW) #true))

(check-expect (conversion-pacman INIT-PACMAN) SKIN-PACMAN-OPEN)
(check-expect (conversion-pacman TEST-PAC0) SKIN-PACMAN-CLOSE)
(check-expect (conversion-pacman TEST-PAC1) (rotate 180 SKIN-PACMAN-OPEN))
(check-expect (conversion-pacman TEST-PAC2) (rotate 90 SKIN-PACMAN-OPEN))
(check-expect (conversion-pacman TEST-PAC3) (rotate -90 SKIN-PACMAN-OPEN))

;; Template
;(define (conversion-pacman pacman)
;  (local [(define direction (... (... pacman)))
;          (define skin (... (... pacman)))]
;    (cond
;      [(equal? ... direction) (rotate ... skin)]
;      [(equal? ... direction) (rotate ... skin)]
;      [(equal? ... direction) (rotate ... skin)]
;      [(equal? ... direction) (rotate ... skin)])))

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
;CONVERSION-PACMAN-MOUTH
;Datatypes
; pacman-mouth is a Boolean

;; Input/Output
; conversion-pacman-mouth: Boolean -> Image
; given the mouth boolean state, return the image of pacman with the mouth open or closed 
; header :
; (define (conversion-pacman-mouth pacman-mouth) Image)

;; Examples
(check-expect (conversion-pacman-mouth (pacman-mouth TEST-PAC0)) SKIN-PACMAN-CLOSE)
(check-expect (conversion-pacman-mouth (pacman-mouth TEST-PAC1)) SKIN-PACMAN-OPEN)

;; Template
; (define (conversion-pacman-mouth mouth)
;   (if mouth ... ...))

;; Code - used by (conversion-pacman)
(define (conversion-pacman-mouth mouth)
  (if mouth SKIN-PACMAN-OPEN SKIN-PACMAN-CLOSE))

;*********************************************************************************
;CONVERSION-GHOSTS
;Datatypes
;appstate is an Appstate
; char is a Char

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
;   (local [(define edible (... (... appstate)))]
;     (if edible
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
;CONVERSION-ROW
;Datatypes
; list-row is a List<Char>
; appstate is an Appstate

;; Input/Output
; conversion-row : Appstate List-row -> Image
; given the state, converts a row as list of chars, in its correspondent image
; header :
; (define (conversion-row appstate list-row) Image)

;; Example
(check-expect (conversion-row INIT-APPSTATE (string->list ".W@YPrcpo"))
              (beside SKIN-DOT SKIN-WALL SKIN-POWERPELLET SKIN-CHERRY
                      SKIN-PACMAN-OPEN SKIN-GHOST-RED SKIN-GHOST-CYAN
                      SKIN-GHOST-PINK SKIN-GHOST-ORANGE))

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
;CONVERSION-MAP
;Datatypes
;map-list is a Map-list, a list representation for Map (Vector<String>)
;appstate is an Appstate

;; Input/Output
; conversion-map : Appstate Map-list -> Image
; given the state, converts map to its correspondent image
; header :
; (define (conversion-map appstate map-list) Image)

;; Examples
(check-expect (conversion-map INIT-APPSTATE (list "WWWWW" "Pproc" "Y.@Y@"))
              (above (beside SKIN-WALL SKIN-WALL SKIN-WALL SKIN-WALL SKIN-WALL)
                     (beside SKIN-PACMAN-OPEN SKIN-GHOST-PINK SKIN-GHOST-RED SKIN-GHOST-ORANGE SKIN-GHOST-CYAN)
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
; RENDER-SCORE
;Datatype
;score is a Natural
; a Natural is one of
; - 0
; - (add1 Natural) ; a positive integer

;; Input/Output
; render-score : Score -> Image
; given the score, render the corresponding display image in its rectangle
; header :
; (define (render-score score) Image)

;; Examples
(check-expect (render-score 4) (overlay (text (string-append "SCORE : 4") 18 "white") SCORE-RECTANGLE))
(check-expect (render-score 100010) (overlay (text (string-append "SCORE : 100010") 18 "white") SCORE-RECTANGLE))

;; Template
; (define (render-score score)
;   (... (... (... ... (... score)) ... ...) ...)

;; Code - used by (render)
(define (render-score score)
  (overlay (text (string-append "SCORE : " (~v score)) 18 "white") SCORE-RECTANGLE))

;*********************************************************************************
; RENDER
;Datatypes
; appstate is an Appstate

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
(define EX-R-MAP (vector ".W@YPrcpo"))
(define EX-R-SCORE (render-score 0))
(define EX-R-APPSTATE-GOOD (make-appstate EX-R-MAP INIT-PACMAN INIT-GHOSTS INIT-SCORE INIT-POWERPELLET-EFFECT INIT-QUIT))
(define EX-R-APPSTATE-GOOD-IMG (scale RATIO
                                      (underlay/xy (beside SKIN-DOT SKIN-WALL SKIN-POWERPELLET
                                                           SKIN-CHERRY SKIN-PACMAN-OPEN SKIN-GHOST-RED
                                                           SKIN-GHOST-CYAN SKIN-GHOST-PINK SKIN-GHOST-ORANGE)
                                                   OFFSET-X-SCORE OFFSET-Y-SCORE EX-R-SCORE)))

(check-expect (render EX-R-APPSTATE-GOOD) EX-R-APPSTATE-GOOD-IMG)

;; Template
; (define (render appstate)
;   (local
;     [(define map-image (conversion-map ...))
;      (define score-image (render-score ...))
;     [scale ... appstate ...]))

;; Code - used by (big-bang)
(define (render appstate)
  (local
    [; pre-calculated values
     (define map-image (conversion-map appstate (vector->list (appstate-map appstate))))
     (define score-image (render-score (appstate-score appstate)))]
    ; body
     [scale RATIO (underlay/xy map-image OFFSET-X-SCORE OFFSET-Y-SCORE score-image)]))

;*********************************************************************************
;;; RENDER GAME OVER
;Datatypes
;appstate is an Appstate

;; Input/Output
; render-game-over: Appstate -> Image
; take an appstate and return an image with the text "game over" and the score overlayed on the map
; header: (define render-game-over appstate) Image)

;; Constants
(define RATIO-SCORE 2)
(define SIZE-GAMEOVER 100)
(define COLOR-MASK (color 0 0 0 127))

;; Examples
(define EX-R-APPSTATE-BAD (make-appstate EX-R-MAP INIT-PACMAN INIT-GHOSTS INIT-SCORE INIT-POWERPELLET-EFFECT #true))
(define EX-R-SCORE-IMG-BAD (overlay (text "SCORE : 0" 36 "white")
                                    (rectangle 300 80 "solid" "black")
                                    (rectangle 310 90 "solid" "white")))
(define EX-R-APPSTATE-BAD-IMG (underlay/offset
                               (overlay
                                (overlay (text "GAME OVER" 100 "white")
                                         (text "GAME OVER" 105 "steel blue"))
                                (rectangle (image-width EX-R-APPSTATE-GOOD-IMG)
                                           (image-width (rotate 90 EX-R-APPSTATE-GOOD-IMG))
                                           "solid"
                                           (color 0 0 0 127))
                                EX-R-APPSTATE-GOOD-IMG)
                               0
                               100
                               (scale 2 EX-R-SCORE)))

(check-expect (render-game-over EX-R-APPSTATE-BAD) EX-R-APPSTATE-BAD-IMG)

;; Template
;(define (render-game-over appstate)
;  (local 
;    [
;     (define appstate-img (... appstate))
;     (define width (... appstate-img))
;     (define height (... (... appstate-img)))
;     (define score-img (... (... appstate)))
;     (define mask (... width height ... ...))
;     (define gameover-img (... ... ...))
;     (define masked-gameover-without-score (... gameover-img mask appstate-img))]
;    [...
;     masked-gameover-without-score
;     ...
;     ...
;     (... ... score-img)]))


(define (render-game-over appstate)
  (local 
    [; pre-calculated values
     (define appstate-img (render appstate))
     (define width (image-width appstate-img))
     (define height (image-width (rotate 90 appstate-img)))
     (define score-img (render-score (appstate-score appstate)))
     ; mask elements composition
     (define mask (rectangle width height "solid" COLOR-MASK))
     (define gameover-img (overlay (text "GAME OVER" SIZE-GAMEOVER "white") (text "GAME OVER" (+ 5 SIZE-GAMEOVER) "steel blue")))
     (define masked-gameover-without-score (overlay gameover-img mask appstate-img))]
    ; function body - assemble
    [underlay/offset
     masked-gameover-without-score
     0
     SIZE-GAMEOVER
     (scale RATIO-SCORE score-img)]))
