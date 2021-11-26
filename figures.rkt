;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname figures) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;<<<<<<< HEAD
;=======
; modularity
(require racket/base)
(provide PACMAN-OPEN)
(provide PACMAN-CLOSE)
(provide GHOST-RED)
(provide GHOST-PINK)
(provide GHOST-CYAN)
(provide GHOST-ORANGE)
(provide GHOST-BLUE)   ;TODISCUSS change to GHOST-EDIBLE ? need to state clearly its behaviour is different
(provide DOT)
(provide PP)
(provide CHERRY)

;>>>>>>> 31f29d27e1865f20579c3236e1674afd7c9b48c7
(require 2htdp/image)
(require 2htdp/universe)
(define BG (square 60  "solid" "black"))

(define PACMAN-OPEN (rotate 30 (wedge 30 300 "solid" "gold")))
(define PACMAN-CLOSE (circle 30 "solid" "gold"))
(define PACMAN1 (place-image/align PACMAN-OPEN 30 30 "center" "center" BG))
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
(define GHOST-RED (underlay/offset GHOR2
                   0 -10
                   (underlay/offset (circle 3 "solid" "blue")
                                   -30 0
                                   (circle 3 "solid" "blue"))))
(define RED (place-image/align GHOST-RED 30 30 "center" "center" BG))
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
(define GHOST-PINK (underlay/offset GHOP2
                   0 -10
                   (underlay/offset (circle 3 "solid" "blue")
                                   -30 0
                                   (circle 3 "solid" "blue"))))
(define PINK (place-image/align GHOST-PINK 30 30 "center" "center" BG))
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
(define GHOST-CYAN (underlay/offset GHOC2
                   0 -10
                   (underlay/offset (circle 3 "solid" "blue")
                                   -30 0
                                   (circle 3 "solid" "blue"))))
(define CYAN (place-image/align GHOST-CYAN 30 30 "center" "center" BG))
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
(define GHOST-ORANGE (underlay/offset GHOO2
                   0 -10
                   (underlay/offset (circle 3 "solid" "blue")
                                   -30 0
                                   (circle 3 "solid" "blue"))))
(define ORANGE (place-image/align GHOST-ORANGE 30 30 "center" "center" BG))
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
(define GHOST-BLUE (underlay/offset GHOSTBLUE1
                   2 7 (rotate 180 T4)))
(define BLUE (place-image/align GHOST-BLUE 30 30 "center" "center" BG))
;-----------------------------
;DOT
(define DOT (circle 6 "solid" "Papaya Whip"))
(define POINT(place-image/align DOT 30 30 "center" "center" BG))

;-----------------------------
;POWERPELLETS

(define POWER (circle 10 "solid" "Khaki"))
(define PP (place-image/align POWER 30 30 "center" "center" BG))

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

(define CHERRY3 (overlay/offset GAMBO 0 10 CHERRY2))
(define CHERRY (place-image/align CHERRY3 30 30 "center" "center" BG))

;---------------------------
;WALL
(define VW (place-image/align (rectangle 10 60 "solid""blue") 30 30 "center" "center" BG))

;--------------------------
;CORNER
(define C (place-image/align (rectangle 30 10 "solid""blue") 30 30 "left" "center" BG))
(define CORNER (place-image/align (rectangle 10 30 "solid" "blue") 30 30 "center" "top" C))

;DOUBLE-CORNER
;-------------------------
(define DCORNER (place-image/align (rectangle 30 10 "solid" "blue") 30 30 "left" "center" VW))

;GATE
;------------------------
(define GATE (place-image/align (rectangle 60 5 "solid""Deep Sky Blue") 30 30 "center" "center" BG))

;TESTS
;------------------
(define ROW1 (list BG CORNER (rotate 90 VW)(rotate 90 VW)(rotate 90 VW)(rotate 90 VW)(rotate 90 VW)(rotate 90 VW)(rotate 90 VW)(rotate 90 VW)(rotate 90 VW)(rotate 90 VW)(rotate 90 VW)(rotate 90 VW)
                     (rotate -90 DCORNER) (rotate 90 VW) (rotate 90 VW) (rotate 90 VW) (rotate 90 VW) (rotate 90 VW) (rotate 90 VW) (rotate 90 VW) (rotate 90 VW) (rotate 90 VW) (rotate 90 VW) (rotate 90 VW) (rotate 90 VW)
                     (rotate -90 CORNER)))
(define ROW2 (list BG VW POINT POINT POINT POINT POINT POINT POINT POINT POINT POINT POINT POINT VW POINT POINT POINT POINT POINT POINT POINT POINT POINT POINT POINT POINT VW))
(define ROW0 (list BG BG BG BG BG BG BG BG BG BG BG BG BG BG BG BG BG BG BG BG BG BG BG BG BG BG BG BG))
(define PACROW (list BG VW (rotate 90 PACMAN1) (rotate 90 VW) (rotate 90 VW) (rotate 90 VW) (rotate 90 VW) POINT (rotate 90 VW) (rotate 90 VW) (rotate 90 VW) (rotate 90 VW) (rotate 90 VW) POINT VW
                     POINT (rotate 90 VW) (rotate 90 VW) (rotate 90 VW) (rotate 90 VW) (rotate 90 VW) POINT (rotate 90 VW) (rotate 90 VW) (rotate 90 VW) (rotate 90 VW) POINT VW))
(define LAB (list ROW0 ROW1 ROW2 PACROW))

;RENDER FUNCTION
;--------------------
(define (render-row list)
  (cond
    [(empty? list) BG]
    [else (beside (first list) (render-row (rest list)))]))

(define (render list)
  (cond
    [(empty? list) (render-row ROW0)]
    [else (above (render-row (first list)) (render (rest list)))]))

;FIND PACMAN POSITION IN THE LABYRINTH
;--------------------------------------
(define (PAC? list pos)
  (cond
    [(empty? list) #false]
    [else
     (cond
       [(posn? (PAC-1 (first list) pos)) (PAC-1 (first list) pos)]
       [else (PAC? (rest list) (make-posn 0 (+ 1 (posn-y pos))))])]))

(define (PAC-1 list pos)
  (cond
    [(empty? list) '()]
    [else
     (cond
       [(or (equal? PACMAN1 (first list)) (equal? (rotate 90 PACMAN1) (first list)) (equal? (rotate -90 PACMAN1) (first list)) (equal? (rotate 180 PACMAN1) (first list))) pos]
       [else (PAC-1 (rest list) (make-posn (+ 1 (posn-x pos)) (posn-y pos)))])]))

;FIND ELEMENT AT POSITION
;---------------------------

(define (find-tot list pos start)
  (cond
    [(= (posn-y start) (posn-y pos)) (find? (first list) pos start)]
    [else (find-tot (rest list) pos (make-posn 0 (+ 1 (posn-y start))))]))

(define (find? list pos start)
  (cond
    [(empty? list) '()]
    [else
     (cond
       [(equal? (posn-x pos) (posn-x start)) (first list)]
       [else (find? (rest list) pos (make-posn (+ 1 (posn-x start)) (posn-y start)))])]))
  