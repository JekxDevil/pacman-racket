;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname handler) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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
;;; KEY HANDLER
;; Input/Output
; key-handler : Appstate Key -> Appstate
; handler keystroke events of the game
; header :
; (define (key-handler appstate key) Appstate)

;; Examples

;; Template

;; Code - used by (big-bang)
(define (key-handler appstate key)
  (cond [(equal? key "up") (move-pacman appstate)]
        [(equal? key "down") (move-pacman appstate)]
        [(equal? key "left") (move-pacman appstate)]
        [(equal? key "right") (move-pacman appstate)]
        [else appstate]))

;*********************************************************************************
;;; MOVE POSN
;; Input/Output
; move-posn : Posn Direction -> Posn
; create a new position given direction and previous position
; all position will be in map borders (pacman-effect)
; header :
; (define (move-posn posn direction) Posn)

;; Examples
(define EX-POSN0 (make-posn 0 5))
(define EX-POSN1 (make-posn 1 5))
(define EX-POSN2 (make-posn MAP-WIDTH-INDEX 5))
(define EX-POSN3 (make-posn (- MAP-WIDTH-INDEX 1) 5))
(define EX-POSN4 (make-posn 5 0))
(define EX-POSN5 (make-posn 5 1))
(define EX-POSN6 (make-posn 5 MAP-HEIGHT-INDEX))
(define EX-POSN7 (make-posn 5 (- MAP-HEIGHT-INDEX 1)))

(check-expect (move-posn EX-POSN0 DIRECTION-LEFT) EX-POSN2)
(check-expect (move-posn EX-POSN1 DIRECTION-LEFT) EX-POSN0)
(check-expect (move-posn EX-POSN2 DIRECTION-RIGHT) EX-POSN0)
(check-expect (move-posn EX-POSN3 DIRECTION-RIGHT) EX-POSN2)
(check-expect (move-posn EX-POSN4 DIRECTION-UP) EX-POSN6)
(check-expect (move-posn EX-POSN5 DIRECTION-UP) EX-POSN4)
(check-expect (move-posn EX-POSN6 DIRECTION-DOWN) EX-POSN4)
(check-expect (move-posn EX-POSN7 DIRECTION-DOWN) EX-POSN6)

;; Template

;; Code - used by 
(define (move-posn posn direction)
  (cond [(char=? direction DIRECTION-UP) (make-posn (posn-x posn)
                                                    (if [< (- (posn-y posn) 1) 0] MAP-HEIGHT-INDEX [- (posn-y posn) 1]))]
        [(char=? direction DIRECTION-DOWN) (make-posn (posn-x posn)
                                                      (if [> (+ (posn-y posn) 1) MAP-HEIGHT-INDEX] 0 [+ (posn-y posn) 1]))]
        [(char=? direction DIRECTION-LEFT) (make-posn (if [< (- (posn-x posn) 1) 0] MAP-WIDTH-INDEX [- (posn-x posn) 1])
                                                      (posn-y posn))]
        [(char=? direction DIRECTION-RIGHT) (make-posn (if [> (+ (posn-x posn) 1) MAP-WIDTH-INDEX]  0 [+ (posn-x posn) 1])
                                                       (posn-y posn))]))
;*********************************************************************************
;;; FIND ELEMENT CHAR IN MAP
;; Input/Output
; find-in-map : Map Posn -> Char
; given the appstate and a position, return the element at that map position
; header :
; (define (find-in-map Map posn) Char)

;; Examples

;; Template

;; Code - used by 
(define (find-in-map map posn)
  (string-ref (vector-ref map (posn-y posn)) (posn-x posn)))

;*********************************************************************************
;;; MOVE PACMAN
;; Input/Output
; move-pacman: Appstate Character -> Appstate
; handles pacman move logic
; header :
; (define (move appstate character) Character)

;; Examples

;; Template

;; TODO AGGIUNGERE (map-update)
;; Code - used by (key-handler)
(define (move-pacman appstate)
  (local [(define name (character-name (pacman-character (appstate-pacman appstate))))
          (define direction (character-direction (pacman-character (appstate-pacman appstate))))
          (define posn (character-position (pacman-character (appstate-pacman appstate))))
          (define mouth (pacman-mouth (appstate-pacman appstate)))
          (define posn-next (move-posn posn direction))
          (define new-pacman (make-pacman (make-character name direction posn-next) mouth))
          (define element-next (find-in-map (appstate-map appstate) posn-next))]
    (cond [(or (char=? MAP-GATE element-next) (char=? MAP-WALL element-next)) appstate]
          [(char=? MAP-DOT element-next) (make-appstate (appstate-map appstate) new-pacman (appstate-ghosts appstate)
                                                         (+ POINTS-DOT (appstate-score appstate)) (appstate-pp-active appstate)
                                                         (appstate-quit appstate))]
          [(char=? MAP-PP element-next) (make-appstate (appstate-map appstate) new-pacman (appstate-ghosts appstate)
                                                         (+ POINTS-PP (appstate-score appstate)) #true
                                                         (appstate-quit appstate))]
          [(char=? MAP-CHERRY element-next) (make-appstate (appstate-map appstate) new-pacman (appstate-ghosts appstate)
                                                           (+ POINTS-CHERRY (appstate-score appstate)) (appstate-pp-active appstate)
                                                           (appstate-quit appstate))]
          [(char=? MAP-EMPTY element-next) (make-appstate (appstate-map appstate) new-pacman (appstate-ghosts appstate)
                                                         (appstate-score appstate) (appstate-pp-active appstate)
                                                         (appstate-quit appstate))]
          [(or (char=? MAP-GHOST-RED element-next)
               (char=? MAP-GHOST-PINK element-next)
               (char=? MAP-GHOST-ORANGE element-next)
               (char=? MAP-GHOST-CYAN element-next)) (check-edible appstate new-pacman)])))


;          [(equal? element-next MAP-GHOST-EDIBLE) (make-appstate (map-update state) ;; NON ESISTE
;                                                                 (+ (appstate-score state) 100)
;                                                                 (appstate-pp-active? state)
;                                                                 (appstate-pacman-mouth state)
;                                                                 (make-character ("Pac-Man" "l" pac-next))
;                                                                 (appstate-ghost state)
;                                                                 #false)]
;*******************************************************************************************************
;;; CHECK GHOST EDIBLE
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

;; Code - used by (move-pacman)
(define (check-edible appstate new-pacman)
  (if [appstate-pp-active appstate]
      [make-appstate (appstate-map appstate) new-pacman (appstate-ghosts appstate)
                     (appstate-score appstate) (appstate-pp-active appstate)
                     (appstate-quit appstate)]
      [quit appstate]))

;*******************************************************************************************************
;;; CHECK FULL SCORE
;; Input/Output
; check-fullscore : Appstate -> Appstate
; check if score is full, if it is the quit attribute in appstate becomes true
; header:
; (define (is-fullscore appstate) Appstate)

;; Examples
(define PRE-SCORE-APPSTATE0 (make-appstate INIT-MAP INIT-PACMAN INIT-GHOSTS TOTAL-POINTS
                                           INIT-PP-ACTIVE #false))
(define POST-SCORE-APPSTATE0 (make-appstate INIT-MAP INIT-PACMAN INIT-GHOSTS TOTAL-POINTS
                                            INIT-PP-ACTIVE #true))
(define PRE-SCORE-APPSTATE1 (make-appstate INIT-MAP INIT-PACMAN INIT-GHOSTS (- TOTAL-POINTS 1)
                                           INIT-PP-ACTIVE #false))
(define POST-SCORE-APPSTATE1 (make-appstate INIT-MAP INIT-PACMAN INIT-GHOSTS (- TOTAL-POINTS 1)
                                            INIT-PP-ACTIVE #false))

(check-expect (check-fullscore INIT-APPSTATE) INIT-APPSTATE)
(check-expect (check-fullscore PRE-SCORE-APPSTATE0) POST-SCORE-APPSTATE0)
(check-expect (check-fullscore PRE-SCORE-APPSTATE1) POST-SCORE-APPSTATE1)

;; Template

;; Code - used by ---TODO IMPLEMENTATION
(define (check-fullscore appstate)
  (local [(define score (appstate-score appstate))]
  (if [>= score TOTAL-POINTS]
      [quit appstate]
      appstate)))

;*******************************************************************************************************
;;; QUITTER
;; Input/Output
; quit : Appstate -> Appstate
; given an Appstate, it quits the app by changing the correspondent value in the appstate that records it
; header :
; (define (quit appstate) AppState)

;; Examples
(define END-STATE (make-appstate INIT-MAP INIT-PACMAN INIT-GHOSTS INIT-SCORE INIT-PP-ACTIVE #true))
(check-expect (quit END-STATE) END-STATE)
(check-expect (quit INIT-APPSTATE) (make-appstate INIT-MAP INIT-PACMAN INIT-GHOSTS INIT-SCORE INIT-PP-ACTIVE  #true))

;; Template

;; Code - used by (...)
(define (quit appstate)
  (make-appstate (appstate-map appstate)
                 (appstate-pacman appstate)
                 (appstate-ghosts appstate)
                 (appstate-score appstate)
                 (appstate-pp-active appstate)
                 #true))
;*******************************************************************************************************
;;; HAS QUIT ?
;; Input/Output
; quit? : Appstate -> Boolean
; takes an appstate and returns a bool indicating whether the app has quit or not
; header :
; (define (quit? appstate) Boolean)

;; Examples
(check-expect (quit? INIT-APPSTATE) #false)
(check-expect (quit? END-STATE) #true)

;; Template

;; Code - used by (big-bang)
(define (quit? appstate)
  (appstate-quit appstate)); edit

;*******************************************************************************************************
;;;; POINTS HANDLER
;;; Input/Output
;; add-points : Appstate Char -> Appstate
;;
;; header :
;; (define (add-points appstate char) Appstate)
;
;;; Examples
;
;;; Template
;
;;; Code - used by (...)
;(define (add-points appstate char)
;  (make-appstate (appstate-map appstate)
;    (appstate-pacman appstate)
;    (appstate-ghosts appstate)
;    (+ (appstate-score appstate) (cond [(equal? char MAP-DOT) (DOT-POINTS)]
;                                       [(equal? char MAP-CHERRY) (CHERRY-POINTS)]))
;    (appstate-pp-active appstate)
;    (appstate-pacman-mouth appstate)
;    (appstate-quit appstate)))

;*******************************************************************************************************
; tests
; (define (find state pos)
;   (vector-ref (vector-ref (appstate-map state) (posn-y pos)) (posn-x pos)))

;*********************************************************************************
;*********************************************************************************
;*********************************************************************************
;FIND ELEMENT AT POSITION
;(define (find-in-map state pos)
;  (vector-ref (vector-ref (appstate-map state) (posn-y pos)) (posn-x pos)))


; Map Pac-posn -> Map

;(define (find appstate pos)
 ; (list-ref (list-ref (appstate-map appstate) (posn-y pos)) (posn-x pos)))