;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname handler) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;structures
(define-struct character [name direction position])
(define-struct appstate [map score pp-active? pacman-mouth pacman ghost quit])
(define EX-MAP2 (vector
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
                "WWWWWW.WW W    r W WW.WWWWWW"
                "      .   W o    W   .      "
                "WWWWWW.WW W p  c W WW.WWWWWW"
                "     W.WW WWWWWWWW WW.W     "
                "     W.WW          WW.W     "
                "     W.WW WWWWWWWW WW.W     "
                "WWWWWW.WW WWWWWWWW WW.WWWWWW"
                "W............WW............W"
                "W.WWWW.WWWWW.WW.WWWWW.WWWW.W"
                "W.WWWW.WWWWW.WW.WWWWW.WWWW.W"
                "W@..WW....... P.......WW..@W"
                "WWW.WW.WW.WWWWWWWW.WW.WW.WWW"
                "WWW.WW.WW.WWWWWWWW.WW.WW.WWW"
                "W......WW....WW....WW......W"
                "W.WWWWWWWWWW.WW.WWWWWWWWWW.W"
                "W.WWWWWWWWWW.WW.WWWWWWWWWW.W"
                "W.....Y..............Y.....W"
                "WWWWWWWWWWWWWWWWWWWWWWWWWWWW"))
(define state1 (make-appstate  EX-MAP2 0 #false #false (make-character "Pac-man" "r" (make-posn 13 17))))

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
;Quitter
(define (quit? state)
  (appstate-quit state))

;*******************************************************************************************************
;; points handler
(define DOT-POINTS 10)

(define (add-points appstate obj)
  (if [string? obj "."]
      (make-appstate (appstate-map appstate)
                     (+ (appstate-score appstate) DOT-POINTS)
                     (appstate-pacman appstate)
                     (appstate-pp-active appstate)
                     (appstate-pacman-mouth appstate)
                     (appstate-quit appstate))))