extends Node

const SEED = 0

# Game parameters :
var GAME_SHIELD = load("res://Obstacles/Shield.tscn")
var GAME_DREAM_CATCHER = load("res://Obstacles/DreamCatcher.tscn")

# Player parameters :
const PLAYER_WALK_SPEED = 250
### /!\ Setting this paramter lower than 0.501 creates
### strange/ugly behavior with cast animation
const BUILD_RELOAD_TIME = 0.505

# Ally projectiles parameters :
const ALLY_PROJECTILE_SPEED = 10
const ALLY_PROJECTILE_SPAWN_DELAY = 5

# Enemy projectiles parameters :
const ENEMY_PROJECTILE_SPEED = 8
const ENEMY_PROJECTILE_SPAWN_DELAY = 0.1

# Doom projectiles parameters :
const DOOM_PROJECTILE_SPEED = 8
const DOOM_PROJECTILE_SPAWN_DELAY = 0.1

# Shield parameters :
const SHIELD_MAX_LIFETIME := 10.0
const SHIELD_HIT_DAMAGE := 1.0

# Dream catcher parameters :
const DREAM_CATCHER_MAX_LIFETIME := 5.0

const DEBUG_CAMERA := false
