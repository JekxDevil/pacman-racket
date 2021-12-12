# pacman-racket

An implementation of the well-known Pacman in racket programming language following the guides of the How To Design Programs book. The project is intended as for educational purposes

### TEAM MEMBERS

- Alessandro Zanzi
- Filippo Piloni
- Jeferson Morales Mariciano
- Paolo Deidda

### GRADING CRITERIA

Discussion, User guide, Developer guide, README, Design, Test/correctness, Code style, Features

## MILESTONE 1

---------------------

#### ROADMAP

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

#### SKINS CHARACTERS

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

#### LABYRINTH MAP

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

#### CHARACTERS

Character is a structure `(make-character name direction position)`
- name is `String`
- direction is `Enumerator`
- position is `Posn`

#### APPSTATE

Appstate is a struct `(make-appstate map score pp-active? pacman-mouth)`
- labyrinth is `Vector<String>`
- score is a `Natural`
- pp-active is `Boolean`
- pacman-mouth is `Boolean`

#### RENDER

render (labyrinth) 

#### HANDLER

arrows: up, down, left, right
esc: menu [continue, quit]
button on/off in-game volume: 'M'

#### SOUNDTRACK

Nice 8 bit song normal
Another nice 8 bit song with increased velocity for power pellet

#### SOUND EFFECTS

- pacman eating
- ghost-pacman collision
- game over
- eaten dot
- power pellet powerup taken

## MILESTONE 2

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

*(+) ADDED*

Pacman is a struct `(make-pacman moving mouth)`
- moving is a `Character`
- mouth is a `Boolean`


*(c) CHANGED*

Appstate is a struct `(make-appstate map score pp-active? pacman-mouth)`
- (c) ~~labyrinth~~ map is `Vector<String>`
- (+) pacman is `Pacman`
- (+) ghosts is `List<Ghost>`
- score is `Natural`
- pp-active is `Boolean`
- (-) ~~pacman-mouth~~
- (+) quit is `Boolean`

#### FIGURES

- Every setting has been defined as constant
- Code refined
- Render section has been moved to render file
- Score rectangle for points view has been added

#### RENDER

Generic settings have been moved to data_structures.rkt

*(+) ADDED*
  -  (conversion-char) to render given an element of the map, its image
  - (conversion-pacman) -> pacman image
  - (conversion-pacman-mouth) -> pacman image based on mouth state
  - (conversion-ghosts) -> ghost image
  - (conversion-row) -> row image
  - (conversion-map) -> map image
  - (render-score) -> image representation of score
  - (render) to give image representation of the appstate

#### HANDLER

*(+) ADDED*

- (key-handler) -> handler of key stroke events
- (move-posn) -> creates new position given direction and previous position
- (find-in-map) -> return char element of map at a given position
- (move-pacman) -> handler pacman move logic
- (check-edible) -> when colliding, see if pacman can or can't eat the ghost
- (check-fullscore) -> quit the game if all points are collected
- (quit) -> quit the game by editing the appstate
- (quit?) -> return a boolean stating if the game ended

#### MAIN

*(+) ADDED*

- libraries imports
- big-bang construction
- big-bang runner

## MILESTONE 3

---------------------

#### DATA STRUCTURES

*(+) ADDED*

Powerpellet-effect is a struct `(make-powerpellet-effect active active-ticks)`
  - active is `Boolean`
  - active-ticks is `Natural`
  

*(-) REMOVED*
 * Ghost

*(c) CHANGED*

Character is a structure `(make-character name direction position item-below)`
- (c) name is `Char`
- (c) direction is `Direction`
- position is `Posn`
- (+) item-below is `Char`



Appstate is a struct `(make-appstate map pacman ghosts score powerpellet-effect quit)`
- map is `Vector<String>`
- pacman is `Pacman`
- (c) ghosts is `List<Character>`
- score is `Natural`
- (-) ~~pp-active~~
- (+) powerpellet-effect is `Powerpellet-effect`
- quit is `Boolean`

#### HANDLER
*(+) ADDED*
 * (change-pacman-direction) -> changes pacman direction when correspondent key is pressed

*(-) REMOVED*
 * (move-posn)
 * (move-pacman)
 * (check-edible)
 * (check-fullscore)
 * (quit)
 * (quit?)
 * (add-points)

#### MAIN
*(+) ADDED*
 * (quit?) -> takes an appstate and returns a bool indicating whether the app has quit or not

#### RENDER
*(+) ADDED*
* (render-game-over) -> draws "Game Over" text on screen

#### TICK HANDLER
*(+) ADDED*
* (tick-handler) -> handler general logic events of the game at each tick
* (move-pacman) -> handles pacman move logic
* (update-pp-effect) -> updates powerpellet effect managing ticks and state when powerpellet is active
* (move-ghost) -> move ghost position and direction randomly, but there is pacman following if it's 1 block distant
* (move-ghosts) -> update the whole ghosts list at each tick
* (collect-possible-choices) -> group choices available, discarding non-ghost values which are invalid choices
* (collect-valid-choice) -> given pacman or a valid map cell as its aim, return a ghost if the cell pointed by the choice is eligible, otherwise return false
* (move-posn) -> create a new position given direction and previous position
* (find-in-map) -> given the appstate and a position, return the element at that map position
* (find-n-replace) -> given a list of string representing a map, checks each row if matches position that needs updating, if so proceeds to update the string
* (update-map) -> given map, current and future position and name of a character, updates the map according to a given character
* (update-score) -> given an item, check if it is a valuable one, and if it is so, add it to the score
* (clear-item) -> clear the item pacman has overlayed
* (pre-game-over) -> check if pacman collided with an unvulnerable ghosts, if so quit the game
* (game-over) -> check all possible causes of game over and if there are any, quit the game
* (is-fullscore) -> check if score is full, if it is return true otherwise false
* (collision-pacman) -> check if pacman overlayed a ghost
* (collision-ghosts) -> check if the game ends because of a collision between pacman and an invulnerable ghost
