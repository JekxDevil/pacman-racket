;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname data_structures) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
(require "figures.rkt")

(define SCORE 0)
(define TICK 50)

;;; Data types
; Direction is an enumerator
; Up
; Down
; Left
; Right

; Character is a struct: (make-pacman name direction position)
;            name : String
;        position : Posn
;       direction : Direction
(define-struct character [name direction position])

;*****************************************************************
;*****************************************************************

; Appstate is a struct: (make-labyrinth map score pp-active? pacman-mouth) 
; where     map : Vector<String>
;         score : Natural
;    pp-active? : Boolean
;  pacman-mouth : Boolean
(define-struct labyrinth [map score pp-active? pacman-mouth])

;*****************************************************************
;*****************************************************************