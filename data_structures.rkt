;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname data_structures) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; LIBRARIES
(require racket/base)

;*****************************************************************
;*****************************************************************
;; API
; generic settings
(provide SCORE)
(provide MAX-SCORE-WO-PP)
(provide TICK)
(provide SPEED-PACMAN)
(provide SPEED-GHOSTS)
(provide POINTS-DOT)
(provide POINTS-CHERRY)
(provide POINTS-PP)
(provide TOTAL-POINTS-DOTS)
(provide TOTAL-POINTS-CHERRIES)
(provide TOTAL-POINTS-PP)
(provide TOTAL-POINTS)

; map
(provide MAP-WIDTH)
(provide MAP-HEIGHT)
(provide MAP-WIDTH-INDEX)
(provide MAP-HEIGHT-INDEX)

(provide MAP-WALL)
(provide MAP-EMPTY)
(provide MAP-DOT)
(provide MAP-PP)
(provide MAP-CHERRY)
(provide MAP-GATE)
(provide MAP-PACMAN)
(provide MAP-GHOST-ORANGE)
(provide MAP-GHOST-RED)
(provide MAP-GHOST-PINK)
(provide MAP-GHOST-CYAN)

; enum
(provide DIRECTION-UP)
(provide DIRECTION-DOWN)
(provide DIRECTION-LEFT)
(provide DIRECTION-RIGHT)

; struct
(provide (struct-out character))
(provide (struct-out appstate))

; examples
(provide INIT-APPSTATE)
(provide EX-APPSTATE-EDIBLE)

(provide INIT-MAP)
(provide EX-MAP)
(provide INIT-PACMAN)
(provide INIT-GHOSTS)
(provide INIT-SCORE)
(provide INIT-PP-ACTIVE)
(provide INIT-PACMAN-MOUTH)
(provide INIT-QUIT)

;*****************************************************************
;*****************************************************************
;; Generic settings
(define SCORE 0)
(define MAX-SCORE-WO-PP 236)
(define TICK 50)
(define SPEED-PACMAN 1)
(define SPEED-GHOSTS 0.80)

(define POINTS-DOT 10)
(define POINTS-CHERRY 100)
(define POINTS-PP 100)
(define TOTAL-DOTS 236)
(define TOTAL-CHERRIES 4)
(define TOTAL-PP 4)
(define TOTAL-POINTS-DOTS (* TOTAL-DOTS POINTS-DOT))
(define TOTAL-POINTS-CHERRIES (* TOTAL-CHERRIES POINTS-CHERRY))
(define TOTAL-POINTS-PP (* TOTAL-PP POINTS-PP))
(define TOTAL-POINTS (+ TOTAL-POINTS-DOTS TOTAL-POINTS-CHERRIES TOTAL-POINTS-PP))

;*****************************************************************
;; Data type
; Map is a Vector<String>
(define MAP-WIDTH 31)
(define MAP-HEIGHT 28)
(define MAP-WIDTH-INDEX 30)
(define MAP-HEIGHT-INDEX 27)

; map elements representation:
; - "W" wall
; - " " empty cell space
; - "." dot point
; - "@" power pellet
; - "Y" cherry
; - "P" pacman
; - "_" ghost gate
; - ghosts:
;   - "e" special edible ghost
;   - "o" orange
;   - "r" red
;   - "p" pink
;   - "c" cyan

(define MAP-WALL #\W)
(define MAP-EMPTY #\ )
(define MAP-DOT #\.)
(define MAP-PP #\@)
(define MAP-CHERRY #\Y)
(define MAP-GATE #\_)
(define MAP-PACMAN #\P)
(define MAP-GHOST-ORANGE #\o)
(define MAP-GHOST-RED #\r)
(define MAP-GHOST-PINK #\p)
(define MAP-GHOST-CYAN #\c)

;; Examples
; test map 31x28 -> '.' 240
(define EX-MAP (vector
                "WWWWWWWWWWWWWWWWWWWWWWWWWWWW"
                "W.....Y......WW......Y.....W"
                "W.WWWW.WWWWW.WW.WWWWW.WWWW.W"
                "W@W  W.W   W.WW.W   W.W  W@W"
                "W.WWWW.WWWWW.WW.WWWWW.WWWW.W"
                "W..........................W"
                "W.WWWW.WW.WWWWWWWW.WW.WWWW.W"
                "W.WWWW.WW.WWWWWWWW.WW.WWWW.W"
                "W......WW....WW....WW......W"
                "WWWWWW.WWWWW WW WWWWW.WWWWWW"
                "     W.WWWWW WW WWWWW.W     "
                "     W.WW          WW.W     "
                "     W.WW WWW__WWW WW.W     "
                "WWWWWW.WW W      W WW.WWWWWW"
                "      .   W      W   .      "
                "WWWWWW.WW W      W WW.WWWWWW"
                "     W.WW WWWWWWWW WW.W     "
                "     W.WW          WW.W     "
                "     W.WW WWWWWWWW WW.W     "
                "WWWWWW.WW WWWWWWWW WW.WWWWWW"
                "W............WW............W"
                "W.WWWW.WWWWW.WW.WWWWW.WWWW.W"
                "W.WWWW.WWWWW.WW.WWWWW.WWWW.W"
                "W@..WW.......  .......WW..@W"
                "WWW.WW.WW.WWWWWWWW.WW.WW.WWW"
                "WWW.WW.WW.WWWWWWWW.WW.WW.WWW"
                "W......WW....WW....WW......W"
                "W.WWWWWWWWWW.WW.WWWWWWWWWW.W"
                "W.WWWWWWWWWW.WW.WWWWWWWWWW.W"
                "W.....Y..............Y.....W"
                "WWWWWWWWWWWWWWWWWWWWWWWWWWWW"))

; '.' 236
(define INIT-MAP (vector
                "WWWWWWWWWWWWWWWWWWWWWWWWWWWW"     ; 0
                "W.....Y......WW......Y.....W"
                "W.WWWW.WWWWW.WW.WWWWW.WWWW.W"
                "W@W  W.W   W.WW.W   W.W  W@W"
                "W.WWWW.WWWWW.WW.WWWWW.WWWW.W"
                "W..........................W"     ; 5
                "W.WWWW.WW.WWWWWWWW.WW.WWWW.W"
                "W.WWWW.WW.WWWWWWWW.WW.WWWW.W"
                "W......WW....WW....WW......W"
                "WWWWWW.WWWWW WW WWWWW.WWWWWW"
                "     W.WWWWW WW WWWWW.W     "     ; 10
                "     W.WW          WW.W     "
                "     W.WW WWW__WWW WW.W     "
                "WWWWWW.WW W    r W WW.WWWWWW"
                "      .   W o    W   .      "
                "WWWWWW.WW W p  c W WW.WWWWWW"     ; 15
                "     W.WW WWWWWWWW WW.W     "
                "     W.WW    P     WW.W     "
                "     W.WW WWWWWWWW WW.W     "
                "WWWWWW.WW WWWWWWWW WW.WWWWWW"
                "W............WW............W"     ; 20
                "W.WWWW.WWWWW.WW.WWWWW.WWWW.W"
                "W.WWWW.WWWWW.WW.WWWWW.WWWW.W"
                "W@..WW.......  .......WW..@W"
                "WWW.WW.WW.WWWWWWWW.WW.WW.WWW"
                "WWW.WW.WW.WWWWWWWW.WW.WW.WWW"     ; 25
                "W......WW....WW....WW......W"
                "W.WWWWWWWWWW.WW.WWWWWWWWWW.W"
                "W.WWWWWWWWWW.WW.WWWWWWWWWW.W"
                "W.....Y..............Y.....W"
                "WWWWWWWWWWWWWWWWWWWWWWWWWWWW"))   ; 30

;*****************************************************************
;; Data type
; Direction is an enumerator
; Up
; Down
; Left
; Right

;; Constants
(define DIRECTION-UP #\u)
(define DIRECTION-DOWN #\d)
(define DIRECTION-LEFT #\l)
(define DIRECTION-RIGHT #\r)

;*****************************************************************
;; Data type
; Character is a struct: (make-character name direction position)
;            name : Char
;        position : Posn
;       direction : Direction
(define-struct character [name direction position] #:transparent)

; Examples
(define INIT-PACMAN (make-character MAP-PACMAN DIRECTION-RIGHT (make-posn 14 17)))
(define INIT-GHOST1 (make-character MAP-GHOST-RED DIRECTION-DOWN (make-posn 16 13)))
(define INIT-GHOST2 (make-character MAP-GHOST-ORANGE DIRECTION-UP (make-posn 13 14)))
(define INIT-GHOST3 (make-character MAP-GHOST-PINK DIRECTION-RIGHT (make-posn 13 15)))
(define INIT-GHOST4 (make-character MAP-GHOST-CYAN DIRECTION-LEFT (make-posn 16 15)))

;*******************************************************************
;; Data type
; Appstate is a struct: (make-labyrinth map score pp-active? pacman-mouth)
; where     map : Vector<String>
;        pacman : Character
;        ghosts : List<Character>
;         score : Natural
;     pp-active : Boolean
;  pacman-mouth : Boolean (VFX)
;          quit : Boolean
(define-struct appstate [map pacman ghosts score pp-active pacman-mouth quit] #:transparent)

;; Examples
(define INIT-GHOSTS (list INIT-GHOST1 INIT-GHOST2 INIT-GHOST3 INIT-GHOST4))
(define INIT-SCORE 0)
(define INIT-PP-ACTIVE #false)
(define INIT-PACMAN-MOUTH #true)
(define INIT-QUIT #false)

(define INIT-APPSTATE (make-appstate INIT-MAP INIT-PACMAN INIT-GHOSTS INIT-SCORE INIT-PP-ACTIVE INIT-PACMAN-MOUTH INIT-QUIT))
(define EX-APPSTATE-EDIBLE (make-appstate INIT-MAP INIT-PACMAN INIT-GHOSTS INIT-SCORE #true INIT-PACMAN-MOUTH INIT-QUIT))
