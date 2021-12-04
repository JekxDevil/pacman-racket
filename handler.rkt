;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname handler) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; LIBRARIES
(require 2htdp/image)
(require "data_structures.rkt")
(require "figures.rkt")
(require "render.rkt")
;*********************************************************************************

(define (edit key state)
  (cond
    [(equal? key "left") (move-left state)]
    [(equal? key "right") (move-right state)]
    [(equal? key "up") (move-up state)]
    [(equal? key "down") (move-down state)]
    [else state]))


;MOVE-LEFT FUNCTION
; I/O
; move-left: appstate --> appstate
; header (define (move-left appstate) appstate)
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
;MOVE-RIGHT FUNCTION
; I/O
; move-right: appstate --> appstate
; header (define (move-right appstate) appstate)
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
;MOVE-DOWN FUNCTION
; I/O
; move-down: appstate --> appstate
; header (define (move-down appstate) appstate)

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
;MOVE-UP FUNCTION
; I/O
; move-up: appstate --> appstate
; header (define (move-up appstate) appstate)

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
; quit : AppState -> AppState
; given an AppState, it quits the app by changing the correspondent value in the appstate that records it
;; header :
; (define (quit appstate) AppState)

;; Examples
(check-expect ())

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
; quit? : AppState -> Boolean
; takes an appstate and returns a bool indicating whether the app has quit or not
; header :
; (define (quit? appstate) Boolean)

;; Code
(define (quit? appstate)
  (appstate-quit appstate))

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
(define (points-finished appstate obj)
  ()