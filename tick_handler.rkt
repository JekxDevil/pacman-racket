;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname tick_handler) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; LIBRARIES
(require racket/base)
(require 2htdp/image)
(require "data_structures.rkt")
(require "figures.rkt")
(require "render.rkt")

;*********************************************************************************
;*********************************************************************************
;; API
(provide tick-handler)
(provide move-posn)
(provide find-in-map)
(provide find-n-replace)
(provide update-map)
(provide check-fullscore)
(provide quit)
(provide quit?)

;*********************************************************************************
;*********************************************************************************
;;; TICK HANDLER
;; Input/Output
; tick-handler : Appstate -> Appstate
; handler general logic events of the game at each tick
; logic | main difference due to pp-active because ghosts will not approach pacman if they are vulnerable
; funcs | move ghosts, update map, check edible, state if game ends, 
; header :
; (define (tick-handler appstate) Appstate)

;; Examples

;; Template

;; Code - used by (big-bang)
(define (tick-handler appstate)
  (local
    [(define pp-effect (appstate-powerpellet-effect appstate))
     (define pp-active (powerpellet-effect-active pp-effect))]
    (cond
      [pp-active (edible-handler appstate)]
      [else (update-appstate appstate)])))

;*********************************************************************************
;; Input/Output
; edible-handler : Appstate -> Appstate
; handle ticks when powerpellet is active, also manage its consequences in-game
; header :
; (define (edible-handler appstate) Appstate)

;; Examples

;; Template

;; Code - used by (tick-handler)
(define (edible-handler appstate)
  (local
    [; appstate fields abbreviations
     (define map (appstate-map appstate))
     (define pacman (appstate-pacman appstate))
     (define ghosts (appstate-ghosts appstate))
     (define score (appstate-score appstate))
     (define powerpellet-effect (appstate-powerpellet-effect appstate))
     (define ticks (powerpellet-effect-ticks powerpellet-effect))
     ; updated fields
     (define new-ghosts (move-ghosts ghosts))
     (define new-pacman (move-pacman pacman))
     (define )]
    (cond
      [(>= ticks LIMIT-POWERPELLET-EFFECT) (make-appstate
                                            (appstate-map appstate)    ; update-map
                                            (appstate-pacman appstate)
                                            (appstate-ghosts appstate) ; update-ghosts
                                            (appstate-score appstate)
                                            INIT-POWERPELLET-EFFECT
                                            (appstate-quit appstate))]
    [else (make-appstate
           (appstate-map appstate)    ; update-map
           (appstate-pacman appstate)
           (move-ghosts ghosts) ; update ghosts
           (appstate-score appstate)
           (make-powerpellet-effect #true (+ TICK ticks))
           (appstate-quit appstate))])))

;*********************************************************************************
; first update ghosts
;     direction versus pacman if near, just don't collision detection yet
; pass new ghosts to map to update position and if collision end game
(define (update-appstate appstate)
  )

;*********************************************************************************
;; Input/Output
; move-ghosts : List<Ghost> -> List<Ghost>
; update the whole ghosts list at each tick
; header :
; (define (move-ghosts ghosts) List<Ghost>)

;; Examples

;; Template

;; Code - used by (...) 
(define (move-ghosts ghosts)
  (cond
    [(empty? (rest ghosts)) (update-ghost (first ghosts))]
    [(cons (update-ghost (first ghosts)) (update-ghosts (rest ghosts)))]))

;*********************************************************************************
;; Input/Output
; move-ghost : Ghost -> Ghost
; move ghost position and direction
; no quit here, collision detection when building map
; but there is pacman following if it's 1 block distant
; header :
; (define (move-ghost ghost) Ghost)

;; Examples

;; Template

;; Code - used by (...) 
(define (move-ghost map pp-active pacman ghost)
  (local
    [; param field abbreviations
     (define name (character-name (character-ghost ghost)))
     ; pre-calculated elements for func
     (define posn-up (move-posn posn DIRECTION-UP))
     (define posn-right (move-posn posn DIRECTION-RIGHT))
     (define posn-down (move-posn posn DIRECTION-DOWN))
     (define posn-left (move-posn pons DIRECTION-LEFT))
     (define element-up (find-in-map map posn-next-up))
     (define element-right (find-in-map map posn-next-right))
     (define element-down (find-in-map map posn-next-down))
     (define element-left (find-in-map map posn-next-left))
     ; organized calculated values
     (define choices (list
                      (cons DIRECTION-UP pons-up element-up)
                      (cons DIRECTION-RIGHT posn-right element-right)
                      (cons DIRECTION-DOWN posn-down element-down)
                      (cons DIRECTION-LEFT posn-left element-left)))
     (define valid-pacman-choices (map (λ (choice) (collect-valid-choices name choices #true)) choices))
     (define possible-pacman-choices (collect-possible-choices valid-pacman-choices))
     (define valid-choices (map (λ (choice) (collect-valid-choices name choices #false)) choices))
     (define possible-choices (collect-possible-choices valid-pacman-choices))]
    (cond
      ; pacman reserved (assumption pacman is only one)
      [(= 1 (length possible-pacman-choices)) (first possible-pacman-choices)]
      ; random choice excluded walls
      [else (list-ref possible-choices (random (length possible-choices)))])))

;*********************************************************************************
;*********************************************************************************
;*********************************************************************************
;; Input/Output
; collect-possible-choices : Name List<Pair> -> List<Ghost>
; group choices available, discarding non-ghost values which are invalid choices
; header :
; (define (collect-possible-choices list-choices) List<Ghost>)

;; Examples

;; Template

;; Code - used by (move-ghost)
(define (collect-possible-choices list-choices)
    (map (λ (choice) (if [ghost? choice] choice '())) list-choices))

;*********************************************************************************
;; Data type
; Choice is a Trio (Direction Posn Char)
; Maybe<Ghost> can be either:
; - Ghost
; - #false

;; Input/Output
; collect-valid-choices : Name Choice Boolean -> Maybe<Ghost>
; given pacman or a valid map cell as its aim, return a ghost if the cell pointed by the choice
; is eligible, otherwise return false
; header :
; (define (collect-valid-choices name choice looking-pacman) Maybe<Ghost>)

;; Examples


;; Template


;; Code - used by (move-ghost)
(define (collect-valid-choices name choice looking-pacman)
  (cond
    [(and (not looking-pacman)
          (not (char=? MAP-WALL (third choice)))
          (not (char=? MAP-GHOST-RED (third choice)))
          (not (char=? MAP-GHOST-ORANGE (third choice)))
          (not (char=? MAP-GHOST-PINK (third choice)))
          (not (char=? MAP-GHOST-CYAN (third choice)))) (make-ghost
                                                         (make-character name (first choice) (second choice))
                                                         (third choice))]
    [(and looking-pacman
          (char=? MAP-PACMAN (third choice))) (make-ghost
                                               (make-character name (first choice) (second choice))
                                               MAP-PACMAN)]
    [else #f]))

;*********************************************************************************
;; Input/Output
; collision : -> Boolean
; check if the game ends because of a collision between pacman and an invulnerable ghost
; logic | check hidden element in all ghosts if they match with MAP-PACMAN)
; assumption | pacman is only one
; header :
; (define (collision ghosts) Boolean)

;; Examples
(define EX-C-POSN (make-posn 0 0))
(define EX-C-GHOST0 (make-ghost (make-character MAP-GHOST-RED DIRECTION-UP EX-C-POSN) MAP-PACMAN))
(define EX-C-GHOST1 (make-ghost (make-character MAP-GHOST-RED DIRECTION-UP (make-posn 1 1)) MAP-EMPTY))
(define EX-C-GHOST2 (make-ghost (make-character MAP-GHOST-RED DIRECTION-UP (make-posn 2 2)) MAP-DOT))
(define EX-C-GHOST3 (make-ghost (make-character MAP-GHOST-RED DIRECTION-UP (make-posn 3 3)) MAP-CHERRY))
(define EX-C-GHOSTS-TRUE (list EX-C-GHOST0 EX-C-GHOST1 EX-C-GHOST2 EX-C-GHOST3))
(define EX-C-GHOSTS-FALSE (list EX-C-GHOST1 EX-C-GHOST2 EX-C-GHOST3))

(check-expect (collision EX-C-GHOSTS-TRUE) #true)
(check-expect (collision EX-C-GHOSTS-FALSE) #false)

;; Template

;; Code - used by (quit)
(define (collision ghosts)
  (local
    [(define collisions (map
                         (λ (g) (if [char=? MAP-PACMAN (ghost-hidden-element g)] #true #false))
                         ghosts))]
  (foldl
   (λ (item result) (or item result))
   #false
   collisions)

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
; (define (move-posn posn direction)
;   (cond [(char=? direction DIRECTION-UP)    (make-posn ...)]
;         [(char=? direction DIRECTION-DOWN)  (make-posn ...)]
;         [(char=? direction DIRECTION-LEFT)  (make-posn ...)]
;         [(char=? direction DIRECTION-RIGHT) (make-posn ...)]))

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
(check-expect (find-in-map INIT-MAP INIT-PACMAN-POSN) MAP-PACMAN)
(check-expect (find-in-map INIT-MAP INIT-GHOST-R-POSN) MAP-GHOST-RED)
(check-expect (find-in-map INIT-MAP INIT-GHOST-O-POSN) MAP-GHOST-ORANGE)
(check-expect (find-in-map INIT-MAP INIT-GHOST-P-POSN) MAP-GHOST-PINK)
(check-expect (find-in-map INIT-MAP INIT-GHOST-C-POSN) MAP-GHOST-CYAN)

;; Template
; (define (find-in-map map posn)
;   (string-ref (vector-ref ....) ...)

;; Code - used by 
(define (find-in-map map posn)
  (string-ref (vector-ref map (posn-y posn)) (posn-x posn)))

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
; (define (check-fullscore appstate)
;   (if [>= (appstate-score appstate) TOTAL-POINTS]
;       [quit ...]
;       ... appstate ...)))

;; Code - used by ---TODO IMPLEMENTATION
(define (check-fullscore appstate)
  (local [(define score (appstate-score appstate))]
  (if [>= score TOTAL-POINTS]
      [quit appstate]
      appstate)))

;*******************************************************************************************************
;;; FIND AND REPLACE
;; Input/Output
; find-n-replace : Map Posn Name -> Map
; given a list of string representing a map, checks each row if matches position that needs updating,
; if so proceeds to update the string
; header :
; (define (find-n-replace map pos name) Map)

;; Examples

;; Template

;; Code - used by (...) 
(define (find-n-replace map pos name)
  (local [(define row (string->list (vector-ref EX-MAP (posn-y pos))))]
    (for/list ([i (in-range (length map))])
      (if (= i (posn-y pos))
          (local [(define list (string->list (list-ref map (posn-y pos))))]
            (list->string (for/list ([i (in-range (length list))])
                            (if (= i (posn-x pos))
                                name
                                (list-ref list i)))))
          (list-ref map i)))))

;*******************************************************************************************************
;;; UPDATE MAP
;; Input/Output
; update-map : Map Pac-or-ghost Posn -> Map
; given map, current and future position and name of a character,
; updates the map according to the changes
; header :
; (define (update-map map pac-or-ghost pos-next) Map)

;; Examples
(check-expect (update-map INIT-MAP INIT-PACMAN (make-posn (+ 1 (posn-x INIT-PACMAN-POSN)) (posn-y INIT-PACMAN-POSN)))
              (vector "WWWWWWWWWWWWWWWWWWWWWWWWWWWW"
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
                      "WWWWWW.WW W    r W WW.WWWWWW"
                      "      .   W o    W   .      "
                      "WWWWWW.WW W p  c W WW.WWWWWW"     
                      "     W.WW WWWWWWWW WW.W     "
                      "     W.WW     P    WW.W     "
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

(check-expect (update-map INIT-MAP INIT-GHOST-R (make-posn (posn-x INIT-GHOST-R-POSN) (+ 1 (posn-y INIT-GHOST-R-POSN))))
              (vector "WWWWWWWWWWWWWWWWWWWWWWWWWWWW"
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
                      "      .   W o  r W   .      "
                      "WWWWWW.WW W p  c W WW.WWWWWW"     
                      "     W.WW WWWWWWWW WW.W     "
                      "     W.WW    P     WW.W     "
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

;; Template
; (define (update-map map pac-or-ghost pos-next)
;   (local [(define los                 ...)
;           (define is-pac              ...)
;           (define pos-now             ...)
;           (define returning-item      ...)
;           (define returning-character ...)
;           (define map-with-prev-item (find-n-replace ...))]
;     (list->vector (find-n-replace ...))))

;; Code - used by (...)
(define (update-map map pac-or-ghost pos-next)
  (local [(define los (vector->list map))
          (define is-pac (pacman? pac-or-ghost))
          (define pos-now (if is-pac
                              (character-position (pacman-character pac-or-ghost))
                              (character-position (ghost-character pac-or-ghost))))
          (define returning-item (if is-pac MAP-EMPTY (ghost-hidden-element pac-or-ghost)))
          (define returning-character (if is-pac
                                          (character-name (pacman-character pac-or-ghost))
                                          (character-name (ghost-character pac-or-ghost))))
          (define map-with-prev-item (find-n-replace los pos-now returning-item))]
    (list->vector (find-n-replace map-with-prev-item pos-next returning-character))))

;*******************************************************************************************************
;;; GAME OVER
;; Input/Output
; game-over : Appstate -> Appstate
; check all possible causes of game over and if there are any, quit the game
; header :
; (define (game-over appstate) Appstate)

;; Examples

;; Template

;; Code - used by (update-appstate)
    
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
; (define (quit appstate)
;   (make-appstate ...)

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
; (define (quit? appstate)
;   ... appstate ...)

;; Code - used by (big-bang)
(define (quit? appstate)
  (appstate-quit appstate)); edit

;*******************************************************************************************************
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