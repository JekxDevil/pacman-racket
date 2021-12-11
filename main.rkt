;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname main) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; LIBRARIES
(require 2htdp/universe)
(require "data_structures.rkt")
(require "render.rkt")
(require "key_handler.rkt")
(require "tick_handler.rkt")

;*******************************************************************************************************
;*******************************************************************************************************
;;; HAS QUIT ?
;; Data types
; Quit is a Boolean from struct Appstate (appstate-quit)

;; Input/Output
; quit? : Appstate -> Quit
; takes an appstate and returns a bool indicating whether the app has quit or not
; header :
; (define (quit? appstate) Quit)

;; Examples
(define END-STATE (make-appstate INIT-MAP INIT-PACMAN INIT-GHOSTS INIT-SCORE INIT-POWERPELLET-EFFECT #true))
(check-expect (quit? INIT-APPSTATE) #false)
(check-expect (quit? END-STATE) #true)

;; Template
; (define (quit? appstate)
;   ... appstate ...)

;; Code - used by (big-bang)
(define (quit? appstate)
  (appstate-quit appstate))

;*******************************************************************************************************
;;; BIG BANG
;; Input/Output
; run : Appstate
; runs the Pacman game
; header :
; (define (run appstate))

;; Template
; (define (run appstate)
;   (big-bang appstate
;     [to-draw   ...]
;     [on-tick   ...]
;     [on-key    ...]
;     [stop-when ...]))

;; Code 
(define (run appstate)
  (big-bang appstate
    [to-draw render]
    [on-tick tick-handler TICK]
    [on-key key-handler]
    [stop-when quit? render-game-over]
    ; meta
    [name "Pacman - Racket"]))

(run INIT-APPSTATE)