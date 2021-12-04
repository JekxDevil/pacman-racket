;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname main) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; LIBRARIES
(require 2htdp/universe)
(require "data_structures.rkt")
(require "figures.rkt")
(require "render.rkt")
(require "handler.rkt")

;*********************************************************************************
;*********************************************************************************
(define (run appstate)
  (big-bang appstate
    [on-tick TICK]
    [to-draw render]
    [on-key key-handler]
    [stop-when quit?]))

(run INIT-APPSTATE)