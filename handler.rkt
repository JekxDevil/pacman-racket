;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname handler) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; LIBRARIES
(require racket/base)
(require 2htdp/image)
(require "data_structures.rkt")
(require "figures.rkt")
(require "render.rkt")

;*********************************************************************************
;*********************************************************************************
;; API
(provide key-handler)
(provide quit?)

;*********************************************************************************
;*********************************************************************************
;; Input/Output
; key-handler : Appstate Key -> Appstate
;
; header :
; (define (key-handler appstate key) Appstate)

;; Examples

;; Template

;; Code - used by (big-bang)
(define (key-handler appstate key)
  (cond
    [(equal? key "left") (move-left appstate)]
    [(equal? key "right") (move-right appstate)]
    [(equal? key "up") (move-up appstate)]
    [(equal? key "down") (move-down appstate)]
    [else appstate]))

;*********************************************************************************
;MOVE-LEFT FUNCTION
;; Input/Output
; move-left: Appstate -> Appstate
;
; header :
; (define (move-left appstate) appstate)

;; Examples

;; Template

;; Code - used by (key-handler)
(define (move-left state)
  (local (
          (define pac-pos (((character-position) ((appstate-pacman) state))))
          (define pac-next (make-posn (- (posn-x pac-pos) 1) (posn-y pac-pos)))
          (define next (find state pac-next)))
    (cond
      [(or (equal? next "_") (equal? next "W")) state]
      [(equal? next ".") (make-appstate (map-update state)
                                        (+ (appstate-score state) 10)
                                        (appstate-pp-active? state)
                                        (appstate-pacman-mouth state)
                                        (make-character ("Pac-Man" "l" pac-next))
                                        (appstate-ghost state)
                                        #false)]
      
      [(equal? next "@") (make-appstate (map-update state)
                                        (+ (appstate-score state) 100)
                                        #true
                                        (appstate-pacman-mouth state)
                                        pac-next
                                        (appstate-ghost state)
                                        #false)]
      
      [(equal? next "Y") (make-appstate (map-update state)
                                        (+ (appstate-score state) 100)
                                        (appstate-pp-active? state)
                                        (appstate-pacman-mouth state)
                                        (make-character ("Pac-Man" "l" pac-next))
                                        (appstate-ghost state)
                                        #false)]
      
      [(equal? next "e") (make-appstate (map-update state)
                                        (+ (appstate-score state) 100)
                                        (appstate-pp-active? state)
                                        (appstate-pacman-mouth state)
                                        (make-character ("Pac-Man" "l" pac-next))
                                        (appstate-ghost state)
                                        #false)]
      
      [(or (equal? next "r") (equal? next "p") (equal? next "o") (equal? next "c")) (make-appstate (map-update state)
                                                                                                   (appstate-score state)
                                                                                                   (app-state-pp-active? state)
                                                                                                   (appstate-pacman-mouth state)
                                                                                                   (make-character ("Pac-Man" "l" pac-next))
                                                                                                   (appstate-ghost state)
                                                                                                   #true)]
      [(equal? next " ") (make-appstate (map-update state)
                                        (appstate-score state)
                                        (app-state-pp-active? state)
                                        (appstate-pacman-mouth state)
                                        (make-character ("Pac-Man" "l" pac-next))
                                        (appstate-ghost state)
                                        #false)])))

;*********************************************************************************
; MOVE-RIGHT FUNCTION
;; Input/Output
; move-right: Appstate -> Appstate
;
; header :
; (define (move-right appstate) Appstate)

;; Examples

;; Template

;; Code - used by (key-handler)
(define (move-right state)
  (local (
          (define pac-pos (((character-position) ((appstate-pacman) state))))
          (define pac-next (make-posn (+ (posn-x pac-posn) 1) (posn-y pac-pos)))
          (define next (find state pac-next)))
    (cond
      [(or (equal? next "_") (equal? next "W")) state]
      [(equal? next ".") (make-appstate (map-update state)
                                        (+ (appstate-score state) 10)
                                        (app-state-pp-active? state)
                                        (appstate-pacman-mouth state)
                                        (make-character ("Pac-Man" "r" pac-next))
                                        (appstate-ghost state)
                                        #false)]
      
      [(equal? next "@") (make-appstate (map-update state)
                                        (+ (appstate-score state) 100)
                                        #true
                                        (appstate-pacman-mouth state)
                                        (make-character ("Pac-Man" "r" pac-next))
                                        (appstate-ghost state)
                                        #false)]
      
      [(equal? next "Y") (make-appstate (map-update state)
                                        (+ (appstate-score state) 100)
                                        (app-state-pp-active? state)
                                        (appstate-pacman-mouth state)
                                        (make-character ("Pac-Man" "r" pac-next))
                                        (appstate-ghost state)
                                        (appstate-ghost state)
                                        #false)]
      
      [(equal? next "e") (make-appstate (map-update state)
                                        (+ (appstate-score state) 100)
                                        (app-state-pp-active? state)
                                        (appstate-pacman-mouth state)
                                        (make-character ("Pac-Man" "r" pac-next))
                                        (appstate-ghost state)
                                        (appstate-ghost state)
                                        #false)]
      
      [(or (equal? next "r") (equal? next "p") (equal? next "o") (equal? next "c")) (make-appstate (map-update state)
                                                                                                   (appstate-score state)
                                                                                                   (app-state-pp-active? state)
                                                                                                   (appstate-pacman-mouth state)
                                                                                                   (make-character ("Pac-Man" "r" pac-next))
                                                                                                   (appstate-ghost state)
                                                                                                   #true)]
      [(equal? next " ") (make-appstate (map-update state)
                                        (appstate-score state)
                                        (app-state-pp-active? state)
                                        (appstate-pacman-mouth state)
                                        (make-character ("Pac-Man" "r" pac-next))
                                        (appstate-ghost state)
                                        #false)])))

;*********************************************************************************
;MOVE-DOWN FUNCTION
; Input/Output
; move-down: Appstate -> Appstate
;
; header :
; (define (move-down appstate) Appstate)

;; Examples

;; Template

;; Code - used by (key-handler)
(define (move-down state)
  (local (
          (define pac-pos (((character-position) ((appstate-pacman) state))))
          (define pac-next (make-posn (posn-x pac-posn) (+ (posn-y pac-pos) 1)))
          (define next (find state pac-next)))
    (cond
      [(or (equal? next "_") (equal? next "W")) state]
      [(equal? next ".") (make-appstate (map-update state)
                                        (+ (appstate-score state) 10)
                                        (app-state-pp-active? state)
                                        (appstate-pacman-mouth state)
                                        (make-character ("Pac-Man" "d" pac-next))
                                        (appstate-ghost state)
                                        #false)]
      
      [(equal? next "@") (make-appstate (map-update state)
                                        (+ (appstate-score state) 100)
                                        #true
                                        (appstate-pacman-mouth state)
                                        (make-character ("Pac-Man" "d" pac-next))
                                        (appstate-ghost state)
                                        #false)]
      
      [(equal? next "Y") (make-appstate (map-update state)
                                        (+ (appstate-score state) 100)
                                        (app-state-pp-active? state)
                                        (appstate-pacman-mouth state)
                                        (make-character ("Pac-Man" "d" pac-next))
                                        (appstate-ghost state)
                                        #false)]
      
      [(equal? next "e") (make-appstate (map-update state)
                                        (+ (appstate-score state) 100)
                                        (app-state-pp-active? state)
                                        (appstate-pacman-mouth state)
                                        (make-character ("Pac-Man" "d" pac-next))
                                        (appstate-ghost state)
                                        #false)]
      
      [(or (equal? next "r") (equal? next "p") (equal? next "o") (equal? next "c")) (make-appstate (map-update state)
                                                                                                   (appstate-score state)
                                                                                                   (app-state-pp-active? state)
                                                                                                   (appstate-pacman-mouth state)
                                                                                                   (make-character ("Pac-Man" "d" pac-next))
                                                                                                   (appstate-ghost state)
                                                                                                   #true)]
      [(equal? next " ") (make-appstate (map-update state)
                                        (appstate-score state)
                                        (app-state-pp-active? state)
                                        (appstate-pacman-mouth state)
                                        (make-character ("Pac-Man" "d" pac-next))
                                        (appstate-ghost state)
                                        #false)])))

;*********************************************************************************
; MOVE-UP FUNCTION
; Input/Output
; move-up: Appstate -> Appstate
; 
; header :
; (define (move-up appstate) Appstate)

;; Examples

;; Template

;; Code - used by (key-handler) 
(define (move-up state)
  (local (
          (define pac-pos (((character-position) ((appstate-pacman) state))))
          (define pac-next (make-posn (posn-x pac-posn) (- (posn-y pac-pos) 1)))
          (define next (find state pac-next)))
    (cond
      [(or (equal? next "_") (equal? next "W")) state]
      [(equal? next ".") (make-appstate (map-update state)
                                        (+ (appstate-score state) 10)
                                        (app-state-pp-active? state)
                                        (appstate-pacman-mouth state)
                                        (make-character ("Pac-Man" "u" pac-next))
                                        (appstate-ghost state) #false)]
      
      [(equal? next "@") (make-appstate (map-update state)
                                        (+ (appstate-score state) 100)
                                        #true
                                        (appstate-pacman-mouth state)
                                        (make-character ("Pac-Man" "u" pac-next))
                                        (appstate-ghost state)
                                        #false)]
      
      [(equal? next "Y") (make-appstate (map-update state)
                                        (+ (appstate-score state) 100)
                                        (app-state-pp-active? state)
                                        (appstate-pacman-mouth state)
                                        (make-character ("Pac-Man" "u" pac-next))
                                        (appstate-ghost state)
                                        #false)]
      
      [(equal? next "e") (make-appstate (map-update state)
                                        (+ (appstate-score state) 100)
                                        (app-state-pp-active? state)
                                        (appstate-pacman-mouth state)
                                        (make-character ("Pac-Man" "u" pac-next))
                                        (appstate-ghost state)
                                        #false)]
      
      [(or (equal? next "r") (equal? next "p") (equal? next "o") (equal? next "c")) (make-appstate
                                                                                     (map-update state)
                                                                                     (appstate-score state)
                                                                                     (app-state-pp-active? state)
                                                                                     (appstate-pacman-mouth state)
                                                                                     (make-character ("Pac-Man" "u" pac-next))
                                                                                     (appstate-ghost state) #true)]
      [(equal? next " ") (make-appstate (map-update state)
                                        (appstate-score state)
                                        (app-state-pp-active? state)
                                        (appstate-pacman-mouth state)
                                        (make-character ("Pac-Man" "u" pac-next))
                                        (appstate-ghost state)
                                        #false)])))

;*******************************************************************************************************
;tests
(define (find state pos)
  (vector-ref (vector-ref (appstate-map state) (posn-y pos)) (posn-x pos)))

;*******************************************************************************************************
;; Input/Output
; is-fullscore : Appstate -> Appstate
; check if score is full, if it is the quit attribute in appstate becomes true
; header:
; (define (is-fullscore appstate) Appstate)

;; Examples
(define PRE-SCORE-APPSTATE0 (make-appstate INIT-MAP
                                          INIT-PACMAN
                                          INIT-GHOSTS
                                          MAX-SCORE-WO-PP
                                          INIT-PP-ACTIVE
                                          INIT-PACMAN-MOUTH
                                          #false))
(define POST-SCORE-APPSTATE0 (make-appstate INIT-MAP
                                           INIT-PACMAN
                                           INIT-GHOSTS
                                           MAX-SCORE-WO-PP
                                           INIT-PP-ACTIVE
                                           INIT-PACMAN-MOUTH
                                           #true))
(define PRE-SCORE-APPSTATE1 (make-appstate INIT-MAP
                                          INIT-PACMAN
                                          INIT-GHOSTS
                                          (- MAX-SCORE-WO-PP 1)
                                          INIT-PP-ACTIVE
                                          INIT-PACMAN-MOUTH
                                          #false))
(define POST-SCORE-APPSTATE1 (make-appstate INIT-MAP
                                           INIT-PACMAN
                                           INIT-GHOSTS
                                           (- MAX-SCORE-WO-PP 1)
                                           INIT-PP-ACTIVE
                                           INIT-PACMAN-MOUTH
                                           #true))

(check-expect (is-fullscore INIT-APPSTATE) INIT-APPSTATE)
(check-expect (is-fullscore PRE-SCORE-APPSTATE0) POST-SCORE-APPSTATE0)
(check-expect (is-fullscore PRE-SCORE-APPSTATE1) POST-SCORE-APPSTATE1)

;; Code - used by ---TODO IMPLEMENTATION
(define (is-fullscore appstate)
  (local [(define score (appstate-score appstate))]
  (if [>= score MAX-SCORE-WO-PP]
      [quit appstate]
      appstate)))

;*******************************************************************************************************
;; Input/Output
; quit : Appstate -> Appstate
; given an Appstate, it quits the app by changing the correspondent value in the appstate that records it
;; header :
; (define (quit appstate) AppState)

;; Examples

;; Code
(define (quit appstate)
  (make-appstate (appstate-map appstate)
                 (appstate-pacman appstate)
                 (appstate-ghosts appstate)
                 (appstate-score appstate)
                 (appstate-pp-active appstate)
                 (appstate-pacman-mouth appstate)
                 #true))
;*******************************************************************************************************
;;; QUITTER
;; Input/Output
; quit? : Appstate -> Boolean
; takes an appstate and returns a bool indicating whether the app has quit or not
; header :
; (define (quit? appstate) Boolean)

;; Code
(define (quit? appstate)
  (appstate-quit appstate)); edit

;*******************************************************************************************************
;; points handler


(define (add-points appstate obj)
  (make-appstate (appstate-map appstate)
    (+ (appstate-score appstate) (cond [(equal? obj DOT) (DOT-POINTS)]
                                        [(equal? obj CHERRY) (CHERRY-POINTS)]))
    (appstate-pacman appstate)
    (appstate-pp-active appstate)
    (appstate-pacman-mouth appstate)
    (appstate-quit appstate)))

(define DOTS-TOT-POINTS 236)
;(define (points-finished appstate obj)
;  ()

;*********************************************************************************
;*********************************************************************************
;*********************************************************************************
;FIND ELEMENT AT POSITION
;(define (find-in-map state pos)
;  (vector-ref (vector-ref (appstate-map state) (posn-y pos)) (posn-x pos)))


; Map Pac-posn -> Map

;(define (find appstate pos)
 ; (list-ref (list-ref (appstate-map appstate) (posn-y pos)) (posn-x pos)))