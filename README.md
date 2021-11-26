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
Another nice 8 bit song with incresed velocity for power pellet

## Sound Effects

- pacman eating
- ghost-pacman collision
- game over
- eaten dot
- power pellet powerup taken
