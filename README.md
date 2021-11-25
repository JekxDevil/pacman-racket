# pacman-racket

An implementation of the well-known Pacman in racket programming language following the guides of the How To Design Programs book. The project is intended as for educational purposes

## Team members

- Alessandro Zanzi
- Filippo Piloni
- Jeferson Morales Mariciano
- Paolo Deidda

## Grading Criteria

Discussion, User guide, Developer guide, README, Design, Test/correctness, Code style, Features

### MILESTONE 1

---------------------

- Revised definition of data type WorldState to support any number of players
- Implemented all auxiliary functions for editor module
- Wrote first draft of user guide
- Added several tests to main functions of rendering module
- Discussed whether to change the palette of buttons to using greens; decided against it, since it would make reading text harder

## Skins characters

- PACMAN
  - open
  - closed
- Ghosts
  - red
  - cyan
  - pink
  - orange
  - blue (edible)
- dots (points)
- power pellets
- cherry (+100 points)

## Map

The map Labyrinth

## State

Appstate will be composed by:
labyrinth structure

## Labyrinth

"+" corner

"|" vertical wall

"-" horizontal wall

" " empty cell space

"_" ghost doorway

## Appstate

Appstate

## Render

render labyrinth

render characters (input labyrinth)

- render pacman
- render ghost
- render points [dots, powerpellets, cherries]

## Handler

arrows: up, down, left, right
esc: menu [continue, quit]
button on/off in-game volume: 'M'

## Soundtrack

Nice 8 bit song normal
Another nice 8 bit song with incresed velocity for power pellet

## Sound Effects

- pacman eating
- ghost-pacman collision
- game over
- eaten dot
- power pellet powerup taken
