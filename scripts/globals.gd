extends Node
var has_shield = false
var health: int = 100
var velocity: float
var score: int = 0
var boosts: int = 0 #this shoukld range from 0 to 3 @Hazoro
signal out_of_fuel
