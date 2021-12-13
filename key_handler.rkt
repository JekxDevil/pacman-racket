;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname key_handler) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; LIBRARIES
(require racket/base)
(require 2htdp/image)
(require "data_structures.rkt")

;*********************************************************************************
;*********************************************************************************
;; API
(provide key-handler)

;*********************************************************************************
;*********************************************************************************
;;; KEY HANDLER
;; Datatypes
; key is a KeyEvent
; appstate is an Appstate

;; Input/Output
; key-handler : Appstate KeyEvent -> Appstate
; handler keystroke events of the game
; header :
; (define (key-handler appstate key) Appstate)

;; Examples
(define EX-CPD-APPSTATE0 (make-appstate
                         INIT-MAP
                         (make-pacman
                          (make-character MAP-PACMAN DIRECTION-UP INIT-PACMAN-POSN INIT-ITEM-BELOW)
                          #true)
                         INIT-GHOSTS
                         INIT-SCORE
                         INIT-POWERPELLET-EFFECT
                         INIT-QUIT))

(define EX-CPD-APPSTATE1 (make-appstate
                         INIT-MAP
                         (make-pacman
                          (make-character MAP-PACMAN DIRECTION-DOWN INIT-PACMAN-POSN INIT-ITEM-BELOW)
                          #true)
                         INIT-GHOSTS
                         INIT-SCORE
                         INIT-POWERPELLET-EFFECT
                         INIT-QUIT))

(define EX-CPD-APPSTATE2 (make-appstate
                         INIT-MAP
                         (make-pacman
                          (make-character MAP-PACMAN DIRECTION-LEFT INIT-PACMAN-POSN INIT-ITEM-BELOW)
                          #true)
                         INIT-GHOSTS
                         INIT-SCORE
                         INIT-POWERPELLET-EFFECT
                         INIT-QUIT))

(check-expect (key-handler INIT-APPSTATE "up") EX-CPD-APPSTATE0)
(check-expect (key-handler INIT-APPSTATE "right") INIT-APPSTATE)
(check-expect (key-handler INIT-APPSTATE "down") EX-CPD-APPSTATE1)
(check-expect (key-handler INIT-APPSTATE "left") EX-CPD-APPSTATE2)
(check-expect (key-handler INIT-APPSTATE "shift") INIT-APPSTATE)

;; Template
; (define (key-handler appstate key)
;   (cond [(equal? key "up")    ...]
;         [(equal? key "down")  ...]
;         [(equal? key "left")  ...]
;         [(equal? key "right") ...]
;         [else                 ...]))

;; Code - used by (big-bang)
(define (key-handler appstate key)
  (cond [(equal? key "up") (change-pacman-direction appstate DIRECTION-UP)]
        [(equal? key "down") (change-pacman-direction appstate DIRECTION-DOWN)]
        [(equal? key "left") (change-pacman-direction appstate DIRECTION-LEFT)]
        [(equal? key "right") (change-pacman-direction appstate DIRECTION-RIGHT)]
        [(equal? key "q") (quit appstate)]
        [else appstate]))

;*********************************************************************************
;;; CHANGE PACMAN DIRECTION
;Datatypes
;appstate is an Appstate
;direction is a Direction

;; Input/Output
; change-pacman-direction : Appstate Direction -> Appstate
; changes pacman direction when correspondent key is pressed
; header :
; (define (move appstate direction) Appstate)

;; Examples
(check-expect (change-pacman-direction INIT-APPSTATE DIRECTION-LEFT) EX-CPD-APPSTATE2)

;; Template
; (define (change-pacman-direction appstate direction)
;   (local
;     [(define map ...)
;      (define pacman ...)
;      (define ghosts ...)
;      (define score ...)
;      (define pp ...)
;      (define quit ...)
;      (define character ...)
;      (define name ...)
;      (define posn ...)
;      (define item ...)
;      (define mouth ...)
;      (define new-pacman ...)]
;     [make-appstate map new-pacman ghosts score pp quit]))

;; Code - used by (key-handler)
(define (change-pacman-direction appstate direction)
  (local
    [; appstate abbreviations
     (define map (appstate-map appstate))
     (define pacman (appstate-pacman appstate))
     (define ghosts (appstate-ghosts appstate))
     (define score (appstate-score appstate))
     (define pp (appstate-powerpellet-effect appstate))
     (define quit (appstate-quit appstate))
     ; pacman abbreviations
     (define character (pacman-character pacman))
     (define name (character-name character))
     (define posn (character-position character))
     (define item (character-item-below character))
     (define mouth (pacman-mouth pacman))
     ; pre-calculated value
     (define new-pacman (make-pacman
                         (make-character name direction posn item)
                         mouth))]
    ; body
    [make-appstate map new-pacman ghosts score pp quit]))

;*********************************************************************************
;;;QUIT
;Datatypes
;appstate is an Appstate

;Input/Output
; quit: Appstate --> Appstate
; modified the quit field in the appstate to #true
; header
; (define (quit Appstate) Appstate)

(check-expect (quit (make-appstate INIT-MAP INIT-PACMAN INIT-GHOSTS INIT-SCORE INIT-POWERPELLET-EFFECT #false))
              (make-appstate INIT-MAP INIT-PACMAN INIT-GHOSTS INIT-SCORE INIT-POWERPELLET-EFFECT #true))


(define (quit appstate)
  (local (
          (define map (appstate-map appstate))
          (define pacman (appstate-pacman appstate))
          (define ghosts (appstate-ghosts appstate))
          (define score (appstate-score appstate))
          (define pp (appstate-powerpellet-effect appstate)))
    (make-appstate map pacman ghosts score pp #true)))