;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname handler) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
(define (handler key state)
  (cond
    [(equal? key "left") (move-left state)]
    [(equal? key "right") (move-right state)]
    [(equal? key "up") (move-up state)]
    [(equal? key "down") (move-down state)]
    [else state]))

(define (move-left state)
  (local (
          (define pac-pos (((character-position) ((appstate-pacman) state))))
          (define pac-next (make-posn (- (posn-x pac-posn) 1) (posn-y pac-pos)))
          (define next (find state pac-next)))
    (cond
      [(or (equal? next "_") (equal? next "W")) state]
      [(equal? next ".") (make-appstate (map-update state) (+ (appstate-score state) 10) (app-state-pp-active? state) pac-next #false)]
      [(equal? next "@") (make-appstate (map-update state) (+ (appstate-score state) 100) #true (appstate-pacman-mouth state) pac-next #false)]
      [(equal? next "Y") (make-appstate (map-update state) (+ (appstate-score state) 100) (app-state-pp-active? state) pac-next #false)]
      [(equal? next "e") (make-appstate (map-update state) (+ (appstate-score state) 100) (app-state-pp-active? state) pac-next #false)]
      [(or (equal? next "r") (equal? next "p") (equal? next "o") (equal? next "c")) (make-appstate (map-update state) (appstate-score state) (app-state-pp-active? state) pac-next #true)]
      [(equal? next " ") (make-appstate (map-update state) (appstate-score state) (app-state-pp-active? state) pac-next #false)])))

(define (move-right state)
  (local (
          (define pac-pos (((character-position) ((appstate-pacman) state))))
          (define pac-next (make-posn (+ (posn-x pac-posn) 1) (posn-y pac-pos)))
          (define next (find state pac-next)))
    (cond
      [(or (equal? next "_") (equal? next "W")) state]
      [(equal? next ".") (make-appstate (map-update state) (+ (appstate-score state) 10) (app-state-pp-active? state) pac-next #false)]
      [(equal? next "@") (make-appstate (map-update state) (+ (appstate-score state) 100) #true (appstate-pacman-mouth state) pac-next #false)]
      [(equal? next "Y") (make-appstate (map-update state) (+ (appstate-score state) 100) (app-state-pp-active? state) pac-next #false)]
      [(equal? next "e") (make-appstate (map-update state) (+ (appstate-score state) 100) (app-state-pp-active? state) pac-next #false)]
      [(or (equal? next "r") (equal? next "p") (equal? next "o") (equal? next "c")) (make-appstate (map-update state) (appstate-score state) (app-state-pp-active? state) pac-next #true)]
      [(equal? next " ") (make-appstate (map-update state) (appstate-score state) (app-state-pp-active? state) pac-next #false)])))

(define (move-down state)
  (local (
          (define pac-pos (((character-position) ((appstate-pacman) state))))
          (define pac-next (make-posn (posn-x pac-posn) (+ (posn-y pac-pos) 1)))
          (define next (find state pac-next)))
    (cond
      [(or (equal? next "_") (equal? next "W")) state]
      [(equal? next ".") (make-appstate (map-update state) (+ (appstate-score state) 10) (app-state-pp-active? state) pac-next #false)]
      [(equal? next "@") (make-appstate (map-update state) (+ (appstate-score state) 100) #true (appstate-pacman-mouth state) pac-next #false)]
      [(equal? next "Y") (make-appstate (map-update state) (+ (appstate-score state) 100) (app-state-pp-active? state) pac-next #false)]
      [(equal? next "e") (make-appstate (map-update state) (+ (appstate-score state) 100) (app-state-pp-active? state) pac-next #false)]
      [(or (equal? next "r") (equal? next "p") (equal? next "o") (equal? next "c")) (make-appstate (map-update state) (appstate-score state) (app-state-pp-active? state) pac-next #true)]
      [(equal? next " ") (make-appstate (map-update state) (appstate-score state) (app-state-pp-active? state) pac-next #false)])))

(define (move-up state)
  (local (
          (define pac-pos (((character-position) ((appstate-pacman) state))))
          (define pac-next (make-posn (posn-x pac-posn) (- (posn-y pac-pos) 1)))
          (define next (find state pac-next)))
    (cond
      [(or (equal? next "_") (equal? next "W")) state]
      [(equal? next ".") (make-appstate (map-update state) (+ (appstate-score state) 10) (app-state-pp-active? state) pac-next #false)]
      [(equal? next "@") (make-appstate (map-update state) (+ (appstate-score state) 100) #true (appstate-pacman-mouth state) pac-next #false)]
      [(equal? next "Y") (make-appstate (map-update state) (+ (appstate-score state) 100) (app-state-pp-active? state) pac-next #false)]
      [(equal? next "e") (make-appstate (map-update state) (+ (appstate-score state) 100) (app-state-pp-active? state) pac-next #false)]
      [(or (equal? next "r") (equal? next "p") (equal? next "o") (equal? next "c")) (make-appstate (map-update state) (appstate-score state) (app-state-pp-active? state) pac-next #true)]
      [(equal? next " ") (make-appstate (map-update state) (appstate-score state) (app-state-pp-active? state) pac-next #false)])))

;tests
      