;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname key_handler) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; LIBRARIES
(require racket/base)
(require 2htdp/image)
(require "data_structures.rkt")
(require "figures.rkt")
(require "render.rkt")
(require "tick_handler.rkt")

;*********************************************************************************
;*********************************************************************************
;; API
(provide key-handler)

;*********************************************************************************
;*********************************************************************************
;;; KEY HANDLER
;; Input/Output
; key-handler : Appstate Key -> Appstate
; handler keystroke events of the game
; header :
; (define (key-handler appstate key) Appstate)

;; Examples

;; Template
; (define (key-handler appstate key)
;   (cond [(equal? key "up")    ...]
;         [(equal? key "down")  ...]
;         [(equal? key "left")  ...]
;         [(equal? key "right") ...]
;         [else                 ...]))

;; Code - used by (big-bang)
(define (key-handler appstate key)
  (cond [(equal? key "up") (move-pacman appstate DIRECTION-UP)]
        [(equal? key "down") (move-pacman appstate DIRECTION-DOWN)]
        [(equal? key "left") (move-pacman appstate DIRECTION-LEFT)]
        [(equal? key "right") (move-pacman appstate DIRECTION-RIGHT)]
        [else appstate]))

;*********************************************************************************
;;; MOVE PACMAN
;; Data types
; (update-map map pac-or-ghost pos-next)
; (define (update-map map pac-or-ghost pos-next)

;; Input/Output
; move-pacman: Appstate Character -> Appstate
; handles pacman move logic
; header :
; (define (move appstate character) Character)

;; Examples

;; Template

;; Code - used by (key-handler)
(define (move-pacman appstate direction)
  (local [(define pacman (appstate-pacman appstate))
          (define name (character-name (pacman-character pacman)))
          (define posn (character-position (pacman-character pacman)))
          (define mouth (pacman-mouth pacman))
          (define posn-next (move-posn posn direction))
          (define new-pacman (make-pacman (make-character name direction posn-next) mouth))
          (define element-next (find-in-map (appstate-map appstate) posn-next))]
    (cond [(or (char=? MAP-GATE element-next)
               (char=? MAP-WALL element-next)) appstate]
          [(char=? MAP-DOT element-next) (make-appstate (update-map (appstate-map appstate) pacman posn-next)
                                                        new-pacman (appstate-ghosts appstate)
                                                        (+ POINTS-DOT (appstate-score appstate)) (appstate-pp-active appstate)
                                                         (appstate-quit appstate))]
          [(char=? MAP-PP element-next) (make-appstate (update-map (appstate-map appstate) pacman posn-next)
                                                       new-pacman (appstate-ghosts appstate)
                                                       (+ POINTS-PP (appstate-score appstate)) #true
                                                       (appstate-quit appstate))]
          [(char=? MAP-CHERRY element-next) (make-appstate (update-map (appstate-map appstate) pacman posn-next)
                                                           new-pacman (appstate-ghosts appstate)
                                                           (+ POINTS-CHERRY (appstate-score appstate)) (appstate-pp-active appstate)
                                                           (appstate-quit appstate))]
          [(char=? MAP-EMPTY element-next) (make-appstate (update-map (appstate-map appstate) pacman posn-next)
                                                          new-pacman (appstate-ghosts appstate)
                                                          (appstate-score appstate) (appstate-pp-active appstate)
                                                          (appstate-quit appstate))]
          [(or (char=? MAP-GHOST-RED element-next)
               (char=? MAP-GHOST-PINK element-next)
               (char=? MAP-GHOST-ORANGE element-next)
               (char=? MAP-GHOST-CYAN element-next)) (check-edible appstate new-pacman)])))

;*******************************************************************************************************
;;; CHECK GHOST EDIBLE #@@@@@ TODO UPDATE-MAP ONCE EATED
;; Input/Output
; check-edible : Appstate Pacman -> Appstate
; check if ghosts are edible when pacman collide, if they are, pacman eats them, otherwise the game is over
; header :
; (define (check-edible appstate) Appstate)

;; Examples
(define CGE-MAP (vector "Pc"))
(define CGE-PACMAN (make-pacman (make-character MAP-PACMAN DIRECTION-RIGHT (make-posn 0 0)) #true))
(define CGE-GHOST (make-ghost (make-character MAP-GHOST-CYAN DIRECTION-LEFT (make-posn 1 0)) MAP-EMPTY))
(define CGE-GHOSTS (list CGE-GHOST))
(define CGE-PACMAN-AT-GHOST (make-pacman (make-character MAP-PACMAN DIRECTION-RIGHT (make-posn 1 0)) #true))
(define TEST-APPSTATE-GOOD (make-appstate CGE-MAP CGE-PACMAN CGE-GHOSTS INIT-SCORE #t #f))
(define TEST-APPSTATE-GOODEND (make-appstate CGE-MAP CGE-PACMAN-AT-GHOST CGE-GHOSTS INIT-SCORE #t #f))
(define TEST-APPSTATE-BAD (make-appstate CGE-MAP CGE-PACMAN CGE-GHOSTS INIT-SCORE #f #f))
(define TEST-APPSTATE-BADEND (make-appstate CGE-MAP CGE-PACMAN CGE-GHOSTS INIT-SCORE #f #t))

(check-expect (check-edible TEST-APPSTATE-GOOD CGE-PACMAN-AT-GHOST) TEST-APPSTATE-GOODEND)
(check-expect (check-edible TEST-APPSTATE-BAD CGE-PACMAN-AT-GHOST) TEST-APPSTATE-BADEND)

;; Template
; (define (check-edible appstate new-pacman)
;   (if [appstate-pp-active appstate]
;       [make-appstate ...]
;       [quit          ...]))

;; Code - used by (move-pacman)
(define (check-edible appstate new-pacman)
  (if [appstate-pp-active appstate]
      [make-appstate (appstate-map appstate) new-pacman (appstate-ghosts appstate)
                     (appstate-score appstate) (appstate-pp-active appstate)
                     (appstate-quit appstate)]
      [quit appstate]))
