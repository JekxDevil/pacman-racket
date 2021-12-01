;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname figures) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;;; API
(require racket/base)
;characters
(provide SKIN-PACMAN-OPEN)
(provide SKIN-PACMAN-CLOSE)
(provide SKIN-GHOST-RED)
(provide SKIN-GHOST-PINK)
(provide SKIN-GHOST-CYAN)
(provide SKIN-GHOST-ORANGE)
(provide SKIN-GHOST-EDIBLE)
; objects
(provide SKIN-DOT)
(provide SKIN-PP)
(provide SKIN-CHERRY)
; map
(provide SKIN-WALL)
(provide SKIN-GATE)

;************************************************************************************
;************************************************************************************
;; LIBRARIES
(require 2htdp/image)

;************************************************************************************

(define BG (square 60  "solid" "black"))

;; postfix "WB" stands for without border
(define PACMAN-OPEN-WB (rotate 30 (wedge 30 300 "solid" "gold")))
(define PACMAN-CLOSE-WB (circle 30 "solid" "gold"))
(define SKIN-PACMAN-OPEN (place-image/align PACMAN-OPEN-WB 30 30 "center" "center" BG))
(define SKIN-PACMAN-CLOSE (place-image/align PACMAN-CLOSE-WB 30 30 "center" "center" BG))
;-----------------------------------
;;;
;;; MAKE GHOSTS
;;;
;;;;;;
;;;;;; Color : String
;;;;;; Color -> Image
(define EYE (circle 7 "solid" "white"))
(define PUPIL (circle 3 "solid" "blue"))

(define (make-ghost color)
  (place-image/align (underlay/offset (underlay/offset (overlay/offset (rectangle 50 30 "solid" color)
                                                                       0
                                                                       -19
                                                                       (circle 25 "solid" color))
                                                       0
                                                       -10
                                                       (underlay/offset EYE -30 0 EYE))
                                      0
                                      -10
                                      (underlay/offset PUPIL
                                                       -30
                                                       0
                                                       PUPIL))
                     30
                     30
                     "center"
                     "center"
                     BG))

;RED GHOST
(define SKIN-GHOST-RED (make-ghost "red"))
;-------------------------------
;PINK GHOST
(define SKIN-GHOST-PINK (make-ghost "pink"))
;-----------------------------
;CYAN GHOST
(define SKIN-GHOST-CYAN (make-ghost "cyan"))
;-----------------------------
;ORANGE GHOST
(define SKIN-GHOST-ORANGE (make-ghost "orange"))
;---------------------------
;EDIBLE GHOST
(define T1 (overlay/offset (isosceles-triangle 5 300 "solid" "white") 5 0 (isosceles-triangle 5 300 "solid" "white")))
(define T2 (overlay/offset T1 8 0 (isosceles-triangle 5 300 "solid" "white")))
(define T3 (overlay/offset T2 11 0 (isosceles-triangle 5 300 "solid" "white")))
(define T4 (overlay/offset T3 14 0 (isosceles-triangle 5 300 "solid" "white")))

(define GHOE2 (make-ghost "blue"))
(define GHOE3 (underlay/offset GHOE2 0 5 T4))
(define GHOST-EDIBLE-WB (underlay/offset GHOE3 2 7 (rotate 180 T4)))
(define SKIN-GHOST-EDIBLE (place-image/align GHOST-EDIBLE-WB 30 30 "center" "center" BG))
;-----------------------------
;DOT
(define DOT-WB (circle 6 "solid" "Papaya Whip"))
(define SKIN-DOT (place-image/align DOT-WB 30 30 "center" "center" BG))

;-----------------------------
;POWERPELLETS
(define PP-WB (circle 10 "solid" "Khaki"))
(define SKIN-PP (place-image/align PP-WB 30 30 "center" "center" BG))

;-----------------------------
; CHERRY
(define BRANCH (beside
               (line 10 -10 (pen "brown" 5 "long-dash" "butt" "round"))
               (flip-horizontal (line 10 -10 (pen "brown" 5 "long-dash" "butt" "round")))))
(define CHERRY1 (overlay/offset (circle 10 "solid" "firebrick")
                                2 2
                                (circle 10 "solid" "light coral")))
(define CHERRY2 (overlay/offset CHERRY1 20 0 CHERRY1))
(define CHERRY3 (overlay/offset BRANCH 0 10 CHERRY2))
(define SKIN-CHERRY (place-image/align CHERRY3 30 30 "center" "center" BG))

;---------------------------
;WALL
(define SKIN-WALL (rectangle 60 60 "solid" "blue"))

;GATE
;------------------------
(define SKIN-GATE (place-image/align (rectangle 60 5 "solid" "Deep Sky Blue") 30 30 "center" "center" BG))

;*********************************************************************************************************
;*********************************************************************************************************
;*********************************************************************************************************



;RENDER FUNCTION
;--------------------
(define (conversion-char char state)
  (cond
    [(equal? state #\ ) BG]
    [(equal? char #\W) WALL]
    [(equal? char #\.) DOT]
    [(equal? char #\@) PP]
    [(equal? char #\P) PACMAN-OPEN
     (cond
       [(equal? (pacman-direction appstate) "r") PACMAN-OPEN]
       [(equal? (pacman-direction appstate) "l") (rotate 180 PACMAN-OPEN)]
       [(equal? (pacman-direction appstate) "u") (rotate 90 PACMAN-OPEN)]
       [(equal? (pacman-direction pac) "d") (rotate -90 PACMAN-OPEN)])]; or close VFX
    [(equal? char #\Y) CHERRY]
    [(equal? char #\_) GATE]
    [(equal? char #\o) GHOST-ORANGE]
    [(equal? char #\r) GHOST-RED]
    [(equal? char #\p) GHOST-PINK]
    [(equal? char #\c) GHOST-CYAN]
    [(equal? char #\e) GHOST-EDIBLE]))

; map : Vector<String>
; conv -> image
(define (conv map index)
  (cond
    [(empty? list) '()]
    [else (cons (map conversion-char (first list)) (conv (rest list)))]))

; Square are a List<Image>

;input/output
; render-row: List<Image> --> Image
;the function takes a list of list of Square and put them toghether horizontally
; header (define (render-row list) Image)

(define (render-row list)
  (cond
    [(empty? list) BG]
    [else (beside (first list) (render-row (rest list)))]))

;list is a List<Square>
;it can either be
; - '()
; - List<Square>

;input/output
;render: List<Square> --> Image
; header (define (render list) Image)

(define (render list)
  (cond
    [(empty? (rest list)) (first list)]
    [else (above (first list) (render (rest list)))]))


;;; delete tests
(define TR1 (render-row (map conversion-char (string->list "W.WWWW.WW.WWWWWWWW.WW.WWWW.W")
                             )))
(define TR2 (render-row (map conversion-char (string->list "W.WWWWpWW.WWWWWWWW@WWPWWWWoW")
                             (list (make-pacman "l" (make-posn 0 0)))
                             )))


(render (map (λ (string-row) (render-row (map conversion-char (string->list string-row)))) (vector->list EX-MAP2))
        (make-pacman "l" (make-posn 0 0))
        )


;FIND ELEMENT AT POSITION
;---------------------------
(define (find state pos)
  (vector-ref (vector-ref (appstate-map state) (posn-y pos)) (posn-x pos)))


; Map Pac-posn -> Map

(define (find appstate pos)
  (list-ref (list-ref (appstate-map appstate) (posn-y pos)) (posn-x pos)))
