extends Node
var has_shield = false
var shield = 0
var health: int = 100
var velocity: float
var score: int = 0
var fuel: int = 1000
var boosts: int = 0 #this shoukld range from 0 to 3 @Hazoro
signal out_of_fuel #if this is emited, make the trail disappear and spx would go 3x slower
