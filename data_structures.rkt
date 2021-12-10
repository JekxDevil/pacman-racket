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
;(provide TICK-PACMAN)
;(provide TICK-GHOSTS)
(provide LIMIT-POWERPELLET-ACTIVE)
(provide POINTS-DOT)
(provide POINTS-CHERRY)
(provide POINTS-POWERPELLET)
(provide TOTAL-POINTS-DOTS)
(provide TOTAL-POINTS-CHERRIES)
(provide TOTAL-POINTS-POWERPELLET)
(provide TOTAL-POINTS)

; map
(provide MAP-WIDTH)
(provide MAP-HEIGHT)
(provide MAP-WIDTH-INDEX)
(provide MAP-HEIGHT-INDEX)

(provide MAP-WALL)
(provide MAP-EMPTY)
(provide MAP-DOT)
(provide MAP-POWERPELLET)
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
(provide (struct-out powerpellet-effect)) ;; non ha senso mantenere una lista di pp perche' non li muoviamo
(provide (struct-out appstate))

; examples
(provide INIT-APPSTATE)
(provide EX-APPSTATE-EDIBLE)

(provide INIT-MAP)
(provide EX-MAP)
(provide INIT-PACMAN)
(provide INIT-GHOSTS)
(provide INIT-SCORE)
(provide INIT-POWERPELLET-EFFECT)
(provide INIT-QUIT)

(provide INIT-GHOST-RED)
(provide INIT-GHOST-ORANGE)
(provide INIT-GHOST-PINK)
(provide INIT-GHOST-CYAN)

(provide INIT-PACMAN-POSN)
(provide INIT-GHOST-RED-POSN)
(provide INIT-GHOST-ORANGE-POSN)
(provide INIT-GHOST-PINK-POSN)
(provide INIT-GHOST-CYAN-POSN)

(provide INIT-ITEM-BELOW)

;*****************************************************************
;*****************************************************************
;; Generic settings
(define SCORE 0)
(define TICK 25/100)
;(define TICK-PACMAN 3/10)
;(define TICK-GHOSTS 5/10)
(define LIMIT-POWERPELLET-ACTIVE 5)

(define POINTS-DOT 10)
(define POINTS-CHERRY 100)
(define POINTS-POWERPELLET 100)
(define TOTAL-DOTS 236)
(define TOTAL-CHERRIES 4)
(define TOTAL-POWERPELLET 4)
(define TOTAL-POINTS-DOTS (* TOTAL-DOTS POINTS-DOT))
(define TOTAL-POINTS-CHERRIES (* TOTAL-CHERRIES POINTS-CHERRY))
(define TOTAL-POINTS-POWERPELLET (* TOTAL-POWERPELLET POINTS-POWERPELLET))
(define TOTAL-POINTS (+ TOTAL-POINTS-DOTS TOTAL-POINTS-CHERRIES TOTAL-POINTS-POWERPELLET)) ; 3160

;*****************************************************************
;; Data type
; Map is a Vector<String>
(define MAP-WIDTH 28)
(define MAP-HEIGHT 31)
(define MAP-WIDTH-INDEX (- MAP-WIDTH 1))
(define MAP-HEIGHT-INDEX (- MAP-HEIGHT 1))

; map items representation:
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
(define MAP-POWERPELLET #\@)
(define MAP-CHERRY #\Y)
(define MAP-GATE #\_)
(define MAP-PACMAN #\P)
(define MAP-GHOST-ORANGE #\o)
(define MAP-GHOST-RED #\r)
(define MAP-GHOST-PINK #\p)
(define MAP-GHOST-CYAN #\c)

;; Examples
; test map 28x31 -> '.' 240
(define EX-MAP (vector "WWWWWWWWWWWWWWWWWWWWWWWWWWWW"
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
(define INIT-PACMAN-POSN (make-posn 13 17))
(define INIT-GHOST-RED-POSN (make-posn 15 13))
(define INIT-GHOST-ORANGE-POSN (make-posn 12 14))
(define INIT-GHOST-PINK-POSN (make-posn 12 15))
(define INIT-GHOST-CYAN-POSN (make-posn 15 15))
(define INIT-MAP (vector "WWWWWWWWWWWWWWWWWWWWWWWWWWWW";--- 0
                         "W.....Y......WW......Y.....W"
                         "W.WWWW.WWWWW.WW.WWWWW.WWWW.W"
                         "W@W  W.W   W.WW.W   W.W  W@W"
                         "W.WWWW.WWWWW.WW.WWWWW.WWWW.W"
                         "W..........................W";--- 5
                         "W.WWWW.WW.WWWWWWWW.WW.WWWW.W"
                         "W.WWWW.WW.WWWWWWWW.WW.WWWW.W"
                         "W......WW....WW....WW......W"
                         "WWWWWW.WWWWW WW WWWWW.WWWWWW"
                         "     W.WWWWW WW WWWWW.W     ";--- 10
                         "     W.WW          WW.W     "
                         "     W.WW WWW__WWW WW.W     "
                         "WWWWWW.WW W    r W WW.WWWWWW"
                         "      .   W o    W   .      "
                         "WWWWWW.WW W p  c W WW.WWWWWW";--- 15
                         "     W.WW WWWWWWWW WW.W     "
                         "     W.WW    P     WW.W     "
                         "     W.WW WWWWWWWW WW.W     "
                         "WWWWWW.WW WWWWWWWW WW.WWWWWW"
                         "W............WW............W";--- 20
                         "W.WWWW.WWWWW.WW.WWWWW.WWWW.W"
                         "W.WWWW.WWWWW.WW.WWWWW.WWWW.W"
                         "W@..WW.......  .......WW..@W"
                         "WWW.WW.WW.WWWWWWWW.WW.WW.WWW"
                         "WWW.WW.WW.WWWWWWWW.WW.WW.WWW";--- 25
                         "W......WW....WW....WW......W"
                         "W.WWWWWWWWWW.WW.WWWWWWWWWW.W"
                         "W.WWWWWWWWWW.WW.WWWWWWWWWW.W"
                         "W.....Y..............Y.....W"
                         "WWWWWWWWWWWWWWWWWWWWWWWWWWWW"));- 30

;*****************************************************************
;; Data type
; Direction is an Enumerator
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
(define-struct character [name direction position item-below] #:transparent)

;; Examples
(define INIT-ITEM-BELOW #\ )
(define INIT-PACMAN-CHARACTER (make-character MAP-PACMAN DIRECTION-RIGHT INIT-PACMAN-POSN INIT-ITEM-BELOW))
(define INIT-GHOST-RED (make-character MAP-GHOST-RED DIRECTION-DOWN INIT-GHOST-RED-POSN INIT-ITEM-BELOW))
(define INIT-GHOST-ORANGE (make-character MAP-GHOST-ORANGE DIRECTION-UP INIT-GHOST-ORANGE-POSN INIT-ITEM-BELOW))
(define INIT-GHOST-PINK (make-character MAP-GHOST-PINK DIRECTION-RIGHT INIT-GHOST-PINK-POSN INIT-ITEM-BELOW))
(define INIT-GHOST-CYAN (make-character MAP-GHOST-CYAN DIRECTION-LEFT INIT-GHOST-CYAN-POSN INIT-ITEM-BELOW))

;*******************************************************************
;; Data type
; Pacman is a struct: (make-pacman moving mouth)
; where moving : Character
;        mouth : Boolean (VFX)
(define-struct pacman [character mouth] #:transparent)

;; Examples
(define INIT-PACMAN (make-pacman INIT-PACMAN-CHARACTER #true))

;*******************************************************************
;; Data type
; powerpellet-effect is a struct: (make-powerpellet-effect active active-ticks)
; where       active : Boolean
;       active-ticks : Natural
(define-struct powerpellet-effect [active ticks] #:transparent)

;; Examples
(define INIT-POWERPELLET-EFFECT (make-powerpellet-effect #false 0))
(define EX-POWERPELLET-EFFECT-EDIBLE (make-powerpellet-effect #true 0))

;*******************************************************************
;; Data type
; Appstate is a struct: (make-appstate map score pp-active? pacman-mouth)
; where                map : Vector<String>
;                   pacman : Pacman
;                   ghosts : List<Character>
;                    score : Natural
;       powerpellet-effect : Powerpellet-effect
;                     quit : Boolean
(define-struct appstate [map pacman ghosts score powerpellet-effect quit] #:transparent)

;; Examples
(define INIT-GHOSTS (list INIT-GHOST-RED INIT-GHOST-ORANGE INIT-GHOST-PINK INIT-GHOST-CYAN))
(define INIT-SCORE 0)
(define INIT-QUIT #false)

(define INIT-APPSTATE (make-appstate INIT-MAP INIT-PACMAN INIT-GHOSTS INIT-SCORE INIT-POWERPELLET-EFFECT INIT-QUIT))
(define EX-APPSTATE-EDIBLE (make-appstate INIT-MAP INIT-PACMAN INIT-GHOSTS INIT-SCORE EX-POWERPELLET-EFFECT-EDIBLE INIT-QUIT))