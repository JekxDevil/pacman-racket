;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname figures) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; LIBRARIES
(require racket/base)
(require 2htdp/image)

;************************************************************************************
;************************************************************************************
;; API
(provide UNIT)

; characters
(provide SKIN-PACMAN-OPEN)
(provide SKIN-PACMAN-CLOSE)
(provide SKIN-GHOST-RED)
(provide SKIN-GHOST-PINK)
(provide SKIN-GHOST-CYAN)
(provide SKIN-GHOST-ORANGE)
(provide SKIN-GHOST-EDIBLE)
; objects
(provide SKIN-DOT)
(provide SKIN-POWERPELLET)
(provide SKIN-CHERRY)
; map
(provide SKIN-BG)
(provide SKIN-WALL)
(provide SKIN-GATE)
; UI
(provide SCORE-RECTANGLE)

;************************************************************************************
;************************************************************************************
;; CONTANTS
(define UNIT 60)
; postfix "WB" stands for "Without Border"

; BACKGROUND
(define SKIN-BG (square UNIT "solid" "black"))

; PACMAN
(define PACMAN-OPEN-WB (rotate 30 (wedge 30 300 "solid" "gold")))
(define PACMAN-CLOSE-WB (circle 30 "solid" "gold"))
(define SKIN-PACMAN-OPEN (place-image/align PACMAN-OPEN-WB 30 30 "center" "center" SKIN-BG))
(define SKIN-PACMAN-CLOSE (place-image/align PACMAN-CLOSE-WB 30 30 "center" "center" SKIN-BG))
;************************************************************************************
; MAKE GHOSTS
(define EYE (circle 7 "solid" "white"))
(define PUPIL (circle 3 "solid" "blue"))
(define TOOTH (isosceles-triangle 5 300 "solid" "white"))
(define TEETH (beside TOOTH TOOTH TOOTH TOOTH TOOTH))
(define MOUTH (underlay/offset TEETH 2 3 (rotate 180 TEETH)))

(define (make-ghost-body color)
  (overlay/offset (rectangle 50 30 "solid" color) 0 -19 (circle 25 "solid" color)))

(define (make-ghost-eye color)
  (underlay/offset (make-ghost-body color) 0 -10 (underlay/offset EYE -30 0 EYE)))

(define (make-ghost-pupils color)
  (underlay/offset (make-ghost-eye color) 0 -10 (underlay/offset PUPIL -30 0 PUPIL)))

(define (make-ghost color)
  (place-image/align (make-ghost-pupils color) 30 30 "center" "center" SKIN-BG))

; RED GHOST
(define SKIN-GHOST-RED (make-ghost "red"))
; PINK GHOST
(define SKIN-GHOST-PINK (make-ghost "pink"))
; CYAN GHOST
(define SKIN-GHOST-CYAN (make-ghost "cyan"))
; ORANGE GHOST
(define SKIN-GHOST-ORANGE (make-ghost "orange"))
; EDIBLE GHOST
(define GHOST-EDIBLE-WB (underlay/offset (make-ghost "blue") 0 7 MOUTH))
(define SKIN-GHOST-EDIBLE (place-image/align GHOST-EDIBLE-WB 30 30 "center" "center" SKIN-BG))
;************************************************************************************
; DOT
(define DOT-WB (circle 6 "solid" "Papaya Whip"))
(define SKIN-DOT (place-image/align DOT-WB 30 30 "center" "center" SKIN-BG))

;************************************************************************************
; POWERPELLETS
(define POWERPELLET-WB (circle 10 "solid" "Khaki"))
(define SKIN-POWERPELLET (place-image/align POWERPELLET-WB 30 30 "center" "center" SKIN-BG))

;************************************************************************************
; CHERRY
(define PEN-CHERRY (pen "brown" 5 "long-dash" "butt" "round"))
(define BRANCH (line 10 -10 PEN-CHERRY))
(define BRANCHES (beside BRANCH (flip-horizontal BRANCH)))
(define CHERRY-GRAPE (overlay/offset (circle 10 "solid" "firebrick") 2 2 (circle 10 "solid" "light coral")))
(define CHERRY-GRAPES (overlay/offset CHERRY-GRAPE 20 0 CHERRY-GRAPE))
(define CHERRY-WB (overlay/offset BRANCHES 0 10 CHERRY-GRAPES))
(define SKIN-CHERRY (place-image/align CHERRY-WB 30 30 "center" "center" SKIN-BG))

;************************************************************************************
; WALL
(define SKIN-WALL (square UNIT "solid" "blue"))

;************************************************************************************
; GATE
(define SKIN-GATE (place-image/align (rectangle UNIT 5 "solid" "Deep Sky Blue") 30 30 "center" "center" SKIN-BG))

;************************************************************************************
; SCORE RECTANGLE
(define SCORE-RECTANGLE (overlay (rectangle 150 40 "solid" "black") (rectangle 155 45 "solid" "white")))