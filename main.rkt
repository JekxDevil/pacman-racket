;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname main) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
(require 2htdp/universe)
(require "figures.rkt")
(require "data_structures.rkt")

(define (run appstate)
  (big-bang appstate
    [on-tick TICK]
    [to-draw render]
    [on-key edit]))

(run INIT-APPSTATE)