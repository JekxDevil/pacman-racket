;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname render) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
(require "figures.rkt")


(define SPEED-PACMAN 1)
(define SPEED-GHOSTS 0.80)

; test map 31x28
(define EX-MAP (vector
                "WWWWWWWWWWWWWWWWWWWWWWWWWWWW"
                "W............WW............W"
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
                "W..........................W"
                "WWWWWWWWWWWWWWWWWWWWWWWWWWWW"))