extends Node

# Game parameters :
const GAME_WALL = preload("res://Obstacles/Wall.tscn")
const GAME_DREAM_CATCHER = preload("res://Obstacles/DreamCatcher.tscn")

# Player parameters :

const PLAYER_WALK_SPEED = 500
const BUILD_RELOAD_TIME = 1

# Ally projectiles parameters :
const ALLY_PROJECTILE_SPEED = 10
const ALLY_PROJECTILE_SPAWN_DELAY = 5

# Enemy projectiles parameters :
const ENEMY_PROJECTILE_SPEED = 10
const ENEMY_PROJECTILE_SPAWN_DELAY = 0.1

# Wall parameters :
const WALL_NUMBER_OF_SPRITES = 1
const WALL_MAX_LIFETIME := 30.0

# Dream catcher :
const DREAM_CATCHER_NUMBER_OF_SPRITES = 1
