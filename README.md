# A Hero's Journey

A Hero's Journey is an interactive CLI game built with Ruby and ActiveRecord by Gordy Lanza and Bogomil Mihaylov. 

## Motivation

Our goal was to explore a three-class model with has-many/belongs-to associations and uses the ActiveRecord ORM to persist data between sessions. A game was a fun, interactive vehicle for us to develop.

## Features

Players are able to start a new game, load a previous game, view a leaderboard, and delete games. In a game, a player is able to go on a journey. Every journey is unique. Players encounter a unique monster (out of 30M possible monsters!), each with their own attributes and story. If they choose to fight rather than flee, they are presented with randomized dialogue for each turn of their journey. If the player survives the encounter with a monster, they receive a random reward. Between journeys, players can visit a shop which allows them to spend experience earned from journeys on buffs for their hero.

## Installation

1. Clone the master branch to your local.
2. Move to the ../a-heroes-journey/ directory.
3. Run the following commands in your terminal:

> $ bundle

> $ rake db:migrate

> $ ruby bin/run.rb

## License

MIT © gortron / bogomilam
