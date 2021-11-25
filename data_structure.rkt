;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname data_structure) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
(require "figures.rkt")
PACMAN-OPEN
CHERRY

;;; Data types
; Position is an enumerator
; Up
; Down
; Left
; Right
; Stop - optional (only for pacman)

; Pacman is a struct: (make-pacman direction position)
(define-struct pacman [direction position])
; Ghost is a struct:
(define-struct ghost [direction position])
; Labyrinth is a struct:
(define-struct labyrinth [pp-active? pacman-mouth]
; Appstate is a struct:
  