;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname tick_handler) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; LIBRARIES
(require racket/base)
(require 2htdp/image)
(require "data_structures.rkt")

;*********************************************************************************
;*********************************************************************************
;; API
(provide tick-handler)

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
; (define (tick-handler appstate)
;   (local
;     [(define moved-pacman (move-pacman ...))
;      (define new-map-pacman (update-map ...))
;      (define new-pp-effect (update-pp-effect ...))
;      (define quit0 (pre-game-over ...))
;      (define new-ghosts (move-ghosts ...))
;      (define new-map ... (update-map...) ...)
;      (define new-score (update-score ...))
;      (define quit1 (game-over ...))
;      (define new-quit (or ...))
;      (define new-pacman (clear-item ...))]
;     (make-appstate ...)))

;; Code - used by (big-bang)
(define (tick-handler appstate)
  (local
    [; appstate fields abbreviations
     (define map (appstate-map appstate))
     (define pacman (appstate-pacman appstate))
     (define pacman-posn (character-position (pacman-character pacman)))
     (define pacman-item-below (character-item-below (pacman-character pacman)))
     (define ghosts (appstate-ghosts appstate))
     (define score (appstate-score appstate))
     (define pp-effect (appstate-powerpellet-effect appstate))
     (define quit (appstate-quit appstate))
     ; pre-calculated fields updates
     ; - move pacman struct and update map consequently -
     (define moved-pacman (move-pacman map pacman))
     (define moved-pacman-posn (character-position (pacman-character moved-pacman)))
     (define new-map-pacman (update-map map pacman-posn moved-pacman-posn pacman-item-below MAP-PACMAN))
     ; - pp-effect handler -
     (define moved-pacman-item (character-item-below (pacman-character moved-pacman)))
     (define new-pp-effect (update-pp-effect pp-effect moved-pacman-item))
     (define new-pp-active (powerpellet-effect-active new-pp-effect))
     ; - game over first check -
     (define quit0 (pre-game-over pacman new-pp-active))
     ; - move ghosts struct and update map consequently -
     (define new-ghosts (move-ghosts new-map-pacman new-pp-active ghosts))
     (define new-map (foldl
                      (λ (g-previous g-next tmp-map) (update-map
                                                      tmp-map
                                                      (character-position g-previous)
                                                      (character-position g-next)
                                                      (character-item-below g-previous)
                                                      (character-name g-next)))
                      new-map-pacman
                      ghosts
                      new-ghosts))
     ; - score update -
     (define new-score (update-score score moved-pacman-item))
     ; - game over second check -
     (define quit1 (game-over new-ghosts new-pp-active new-score))
     (define new-quit (or quit0 quit1))
     ; - free pacman from it's overlayed item -
     (define new-pacman (clear-item moved-pacman))]
    (make-appstate new-map new-pacman new-ghosts new-score new-pp-effect new-quit)))

;*********************************************************************************
;;; MOVE PACMAN
;; Data types

;; Input/Output
; move-pacman: Map Active Pacman -> Pacman
; handles pacman move logic
; logic | stops pacman from moving in a wall or a gate, otherwise move and save the item before for score purposes
; header :
; (define (move-pacman appstate character) Pacman)

;; Examples
(define EX-MP-PACMAN0 (make-pacman
                       (make-character
                        MAP-PACMAN
                        DIRECTION-RIGHT
                        (make-posn (+ 1 (posn-x INIT-PACMAN-POSN)) (posn-y INIT-PACMAN-POSN))
                        MAP-EMPTY)
                       #false))

(define EX-MP-PACMAN1 (make-pacman
                       (make-character
                        MAP-PACMAN
                        DIRECTION-RIGHT
                        (make-posn (+ 1 (posn-x INIT-GHOST-RED-POSN)) (posn-y INIT-GHOST-RED-POSN))
                        MAP-EMPTY)
                       #false))

(define EX-MP-PACMAN2 (make-pacman
                       (make-character
                        MAP-PACMAN
                        DIRECTION-LEFT
                        (make-posn (+ 1 (posn-x INIT-GHOST-RED-POSN)) (posn-y INIT-GHOST-RED-POSN))
                        MAP-EMPTY)
                       #false))

(define EX-MP-PACMAN3 (make-pacman
                       (make-character
                        MAP-PACMAN
                        DIRECTION-LEFT
                        INIT-GHOST-RED-POSN
                        MAP-GHOST-RED)
                       #true))

(define EX-MP-PACMAN4 (make-pacman
                       (make-character
                        MAP-PACMAN
                        DIRECTION-LEFT
                        (make-posn (+ 1 (posn-x INIT-GHOST-ORANGE-POSN)) (posn-y INIT-GHOST-ORANGE-POSN))
                        MAP-EMPTY)
                       #false))
(define EX-MP-PACMAN5 (make-pacman
                       (make-character
                        MAP-PACMAN
                        DIRECTION-LEFT
                        INIT-GHOST-ORANGE-POSN
                        MAP-GHOST-ORANGE)
                       #true))

(define EX-MP-PACMAN6 (make-pacman
                       (make-character
                        MAP-PACMAN
                        DIRECTION-LEFT
                        (make-posn (+ 1 (posn-x INIT-GHOST-PINK-POSN)) (posn-y INIT-GHOST-PINK-POSN))
                        MAP-EMPTY)
                       #false))
(define EX-MP-PACMAN7 (make-pacman
                       (make-character
                        MAP-PACMAN
                        DIRECTION-LEFT
                        INIT-GHOST-PINK-POSN
                        MAP-GHOST-PINK)
                       #true))

(define EX-MP-PACMAN8 (make-pacman
                       (make-character
                        MAP-PACMAN
                        DIRECTION-LEFT
                        (make-posn (+ 1 (posn-x INIT-GHOST-CYAN-POSN)) (posn-y INIT-GHOST-CYAN-POSN))
                        MAP-EMPTY)
                       #false))

(define EX-MP-PACMAN9 (make-pacman
                       (make-character
                        MAP-PACMAN
                        DIRECTION-LEFT
                        INIT-GHOST-CYAN-POSN
                        MAP-GHOST-CYAN)
                       #true))

(check-expect (move-pacman INIT-MAP INIT-PACMAN) EX-MP-PACMAN0)   ; normal movement
(check-expect (move-pacman INIT-MAP EX-MP-PACMAN1) EX-MP-PACMAN1) ; wall
(check-expect (move-pacman INIT-MAP EX-MP-PACMAN2) EX-MP-PACMAN3) ; vs ghost red
(check-expect (move-pacman INIT-MAP EX-MP-PACMAN4) EX-MP-PACMAN5) ; vs ghost orange
(check-expect (move-pacman INIT-MAP EX-MP-PACMAN6) EX-MP-PACMAN7) ; vs ghost pink
(check-expect (move-pacman INIT-MAP EX-MP-PACMAN8) EX-MP-PACMAN9) ; vs ghost cyan

;; Template
; (define (move-pacman map pp-active pacman)
;   (local [(define character    ...)
;           (define direction    ...)
;           (define posn         ...)
;           (define mouth        ...)
;           (define posn-next    ...)
;           (define element-next ...)
;           (define mouth-next   ...)]
;     [cond [(or (char=? element-next MAP-GATE) 
;                (char=? element-next MAP-WALL))       ...]
;           [(or (char=? element-next MAP-DOT)
;                (char=? element-next MAP-CHERRY)
;                (char=? element-next MAP-POWERPELLET)
;                (char=? element-next MAP-EMPTY)
;                (char=? element-next MAP-GHOST-RED)
;                (char=? element-next MAP-GHOST-PINK)
;                (char=? element-next MAP-GHOST-ORANGE)
;                (char=? element-next MAP-GHOST-CYAN)) ...]
;           [else (error ...)]]))

;; Code - used by (tick-handler)
(define (move-pacman map pacman)
  (local [; param abbreviations
          (define character (pacman-character pacman))
          (define direction (character-direction character))
          (define posn (character-position character))
          (define mouth (pacman-mouth pacman))
          ; pre-calculated values
          (define posn-next (move-posn posn direction))
          (define element-next (find-in-map map posn-next))
          (define mouth-next (not mouth))]
    ; body
    [cond [(or (char=? element-next MAP-GATE) 
               (char=? element-next MAP-WALL)) pacman]
          [(or (char=? element-next MAP-DOT)
               (char=? element-next MAP-CHERRY)
               (char=? element-next MAP-POWERPELLET)
               (char=? element-next MAP-EMPTY)
               ; ghosts cases follow the same pattern 'cause collision detection isn't detected here but in (game-over)
               (char=? element-next MAP-GHOST-RED)
               (char=? element-next MAP-GHOST-PINK)
               (char=? element-next MAP-GHOST-ORANGE)
               (char=? element-next MAP-GHOST-CYAN)) (make-pacman
                                                      (make-character
                                                       MAP-PACMAN
                                                       direction
                                                       posn-next
                                                       element-next)
                                                      mouth-next)]]))

;*********************************************************************************
;;; UPDATE POWERPELLET EFFECT
;; Data types
; Item is a Char from struct Character (character-item-below)
;; Input/Output
; update-pp-effect : Powerpellet-effect Item -> Powerpellet-effect
; update powerpellet effect managing ticks and state when powerpellet is active
; Assumptions | only pacman can ivoke this function 
; Collateral  | if pacman gets more than one powerpellet, the effect is not increased
; header :
; (define (update-pp-effect pp) Powerpellet-effect)

;; Examples
(define EX-UPPE-PP0 (make-powerpellet-effect #true 0))
(define EX-UPPE-PP1 (make-powerpellet-effect #true (+ 0 TICK)))
(define EX-UPPE-PP2 (make-powerpellet-effect #true LIMIT-POWERPELLET-ACTIVE))
(define EX-UPPE-PP3 (make-powerpellet-effect #true (- LIMIT-POWERPELLET-ACTIVE TICK)))
(define EX-UPPE-PP4 (make-powerpellet-effect #true (+ LIMIT-POWERPELLET-ACTIVE TICK)))

; case 1.1 : reset pp effect because it finished
(check-expect (update-pp-effect EX-UPPE-PP2 MAP-EMPTY) INIT-POWERPELLET-EFFECT)
(check-expect (update-pp-effect EX-UPPE-PP4 MAP-EMPTY) INIT-POWERPELLET-EFFECT)
; case 1.2 : increase ticks to pp-effect
(check-expect (update-pp-effect EX-UPPE-PP0 MAP-EMPTY) EX-UPPE-PP1)
(check-expect (update-pp-effect EX-UPPE-PP3 MAP-EMPTY) EX-UPPE-PP2)
; case 2.1 : activate pp effect
(check-expect (update-pp-effect INIT-POWERPELLET-EFFECT MAP-POWERPELLET) EX-UPPE-PP0)
; case 2.2 : return pp
(check-expect (update-pp-effect INIT-POWERPELLET-EFFECT MAP-EMPTY) INIT-POWERPELLET-EFFECT)

;; Template
; (define (update-pp-effect pp item)
;   (local
;     [(define active ...)
;      (defien ticks  ...)]
;   [cond
;     [active [cond
;               [(>= ticks LIMIT-POWERPELLET-EFFECT) ...]
;               [else                               ...]]]
;     [else [cond
;           [(char=? MAP-POWERPELLET item) ...]
;           [else                          ...]]]]))

;; Code - used by (tick-handler)
(define (update-pp-effect pp item)
  (local
    [; param fields abbreviations
     (define active (powerpellet-effect-active pp))
     (define ticks (powerpellet-effect-ticks pp))]
    ; function body
    [cond
      [active (cond
                [(>= ticks LIMIT-POWERPELLET-ACTIVE) INIT-POWERPELLET-EFFECT]
                [else (make-powerpellet-effect #true (+ TICK ticks))])]
      [else (cond
              [(char=? MAP-POWERPELLET item) (make-powerpellet-effect #true 0)]
              [else pp])]]))

;*********************************************************************************
;;; MOVE GHOSTS
;; Data types
; Map is a Vector<String> from struct Appstate (appstate-map)
; Active is a Boolean from struct Powerpellet-effect (powerpellet-effect-active)
; Ghosts is a List<Character> from struct Character

;; Input/Output
; move-ghosts : Map Active Ghosts -> Ghosts
; update the whole ghosts list at each tick
; header :
; (define (move-ghosts ghosts) Ghosts)

;; Examples
(define EX-MG-MAP0 (vector "WWWW" "Wr.W" "WWWWW" "Wp@W" "WWWW" "WcYW" "WWWW"))
(define EX-MG-GHOST0 (make-character MAP-GHOST-RED DIRECTION-RIGHT (make-posn 1 1) MAP-EMPTY))
(define EX-MG-GHOST1 (make-character MAP-GHOST-RED DIRECTION-RIGHT (make-posn 2 1) MAP-DOT))
(define EX-MG-GHOST2 (make-character MAP-GHOST-RED DIRECTION-UP (make-posn 1 0) MAP-PACMAN))
(define EX-MG-GHOST3 (make-character MAP-GHOST-PINK DIRECTION-RIGHT (make-posn 1 3) MAP-EMPTY))
(define EX-MG-GHOST4 (make-character MAP-GHOST-PINK DIRECTION-RIGHT (make-posn 2 3) MAP-POWERPELLET))
(define EX-MG-GHOST5 (make-character MAP-GHOST-CYAN DIRECTION-RIGHT (make-posn 1 5) MAP-EMPTY))
(define EX-MG-GHOST6 (make-character MAP-GHOST-CYAN DIRECTION-RIGHT (make-posn 2 5) MAP-CHERRY))
(define EX-MG-GHOSTS-IN (list EX-MG-GHOST0 EX-MG-GHOST3 EX-MG-GHOST5))
(define EX-MG-GHOSTS-OUT (list EX-MG-GHOST1 EX-MG-GHOST4 EX-MG-GHOST6))

(check-expect (move-ghosts EX-MG-MAP0 #false EX-MG-GHOSTS-IN) EX-MG-GHOSTS-OUT)


;; Template
; (define (move-ghosts map active ghosts)
;   (cond
;     [(empty? (rest ghosts)) (update-ghost ...)]
;     [else (cons (update-ghost ...) (update-ghosts ...))]))

;; Code - used by (tick-handler) 
(define (move-ghosts map active ghosts)
  (cond
    [(empty? ghosts) '()]
    [else (cons (move-ghost map active (first ghosts)) (move-ghosts map active (rest ghosts)))]))

;*********************************************************************************
;;; MOVE GHOST
;; Data types
; Map is a Vector<String> from struct Appstate (appstate-map)
; Active is a Boolean from struct Powerpellet-effect (powerpellet-effect-active)
; Ghost is a Character

;; Input/Output
; move-ghost : Map Active Ghost -> Ghost
; move ghost position and direction
; no quit here, collision detection when building map
; but there is pacman following if it's 1 block distant
; header :
; (define (move-ghost map active ghost) Ghost)

;; Examples
(define EX-MG-MAP1 (vector "WPWW" "Wr.W" "WWWW"))

; PP effect disabled: if there is pacman, kill it
(check-expect (move-ghost EX-MG-MAP0 #false EX-MG-GHOST0) EX-MG-GHOST1)
(check-expect (move-ghost EX-MG-MAP1 #false EX-MG-GHOST0) EX-MG-GHOST2)
; PP effect enable: must avoid pacman
(check-expect (move-ghost EX-MG-MAP0 #true EX-MG-GHOST0) EX-MG-GHOST1)
(check-expect (move-ghost EX-MG-MAP1 #true EX-MG-GHOST0) EX-MG-GHOST1)

;; Template
; (define (move-ghost mymap active ghost)
;   (local
;     [(define name ...)
;      (define posn ...)
;      (define posn-up (move-posn ...))
;      (define posn-right (move-posn ...))
;      (define posn-down (move-posn ...))
;      (define posn-left (move-posn ...))
;      (define element-up (find-in-map ...))
;      (define element-right (find-in-map ...))
;      (define element-down (find-in-map ...))
;      (define element-left (find-in-map ...))
;      (define ghost-choices ...)
;      (define choices-with-pacman ... (collect-valid-choices ...) ...)
;      (define possible-choices-with-pacman (collect-possible-choices ...))
;      (define choices-without-pacman ... (collect-valid-choices ...) ...)
;      (define possible-choices-without-pacman (collect-possible-choices ...))
;      (define random-choice-without-pacman ...)]
;     [cond
;       [active ...]
;       [else (cond
;               [(not (empty? possible-choices-with-pacman)) ...]
;               [else                                        ...])]]))

;; Code - used by (move-ghosts) 
(define (move-ghost mymap active ghost)
  (local
    [; param field abbreviations
     (define name (character-name ghost))
     (define posn (character-position ghost))
     ; pre-calculated elements for func
     (define posn-up (move-posn posn DIRECTION-UP))
     (define posn-right (move-posn posn DIRECTION-RIGHT))
     (define posn-down (move-posn posn DIRECTION-DOWN))
     (define posn-left (move-posn posn DIRECTION-LEFT))
     (define element-up (find-in-map mymap posn-up))
     (define element-right (find-in-map mymap posn-right))
     (define element-down (find-in-map mymap posn-down))
     (define element-left (find-in-map mymap posn-left))
     ; organized calculated values
     (define ghost-choices (list
                            (make-character name DIRECTION-UP posn-up element-up)
                            (make-character name DIRECTION-RIGHT posn-right element-right)
                            (make-character name DIRECTION-DOWN posn-down element-down)
                            (make-character name DIRECTION-LEFT posn-left element-left)))
     (define choices-with-pacman (map (λ (choice) (collect-valid-choice choice #true)) ghost-choices))
     (define possible-choices-with-pacman (collect-possible-choices choices-with-pacman))
     (define choices-without-pacman (map (λ (choice) (collect-valid-choice choice #false)) ghost-choices))
     (define possible-choices-without-pacman (collect-possible-choices choices-without-pacman))
     (define random-choice-without-pacman (list-ref
                                           possible-choices-without-pacman
                                           (random (length possible-choices-without-pacman))))]
    ; function body
    [cond
      ; if powerpellet effect is active, avoid pacman and choose where he is not
      ; which is always possible because map hasn't got dead ends
      [active random-choice-without-pacman]
      [else (cond
              ; pacman reserved (assumption pacman is only one)
              [(not (empty? possible-choices-with-pacman)) (first possible-choices-with-pacman)]
              ; random choice excluded walls, pacman and other ghosts
              [else random-choice-without-pacman])]]))

;*********************************************************************************
;;; COLLECT POSSIBLE CHOICES
;; Input/Output
; collect-possible-choices : List<Character> -> List<Character>
; group choices available, discarding non-ghost values which are invalid choices
; header :
; (define (collect-possible-choices list-choices) List<Ghost>)

;; Examples
(define EX-CPC-CHOICE0 (make-character MAP-GHOST-RED DIRECTION-UP (make-posn 1 0) MAP-EMPTY))
(define EX-CPC-CHOICE1 (make-character MAP-GHOST-RED DIRECTION-RIGHT (make-posn 2 1) MAP-EMPTY))
(define EX-CPC-CHOICE2 (make-character MAP-GHOST-RED DIRECTION-DOWN (make-posn 1 2) MAP-EMPTY))
(define EX-CPC-CHOICE3 (make-character MAP-GHOST-RED DIRECTION-LEFT (make-posn 0 1) MAP-EMPTY))
(define EX-CPC-CHOICES-GOOD (list EX-CPC-CHOICE0 EX-CPC-CHOICE1 EX-CPC-CHOICE2 EX-CPC-CHOICE3))
(define EX-CPC-CHOICES0 (list EX-CPC-CHOICE0 #false EX-CPC-CHOICE1 #false EX-CPC-CHOICE2 #false EX-CPC-CHOICE3))

(check-expect (collect-possible-choices EX-CPC-CHOICES-GOOD) EX-CPC-CHOICES-GOOD)
(check-expect (collect-possible-choices EX-CPC-CHOICES0) EX-CPC-CHOICES-GOOD)

;; Template
; (define (collect-possible-choices list-choices)
;     (map ... list-choices))

;; Code - used by (move-ghost)
(define (collect-possible-choices list-choices)
    (filter character? list-choices))

;*********************************************************************************
;;; COLLECT VALID CHOICE
;; Data type
; Ghost
; Maybe<Ghost> can be either:
; - Ghost
; - #false

;; Input/Output
; collect-valid-choice : Ghost Boolean -> Maybe<Ghost>
; given pacman or a valid map cell as its aim, return a ghost if the cell pointed by the choice
; is eligible, otherwise return false
; Collaterals | pacman position can be chosen only if requested through 'looking-for-pacman'
; header :
; (define (collect-valid-choices ghost looking-for-pacman) Maybe<Ghost>)

;; Examples
(define EX-CVC-GHOST0 (make-character MAP-GHOST-RED DIRECTION-DOWN (make-posn 0 0) MAP-EMPTY))
(define EX-CVC-GHOST1 (make-character MAP-GHOST-RED DIRECTION-DOWN (make-posn 0 0) MAP-CHERRY))
(define EX-CVC-GHOST2 (make-character MAP-GHOST-RED DIRECTION-DOWN (make-posn 0 0) MAP-GATE))
(define EX-CVC-GHOST3 (make-character MAP-GHOST-RED DIRECTION-DOWN (make-posn 0 0) MAP-WALL))
(define EX-CVC-GHOST4 (make-character MAP-GHOST-RED DIRECTION-DOWN (make-posn 0 0) MAP-GHOST-PINK))
(define EX-CVC-GHOST5 (make-character MAP-GHOST-RED DIRECTION-DOWN (make-posn 0 0) MAP-PACMAN))

; just move ghost - no pacman allowed
(check-expect (collect-valid-choice EX-CVC-GHOST0 #false) EX-CVC-GHOST0)
(check-expect (collect-valid-choice EX-CVC-GHOST1 #false) EX-CVC-GHOST1)
(check-expect (collect-valid-choice EX-CVC-GHOST2 #false) EX-CVC-GHOST2)
(check-expect (collect-valid-choice EX-CVC-GHOST3 #false) #false)
(check-expect (collect-valid-choice EX-CVC-GHOST4 #false) #false)
(check-expect (collect-valid-choice EX-CVC-GHOST5 #false) #false)

; looking for pacman
(check-expect (collect-valid-choice EX-CVC-GHOST0 #true) #false)
(check-expect (collect-valid-choice EX-CVC-GHOST1 #true) #false)
(check-expect (collect-valid-choice EX-CVC-GHOST2 #true) #false)
(check-expect (collect-valid-choice EX-CVC-GHOST3 #true) #false)
(check-expect (collect-valid-choice EX-CVC-GHOST4 #true) #false)
(check-expect (collect-valid-choice EX-CVC-GHOST5 #true) EX-CVC-GHOST5)

;; Template
;(define (collect-valid-choice ghost looking-for-pacman)
;  (local
;    [(define item ...)]
;    [cond
;      [(and (not looking-for-pacman)
;            (not (char=? item MAP-WALL))
;            (not (char=? item MAP-GHOST-RED))
;            (not (char=? item MAP-GHOST-ORANGE))
;            (not (char=? item MAP-GHOST-PINK))
;            (not (char=? item MAP-GHOST-CYAN))) ...]
;      [(and looking-for-pacman
;            (char=? item MAP-PACMAN))           ...]
;      [else                                     ...]]))

;; Code - used by (move-ghost)
(define (collect-valid-choice ghost looking-for-pacman)
  (local
    [; param abbreviations
     (define item (character-item-below ghost))]
    ; body
    [cond
      ; if we are not looking for pacman and want to move the ghost wherever
      [(and (not looking-for-pacman)
            (not (char=? item MAP-WALL))
            (not (char=? item MAP-GHOST-RED))
            (not (char=? item MAP-GHOST-ORANGE))
            (not (char=? item MAP-GHOST-PINK))
            (not (char=? item MAP-GHOST-CYAN))
            (not (char=? item MAP-PACMAN))) ghost]
      ; if we are looking specifically for pacman
      [(and looking-for-pacman
            (char=? item MAP-PACMAN)) ghost]
      ; if the choice is unvalid because of obstacles or not finding pacman
      [else #f]]))

;*********************************************************************************
;;; MOVE POSN
;; Data types
; Posn
; Direction

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

;; Code - used by (...)
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
;; Data types
; Map is a Vector<String> from struct Appstate (appstate-map)

;; Input/Output
; find-in-map : Map Posn -> Char
; given the appstate and a position, return the element at that map position
; header :
; (define (find-in-map map posn) Char)

;; Examples
(check-expect (find-in-map INIT-MAP INIT-PACMAN-POSN) MAP-PACMAN)
(check-expect (find-in-map INIT-MAP INIT-GHOST-RED-POSN) MAP-GHOST-RED)
(check-expect (find-in-map INIT-MAP INIT-GHOST-ORANGE-POSN) MAP-GHOST-ORANGE)
(check-expect (find-in-map INIT-MAP INIT-GHOST-PINK-POSN) MAP-GHOST-PINK)
(check-expect (find-in-map INIT-MAP INIT-GHOST-CYAN-POSN) MAP-GHOST-CYAN)

;; Template
; (define (find-in-map map posn)
;   (string-ref (vector-ref ....) ...)

;; Code - used by (...)
(define (find-in-map map posn)
  (string-ref (vector-ref map (posn-y posn)) (posn-x posn)))

;*******************************************************************************************************
;;; FIND AND REPLACE
;; Data types
; Map is a Vector<String> from struct Appstate (appstate-map)
; Posn
; Name is a String from struct Character (character-name)

;; Input/Output
; find-n-replace : Map Posn Name -> Map
; given a list of string representing a map, checks each row if matches position that needs updating,
; if so proceeds to update the string
; header :
; (define (find-n-replace map posn name) Map)

;; Examples
(define EX-FNR-PRE-MAP (vector ".." ".."))
(define EX-FNR-POST-MAP (vector ".." ".P"))
(define EX-FNR-POSN (make-posn 1 1))
(check-expect (find-n-replace EX-FNR-PRE-MAP EX-FNR-POSN MAP-PACMAN) EX-FNR-POST-MAP)

;; Template

;; Code - used by (...) 
(define (find-n-replace map posn name)
  (local
    [; pre-calculated param abbreviations
     (define rows-number (vector-length map))
     (define y (posn-y posn))
     (define x (posn-x posn))]
    ; body
    [for/vector ([i (in-range rows-number)])
      (if
       (= i y)
       (local
         ; converts string row in list
         [(define list (string->list (vector-ref map y)))]
         [list->string
          (for/list ([i (in-range (length list))])
            (if
             (= i x)
             name
             (list-ref list i)))])
       (vector-ref map i))]))

;*******************************************************************************************************
;;; UPDATE MAP
;; Data types
; Map

;; Input/Output
; update-map : Map Posn Posn Char Char -> Map
; given map, current and future position and name of a character,
; updates the map according to a given character
; header :
; (define (update-map map posn-previous posn-next return-item return-character) Map)

;; Examples
(define EX-UM-MAP0 (vector "P.." "..."))
(define EX-UM-MAP1 (vector "..." "P.."))
(define EX-UM-MAP2 (vector "..." ".P."))
(check-expect (update-map EX-UM-MAP0 (make-posn 0 0) (make-posn 0 1) MAP-DOT MAP-PACMAN) EX-UM-MAP1)
(check-expect (update-map EX-UM-MAP1 (make-posn 0 1) (make-posn 1 1) MAP-DOT MAP-PACMAN) EX-UM-MAP2)

;; Template
; (define (update-map map posn-previous pos-next return-item return-character)
;   (local [(define los                 ...)
;           (define map-with-prev-item (find-n-replace ...))]
;     (list->vector (find-n-replace ...))))

;; Code - used by (...)
(define (update-map map posn-previous posn-next return-item return-character)
  (local
    [; map with previous item given back
     (define map-with-prev-item (find-n-replace
                                 map
                                 posn-previous
                                 return-item))]
    ; body
    (find-n-replace
     map-with-prev-item
     posn-next
     return-character)))

;*******************************************************************************************************
;;; UPDATE SCORE
;; Data types
; Score is a Natural from struct Appstate (appstate-score)
; Item is a Char from struct Character (character-overlayed-item)

;; Input/Output
; update-score : Score Item -> Score
; given an item, check if it is a valuable one, and if it is so, add it to the score
; Assumptions | this function can be used only by pacman
; header :
; (define (update-score Score Item) Score)

;; Examples
(check-expect (update-score 0 MAP-DOT) POINTS-DOT)
(check-expect (update-score 0 MAP-CHERRY) POINTS-CHERRY)
(check-expect (update-score 0 MAP-POWERPELLET) POINTS-POWERPELLET)
(check-expect (update-score 0 MAP-EMPTY) 0)

;; Template
; (define (update-score score item)
;   (cond
;     [(char=? item MAP-DOT)         ... score ...]
;     [(char=? item MAP-CHERRY)      ... score ...]
;     [(char=? item MAP-POWERPELLET) ... score ...]
;     [else                          ... score ...]))

;; Code - used by (tick-handler)
(define (update-score score item)
  (cond
    [(char=? item MAP-DOT) (+ score POINTS-DOT)]
    [(char=? item MAP-CHERRY) (+ score POINTS-CHERRY)]
    [(char=? item MAP-POWERPELLET) (+ score POINTS-POWERPELLET)]
    [else score]))

;*******************************************************************************************************
;;; POST UPDATE SCORE
;; Data types
; Pacman

;; Input/Output
; post-update-score : Pacman -> Pacman
; clear the item pacman has overlayed
; header :
; (define (clear-item pacman) Pacman)

;; Examples
(define EX-PUS-PACMAN0 (make-pacman
                        (make-character
                         MAP-PACMAN
                         DIRECTION-DOWN
                         INIT-PACMAN-POSN
                         MAP-CHERRY)
                        #true))
(define EX-PUS-PACMAN1 (make-pacman
                        (make-character
                         MAP-PACMAN
                         DIRECTION-DOWN
                         INIT-PACMAN-POSN
                         MAP-EMPTY)
                        #true))

(check-expect (clear-item INIT-PACMAN) INIT-PACMAN)
(check-expect (clear-item EX-PUS-PACMAN0) EX-PUS-PACMAN1)

;; Template
;(define (clear-item pacman)
;  (local
;     (define character ...)
;     (define name      ...)
;     (define direction ...)
;     (define position  ...)
;     (define mouth     ...)]
;    [make-pacman ...]))

;; Code - used by (tick-handler)
(define (clear-item pacman)
  (local
    [; param abbreviations
     (define character (pacman-character pacman))
     (define name (character-name character))
     (define direction (character-direction character))
     (define position (character-position character))
     (define mouth (pacman-mouth pacman))]
    ; body
    [make-pacman
     (make-character
      name
      direction
      position
      MAP-EMPTY)
     mouth]))

;*******************************************************************************************************
;;; PRE GAME OVER
;; Data types
; Pacman
; Active is a Boolean from struct Powerpellet-effect (powerpellet-effect-active)
; Quit is a Boolean

;; Input/Output
; pre-game-over : Pacman Active -> Quit
; check if pacman collided with an unvulnerable ghosts, if so quit the game
; header :
; (define (game-over pacman active) Quit)

;; Examples
(define EX-PGO-PACMAN (make-pacman
                       (make-character
                        MAP-PACMAN
                        DIRECTION-DOWN
                        INIT-PACMAN-POSN
                        MAP-GHOST-RED)
                       #true))

(check-expect (pre-game-over INIT-PACMAN #false) #false)
(check-expect (pre-game-over INIT-PACMAN #true) #false)
(check-expect (pre-game-over EX-PGO-PACMAN #false) #true)
(check-expect (pre-game-over EX-PGO-PACMAN #true) #false)

;; Template
; (define (pre-game-over pacman active)
;   (and
;     (not active)
;     (collision-pacman ...))))

;; Code - used by (tick-handler)
(define (pre-game-over pacman active)
  (and (not active)
       (collision-pacman pacman)))

;*******************************************************************************************************
;;; GAME OVER
;; Data types
; Ghosts is a List<Character>
; Active is a Boolean from struct Powerpellet-effect (powerpellet-effect-active)
; Score is a Natural
; Quit is a Boolean


;; Input/Output
; game-over : Ghosts Active Score -> Quit
; check all possible causes of game over and if there are any, quit the game :
; - collision with unvulnerable ghost
; - collection of all points
; header :
; (define (game-over ghosts active score) Quit)

;; Examples
(define EX-GO-GHOST0 (make-character MAP-GHOST-RED DIRECTION-DOWN (make-posn 0 0) MAP-PACMAN))
(define EX-GO-GHOST1 (make-character MAP-GHOST-ORANGE DIRECTION-LEFT (make-posn 1 1) MAP-EMPTY))
(define EX-GO-GHOST2 (make-character MAP-GHOST-PINK DIRECTION-RIGHT (make-posn 2 22) MAP-DOT))
(define EX-GO-GHOSTS-WITH-COLLISION (list EX-GO-GHOST0 EX-GO-GHOST1 EX-GO-GHOST2))
(define EX-GO-GHOSTS-WITHOUT-COLLISION (list EX-GO-GHOST1 EX-GO-GHOST2))

(check-expect (game-over EX-GO-GHOSTS-WITH-COLLISION #false 0) #true)
(check-expect (game-over EX-GO-GHOSTS-WITH-COLLISION #true 0) #false)
(check-expect (game-over EX-GO-GHOSTS-WITHOUT-COLLISION #false 0) #false)
(check-expect (game-over EX-GO-GHOSTS-WITHOUT-COLLISION #true 0) #false)
(check-expect (game-over EX-GO-GHOSTS-WITHOUT-COLLISION #false TOTAL-POINTS) #true)
(check-expect (game-over EX-GO-GHOSTS-WITHOUT-COLLISION #false (- TOTAL-POINTS 1)) #false)
(check-expect (game-over EX-GO-GHOSTS-WITH-COLLISION #true TOTAL-POINTS) #true)

;; Template
; (define (game-over ghosts active score)
;   (or
;    (is-fullscore ...)
;    (and
;     (not active)
;     (collision-ghosts ...))))

;; Code - used by (tick-handler)
(define (game-over ghosts active score)
  (or
   (is-fullscore score)
   (and
    (not active)
    (collision-ghosts ghosts))))

;*********************************************************************************
;;; IS FULL SCORE
;; Data types
; Score is a Natural from struct Appstate (appstate-score)
; Quit is a Boolean form struct Appstate (appstate-quit)

;; Input/Output
; is-fullscore : Score -> Quit
; check if score is full, if it is return true otherwise false
; header:
; (define (is-fullscore score) Boolean)

;; Examples
(check-expect (is-fullscore 0) #false)
(check-expect (is-fullscore TOTAL-POINTS) #true)
(check-expect (is-fullscore (- TOTAL-POINTS 1)) #false)

;; Template
; (define (is-fullscore score)
;   (>= score TOTAL-POINTS))

;; Code - used by (game-over)
(define (is-fullscore score)
  (>= score TOTAL-POINTS))

;*********************************************************************************
;;; COLLISION PACMAN
;; Data types
; Pacman
; Quit is a Boolean from struct Appstate (appstate-quit)

;; Input/Output
; collision-pacman : Pacman -> Quit
; check if pacman overlayed a ghost
; header :
; (define (collision-pacman pacman) Quit)

;; Examples
(define EX-CP-PACMAN0 (make-pacman
                       (make-character
                        MAP-PACMAN
                        DIRECTION-DOWN
                        INIT-PACMAN-POSN
                        MAP-GHOST-RED)
                       #true))

(check-expect (collision-pacman INIT-PACMAN) #false)
(check-expect (collision-pacman EX-CP-PACMAN0) #true)

;; Template
; (define (collision-pacman pacman)
;   (local
;     [(define item ...)]
;     [or (char=? item MAP-GHOST-RED)
;         (char=? item MAP-GHOST-ORANGE)
;         (char=? item MAP-GHOST-PINK)
;         (char=? item MAP-GHOST-CYAN)]))

;; Code - used by (pre-game-over)
(define (collision-pacman pacman)
  (local
    [(define item (character-item-below (pacman-character pacman)))]
    [or (char=? item MAP-GHOST-RED)
        (char=? item MAP-GHOST-ORANGE)
        (char=? item MAP-GHOST-PINK)
        (char=? item MAP-GHOST-CYAN)]))

;*********************************************************************************
;;; COLLISION GHOSTS
;; Data types
; Ghosts is a List<Character>
; Quit is a Boolean from struct Appstate (appstate-quit)

;; Input/Output
; collision-ghosts : Ghosts -> Quit
; check if the game ends because of a collision between pacman and an invulnerable ghost
; logic | check hidden element in all ghosts if they match with MAP-PACMAN
; assumption | pacman is only one, powerpellet effect is off
; header :
; (define (collision ghosts) Quit)

;; Examples
(define EX-C-POSN (make-posn 0 0))
(define EX-C-GHOST0 (make-character MAP-GHOST-RED DIRECTION-UP EX-C-POSN MAP-PACMAN))
(define EX-C-GHOST1 (make-character MAP-GHOST-RED DIRECTION-UP (make-posn 1 1) MAP-EMPTY))
(define EX-C-GHOST2 (make-character MAP-GHOST-RED DIRECTION-UP (make-posn 2 2) MAP-DOT))
(define EX-C-GHOST3 (make-character MAP-GHOST-RED DIRECTION-UP (make-posn 3 3) MAP-CHERRY))
(define EX-C-GHOSTS-TRUE (list EX-C-GHOST0 EX-C-GHOST1 EX-C-GHOST2 EX-C-GHOST3))
(define EX-C-GHOSTS-FALSE (list EX-C-GHOST1 EX-C-GHOST2 EX-C-GHOST3))

(check-expect (collision-ghosts EX-C-GHOSTS-TRUE) #true)
(check-expect (collision-ghosts EX-C-GHOSTS-FALSE) #false)

;; Template
; (define (collision-ghosts ghosts)
;   (local
;     [(define possible-collisions ...)]
;   [foldl
;    (λ (item result) (or item result))
;    #false
;    possible-collisions]))

;; Code - used by (quit)
(define (collision-ghosts ghosts)
  (local
    [(define possible-collisions (map
                                  (λ (g) (char=? MAP-PACMAN (character-item-below g)))
                                  ghosts))]
  [foldl
   (λ (item result) (or item result))
   #false
   possible-collisions]))
