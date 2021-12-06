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
(provide (struct-out pacman))
(provide (struct-out ghost))
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
(provide INIT-QUIT)

(provide INIT-PACMAN-POSN)
(provide INIT-GHOST1-POSN)
(provide INIT-GHOST2-POSN)
(provide INIT-GHOST3-POSN)
(provide INIT-GHOST4-POSN) 

;*****************************************************************
;*****************************************************************
;; Generic settings
(define SCORE 0)
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
(define MAP-WIDTH-INDEX (- MAP-WIDTH 1))
(define MAP-HEIGHT-INDEX (- MAP-HEIGHT 1))

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
(define INIT-PACMAN-POSN (make-posn 14 17))
(define INIT-GHOST1-POSN (make-posn 16 13))
(define INIT-GHOST2-POSN (make-posn 13 14))
(define INIT-GHOST3-POSN (make-posn 13 15))
(define INIT-GHOST4-POSN (make-posn 16 15)) 
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

;; Examples
(define INIT-PACMAN-CHARACTER (make-character MAP-PACMAN DIRECTION-RIGHT INIT-PACMAN-POSN))
(define INIT-GHOST1-CHARACTER (make-character MAP-GHOST-RED DIRECTION-DOWN INIT-GHOST1-POSN))
(define INIT-GHOST2-CHARACTER (make-character MAP-GHOST-ORANGE DIRECTION-UP INIT-GHOST2-POSN))
(define INIT-GHOST3-CHARACTER (make-character MAP-GHOST-PINK DIRECTION-RIGHT INIT-GHOST3-POSN))
(define INIT-GHOST4-CHARACTER (make-character MAP-GHOST-CYAN DIRECTION-LEFT INIT-GHOST4-POSN))

;*******************************************************************
;; Data type
; Pacman is a struct: (make-pacman moving mouth)
; where moving : Character
;        mouth : Boolean (VFX)
(define-struct pacman [character mouth] #:transparent)

;; Examples
(define INIT-PACMAN (make-pacman INIT-PACMAN-CHARACTER #true))

;*****************************************************************
; Ghost is a struct: (make-ghost name moving hidden-element)
; where   
; where      character : Character
;       hidden-element : Char
(define-struct ghost [character hidden-element] #:transparent)

;; Examples
(define INIT-HIDDEN-ELEMENT #\ )
(define INIT-GHOST1 (make-ghost INIT-GHOST1-CHARACTER INIT-HIDDEN-ELEMENT))
(define INIT-GHOST2 (make-ghost INIT-GHOST2-CHARACTER INIT-HIDDEN-ELEMENT))
(define INIT-GHOST3 (make-ghost INIT-GHOST3-CHARACTER INIT-HIDDEN-ELEMENT))
(define INIT-GHOST4 (make-ghost INIT-GHOST4-CHARACTER INIT-HIDDEN-ELEMENT))

;*******************************************************************
;; Data type
; Appstate is a struct: (make-labyrinth map score pp-active? pacman-mouth)
; where     map : Vector<String>
;        pacman : Pacman
;        ghosts : List<Ghost>
;         score : Natural
;     pp-active : Boolean
;          quit : Boolean
(define-struct appstate [map pacman ghosts score pp-active quit] #:transparent)

;; Examples
(define INIT-GHOSTS (list INIT-GHOST1 INIT-GHOST2 INIT-GHOST3 INIT-GHOST4))
(define INIT-SCORE 0)
(define INIT-PP-ACTIVE #false)
(define INIT-QUIT #false)

(define INIT-APPSTATE (make-appstate INIT-MAP INIT-PACMAN INIT-GHOSTS INIT-SCORE INIT-PP-ACTIVE INIT-QUIT))
(define EX-APPSTATE-EDIBLE (make-appstate INIT-MAP INIT-PACMAN INIT-GHOSTS INIT-SCORE #true INIT-QUIT))