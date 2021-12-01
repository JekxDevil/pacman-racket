;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname data_structures) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
(require racket/base)
(provide character)
(provide appstate)
(require "figures.rkt")

(define SCORE 0)
(define 
(define TICK 50)

;;; Data types
; Direction is an enumerator
; Up    -> "u"
; Down  -> "d"
; Left  -> "l"
; Right -> "r"

; Character is a struct: (make-pacman name direction position)
;            name : String
;        position : Posn
;       direction : Direction
(define-struct character [name direction position])

;*****************************************************************
;*****************************************************************
; Map is a Vector<String>
; map elements representation:
;- "W" wall
;- " " empty cell space
;- "." dot point
;- "@" power pellet
;- "P" pacman
;- ghosts:
;  - "e" special edible ghost
;  - "o" orange
;  - "r" red
;  - "p" pink
;  - "c" cyan
;- "_" ghost gate
;- "Y" cherry

;*****************************************************************
;*****************************************************************

; Appstate is a struct: (make-labyrinth map score pp-active? pacman-mouth) 
; where     map : Vector<String>
;         score : Natural
;        pacman : character
;     pp-active : Boolean
;  pacman-mouth : Boolean (VFX)
;          quit : Boolean
(define-struct appstate [map score pacman pp-active pacman-mouth quit])

;*****************************************************************
;*****************************************************************