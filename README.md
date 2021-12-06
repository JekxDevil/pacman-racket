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

- Research about game rules , logic and racket implementation
- Data types discussion and definition
- UX and UI discussion
- Setup git repository on GitHub
- Added .gitignore
- Divide program in modules to split workload
- Divide workload to team members
- Implemented figures
- Testing and implementening import/export figures (API)
- Discussion about how to store score 
	- csv file
- Side features conceptualization 
	- music
	- sound effects
	- VFX
	- game menu
	- scoreboard 
- Create empty user guide in LaTeX

## Skins characters

- **pacman**
  - open
  - closed
- **ghosts**
  - red
  - cyan
  - pink
  - orange
  - blue :  edible
- **dot** : 1 point
- **cherry** : +100 points
- **power pellets** : make ghosts edible 

## Labyrinth map

Map is a `Vector<String>`

map representation :
- "W" wall
- " " empty cell space
- "." dot point
- "@" power pellet
- "P" pacman
- ghosts:
  - "e" **edible**
  - "o" orange
  - "r" red
  - "p" pink
  - "c" cyan
- "_" ghost gate
- "Y" cherry

## Characters

Character is a structure `(make-character name direction position)`
- name is `String`
- direction is `Enumerator`
- position is `Posn`

## Appstate

Appstate is a struct `(make-appstate map score pp-active? pacman-mouth)`
- labyrinth is `Vector<String>`
- score is a `Natural`
- pp-active is `Boolean`
- pacman-mouth is `Boolean`

## Render

render (labyrinth) 

## Handler

arrows: up, down, left, right
esc: menu [continue, quit]
button on/off in-game volume: 'M'

## Soundtrack

Nice 8 bit song normal
Another nice 8 bit song with increased velocity for power pellet

## Sound Effects

- pacman eating
- ghost-pacman collision
- game over
- eaten dot
- power pellet powerup taken



### MILESTONE 2

---------------------

#### GENERAL

API added to work in parallel at the project

Design recipe applied to functions

Following common format style in files

Stick to char in order to occupy less memory and have predefine rigid data type

#### DATA STRUCTURES

* STRUCT changing:
  * struct pacman, ghost added with proper specific fields
  * struct character used as inherited in pacman, ghost
* Added generic settings of the game
* Every setting has been defined as a constant and used as it in other files
* Added examples of instances of data structures

#### FIGURES

- Every setting has been defined as constant
- Code refined
- Render section has been moved to render file
- Score rectangle for points view has been added

#### RENDER

- Generic settings have been moved to data_structures.rkt
- Added:
  -  (conversion-char) to render given an element of the map, its image
  - (conversion-pacman) -> pacman image
  - (conversion-pacman-mouth) -> pacman image based on mouth state
  - (conversion-ghosts) -> ghost image
  - (conversion-row) -> row image
  - (conversion-map) -> map image
  - (render-score) -> image representation of score
  - (render) to give image representation of the appstate

#### HANDLER

Added:

- (key-handler) -> handler of key stroke events
- (move-posn) -> creates new position given direction and previous position
- (find-in-map) -> return char element of map at a given position
- (move-pacman) -> handler pacman move logic
- (check-edible) -> when colliding, see if pacman can or can't eat the ghost
- (check-fullscore) -> quit the game if all points are collected
- (quit) -> quit the game by editing the appstate
- (quit?) -> return a boolean stating if the game ended

#### MAIN

Added:

- libraries imports
- big-bang construction
- big-bang runner