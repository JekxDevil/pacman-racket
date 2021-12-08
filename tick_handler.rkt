;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname tick_handler) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; LIBRARIES
(require racket/base)
(require 2htdp/image)
(require "data_structures.rkt")
(require "figures.rkt")
(require "render.rkt")

;*********************************************************************************
;*********************************************************************************
;; API
(provide tick_handler)
;(provide quit)
;(provide quit?)
;(provide move-posn)
;(provide find-in-map)
;(provide check-edible)
;(provide check-fullscore)
;(provide 

;*********************************************************************************
;*********************************************************************************
;;; func to have here instead of key_handler
; quit?
; quit
; 


;;; TICK HANDLER
;; Input/Output
; tick_handler : Appstate -> Appstate
; handler general logic events of the game at each tick
; header :
; (define (tick_handler appstate) Appstate)

;; Examples

;; Template

;; Code - used by (big-bang)
(define (tick_handler appstate)
  appstate)