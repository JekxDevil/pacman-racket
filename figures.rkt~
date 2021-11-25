;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname pacman) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define PACMAN-OPEN (rotate 30 (wedge 30 300 "solid" "gold")))
(define PACMAN-CLOSE (circle 30 "solid" "gold"))
;-----------------------------------
;RED GHOST
(define GHOR1 (overlay/offset (rectangle 50 30 "solid" "red")
                  0 -19
                  (circle 25 "solid" "red")))
(define GHOR2 (underlay/offset GHOR1
                   0 -10
                   (underlay/offset (circle 7 "solid" "white")
                                   -30 0
                                   (circle 7 "solid" "white"))))
(define GHOSTRED (underlay/offset GHOR2
                   0 -10
                   (underlay/offset (circle 3 "solid" "blue")
                                   -30 0
                                   (circle 3 "solid" "blue"))))
;-------------------------------
;PINK GHOST
(define GHOP1 (overlay/offset (rectangle 50 30 "solid" "pink")
                  0 -19
                  (circle 25 "solid" "pink")))
(define GHOP2 (underlay/offset GHOP1
                   0 -10
                   (underlay/offset (circle 7 "solid" "white")
                                   -30 0
                                   (circle 7 "solid" "white"))))
(define GHOSTPINK (underlay/offset GHOP2
                   0 -10
                   (underlay/offset (circle 3 "solid" "blue")
                                   -30 0
                                   (circle 3 "solid" "blue"))))
;-----------------------------
;CYAN GHOST

(define GHOC1 (overlay/offset (rectangle 50 30 "solid" "cyan")
                  0 -19
                  (circle 25 "solid" "cyan")))
(define GHOC2 (underlay/offset GHOC1
                   0 -10
                   (underlay/offset (circle 7 "solid" "white")
                                   -30 0
                                   (circle 7 "solid" "white"))))
(define GHOSTCYAN (underlay/offset GHOC2
                   0 -10
                   (underlay/offset (circle 3 "solid" "blue")
                                   -30 0
                                   (circle 3 "solid" "blue"))))
;-----------------------------
;ORANGE GHOST

(define GHOO1 (overlay/offset (rectangle 50 30 "solid" "orange")
                  0 -19
                  (circle 25 "solid" "orange")))
(define GHOO2 (underlay/offset GHOO1
                   0 -10
                   (underlay/offset (circle 7 "solid" "white")
                                   -30 0
                                   (circle 7 "solid" "white"))))
(define GHOSTORANGE (underlay/offset GHOO2
                   0 -10
                   (underlay/offset (circle 3 "solid" "blue")
                                   -30 0
                                   (circle 3 "solid" "blue"))))

;---------------------------
;BLUEGHOST

(define T1 (overlay/offset (isosceles-triangle 5 300 "solid" "white") 5 0 (isosceles-triangle 5 300 "solid" "white")))
(define T2 (overlay/offset T1 8 0 (isosceles-triangle 5 300 "solid" "white")))
(define T3 (overlay/offset T2 11 0 (isosceles-triangle 5 300 "solid" "white")))
(define T4 (overlay/offset T3 14 0 (isosceles-triangle 5 300 "solid" "white")))

(define GHOB1 (overlay/offset (rectangle 50 30 "solid" "blue")
                  0 -19
                  (circle 25 "solid" "blue")))
(define GHOB2 (underlay/offset GHOB1
                   0 -10
                   (underlay/offset (circle 7 "solid" "white")
                                   -30 0
                                   (circle 7 "solid" "white"))))
(define GHOSTBLUE1 (underlay/offset GHOB2
                   0 5 T4))
(define GHOSTBLUE (underlay/offset GHOSTBLUE1
                   2 7 (rotate 180 T4)))
;-----------------------------
;DOT
(define DOT (circle 6 "solid" "Papaya Whip"))

;-----------------------------
;POWERPELLETS

(define PP (circle 10 "solid" "Khaki"))

;-----------------------------
;CHERRY
(define GAMBO (beside
   (line 10 -10 (pen "brown" 5 "long-dash" "butt" "round"))
   (flip-horizontal
    (line 10 -10 (pen "brown" 5 "long-dash" "butt" "round")))))
(define CHERRY1 (overlay/offset (circle 10 "solid" "firebrick")
                  2 2
                  (circle 10 "solid" "light coral")))
(define CHERRY2 (overlay/offset CHERRY1 20 0 CHERRY1))

(define CHERRY (overlay/offset GAMBO 0 10 CHERRY2))