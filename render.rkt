;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname render) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
(require racket/base)


;; LIBRARIES
(require 2htdp/image)
(require "data_structures.rkt")
(require "figures.rkt")
;*********************************************************************************
;;; RENDER FUNCTION
;*********************************************************************************
;;; CONVERSION CHUNK (low level)

;; Input/Output
; conversion-char: Appstate Char -> Image
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

;; Input/Output
; conversion-pacman: Appstate -> Image
(define-values (UPWARDS DOWNWARDS LEFTWARDS RIGHTWARDS) (values -90 90 180 0))
(define (conversion-pacman appstate)
  (local [(define direction (character-direction (appstate-pacman appstate)))
          (define pacman-mouth (appstate-pacman-mouth appstate))
          (define pacman-skin (conversion-pacman-mouth pacman-mouth))]
    (cond [(equal? DIRECTION-UP direction) (rotate UPWARDS pacman-skin)]
          [(equal? DIRECTION-DOWN direction) (rotate DOWNWARDS pacman-skin)]
          [(equal? DIRECTION-LEFT direction) (rotate LEFTWARDS pacman-skin)]
          [(equal? DIRECTION-RIGHT direction) (rotate RIGHTWARDS pacman-skin)])))

;; Input/Output
; conversion-pacman-mouth: pacman-mouth -> Image
(define (conversion-pacman-mouth pacman-mouth)
  (if pacman-mouth SKIN-PACMAN-OPEN SKIN-PACMAN-CLOSE))

;; Input/Output
; conversion-ghosts: Appstate Char -> Image
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
(define (conversion-row appstate list-row)
  (cond [(empty? (rest list-row)) (conversion-char appstate (first list-row))]
        [else (beside (conversion-char appstate (first list-row)) (conversion-row appstate (rest list-row)))]))

;*********************************************************************************
;; Input/Output
; conversion-map : Appstate Map-list -> Image
; given the state, converts map to its correspondent image
(define (conversion-map appstate map-list)
  (local [(define list-row (string->list (first map-list)))]
  (cond [(empty? (rest map-list)) (conversion-row appstate list-row)]
        [else (above (conversion-row appstate list-row) (conversion-map appstate (rest map-list)))])))

(conversion-map INIT-APPSTATE (vector->list EX-MAP))

;*********************************************************************************
; render = score, gui, canvas
;*********************************************************************************
;*********************************************************************************
;*********************************************************************************
;FIND ELEMENT AT POSITION
;(define (find-in-map state pos)
;  (vector-ref (vector-ref (appstate-map state) (posn-y pos)) (posn-x pos)))


; Map Pac-posn -> Map

;(define (find appstate pos)
 ; (list-ref (list-ref (appstate-map appstate) (posn-y pos)) (posn-x pos)))