# pacman-racket

An implementation of the well-known Pacman in racket programming language following the guides of the How To Design
Programs book. The project is intended as for educational purposes

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

arrows: up, down, left, right esc: menu [continue, quit]
button on/off in-game volume: 'M'

#### SOUNDTRACK

Nice 8 bit song normal Another nice 8 bit song with increased velocity for power pellet

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

- STRUCT changing:
    - struct pacman, ghost added with proper specific fields
    - struct character used as inherited in pacman, ghost

* Added generic settings of the game
* Every setting has been defined as a constant and used as it in other files
* Added examples of instances of data structures

*(+) ADDED*

Pacman is a struct `(make-pacman moving mouth)`

- moving is a `Character`
- mouth is a `Boolean`

Created Pacman to implement mouth property in a dedicated struct

Ghost is a struct `(make-pacman moving mouth)`

- character is a `Character`
- hidden-element is a `Char`

Created Ghost to hold character and info about block underneath, No need for Pacman as it always leaves an empty block
behind. Score is calculated at runtime when pacman moves in map.

*(c) CHANGED*

Appstate is a struct `(make-appstate map score pp-active? pacman-mouth)`

- (c) ~~labyrinth~~ map is `Vector<String>`
- (+) pacman is `Pacman`
- (+) ghosts is `List<Ghost>`
- score is `Natural`
- pp-active is `Boolean`
- (-) ~~pacman-mouth~~
- (+) quit is `Boolean`

Updated appstate: added ghosts and pacman structures, added quit property to specify if game ended

#### FIGURES

- Every setting has been defined as constant
- Code refined
- Render section has been moved to render file
- Score rectangle for points view has been added

#### RENDER

Generic settings have been moved to data_structures.rkt

*(+) ADDED*

- (conversion-char) to render given an element of the map, its image
- (conversion-pacman) -> pacman image
- (conversion-pacman-mouth) -> pacman image based on mouth state
- (conversion-ghosts) -> ghost image
- (conversion-row) -> row image
- (conversion-map) -> map image
- (render-score) -> image representation of score
- (render) to give image representation of the appstate

#### HANDLER

*(+) ADDED*

Each function takes as input the appstate and returns a new one with modified values.
(Problem with overloading functions, longer code and heavier workload)

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

## MILESTONE 3 | FINAL SUBMISSION

---------------------

We used multiple ways of recursion

We used different ways offered by DrRacket documentation and learned in class to manipulate the collections of 
data such as Maps (`Vector<String>`) and Lists:
- General Recursion : `render` and all its related functions widely use general recursion to build up
recursively the appstate in-game image;
- Look up by Indices : given its coordinate position, to find an element in a map we used its indices to retrieve
the correspondent character. Used by `find-n-map`;
- Index Iteration : To replace an element in the map, we used an incremental index to go through all the rows, and then
all the characters in the correspondent string, in order to change only the element in the specified position. Used by `find-n-replace`. 

#### DATA STRUCTURES

Added property `#:transparent` to structs to make property available to other files. Before, provided structures, were
behaving as functions. With this keyword properties are visible outside the file, and we can coherently create
structures with `make-<struct-name>` in all files.

Following changes are done along the KIS (Keep It Simple) and atomicity principles. Functions are specialized, they
accomplish a single task with as few arguments as possible.

*(+) ADDED*

Powerpellet-effect is a struct `(make-powerpellet-effect active ticks)`

- active is `Boolean`
- active-ticks is `Natural`

Added Powerpellet-effect to hold power-pellet effect info: if it is active and, if so, how long it has been.

*(c) CHANGED*

Character is a structure `(make-character name direction position item-below)`

- (c) name is `Char`
- (c) direction is `Direction`
- position is `Posn`
- (+) item-below is `Char`

Changed Character as now both Pacman and Ghost struct need to know what is underneath. Pacman item-below is used to
calculate score, this way function don't need the appstate as input; the code is shorter, cleaner and lighter. As a
result Ghost struct is no more needed.

*(-) REMOVED*

-Ghost

Appstate is a struct `(make-appstate map pacman ghosts score powerpellet-effect quit)`

- map is `Vector<String>`
- pacman is `Pacman`
- (c) ghosts is `List<Character>`
- score is `Natural`
- (-) ~~pp-active~~
- (+) powerpellet-effect is `Powerpellet-effect`
- quit is `Boolean`

**Handler files have been separated into key_handler and tick_handler**

#### KEY HANDLER

Following changes are made to satisfy the atomicity principle. Every keystroke corresponds to a change of direction. Key
handler in so longer in charge of movement. Movements are now implemented by tick_handler.

*(+) ADDED*

- (change-pacman-direction) -> changes pacman direction when correspondent key is pressed

*(-) REMOVED*

- (move-posn)
- (move-pacman)
- (check-edible)
- (check-fullscore)
- (quit)
- (quit?)
- (add-points)

#### MAIN

*(+) ADDED*

- (quit?) -> takes an appstate and returns a bool indicating whether the app has quit or not

#### RENDER

*(+) ADDED*

- (render-game-over) -> draws "Game Over" text on screen

#### TICK HANDLER

Handles all movements. Updates appstate following these steps:

- move pacman struct and update map consequently
- handle pp-effect
- check game over (pacman collided to ghost)
- move ghosts struct and update map consequently
- update score
- check game over (ghost collided to pacman or max score reached)
- free pacman from its overlayed item

*(+) ADDED*

- (tick-handler) -> handler general logic events of the game at each tick
- (move-pacman) -> handles pacman movement logic
- (update-pp-effect) -> updates power-pellet effect managing ticks and state when power-pellet is active
- (move-ghost) -> move ghost position and direction randomly, but there is pacman following if it's 1 block distant
- (move-ghosts) -> update the whole ghosts list at each tick
- (collect-possible-choices) -> group choices available, discarding non-ghost values which are invalid choices
- (collect-valid-choice) -> given pacman or a valid map cell as its aim, return a ghost if the cell pointed by the
  choice is eligible, otherwise return false
- (move-posn) -> create a new position given direction and previous position
- (find-in-map) -> given the appstate and a position, return the element at that map position
- (find-n-replace) -> given a list of string representing a map, checks each row if matches position that needs
  updating, if so proceeds to update the string
- (update-map) -> given map, current and future position and name of a character, updates the map according to a given
  character
- (update-score) -> given an item, check if it is a valuable one, and if it is so, add it to the score
- (clear-item) -> clear the item pacman has overlayed
- (pre-game-over) -> check if pacman collided with an unvulnerable ghosts, if so quit the game
- (game-over) -> check all possible causes of game over and if there are any, quit the game
- (is-fullscore) -> check if score is full, if it is return true otherwise false
- (collision-pacman) -> check if pacman overlayed a ghost
- (collision-ghosts) -> check if the game ends because of a collision between pacman and an invulnerable ghost
