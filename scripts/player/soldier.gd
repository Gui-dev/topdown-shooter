extends KinematicBody2D
class_name Soldier


onready var texture: Sprite = $texture
onready var move_state: Node = $states/move
onready var attack_state: Node = $states/move
var is_crawling: bool = false
var is_attacking: bool = false


func _physics_process(_delta: float) -> void:
  move_state.move()
#  attack_state.attack()
  texture.animate(move_state.velocity)
  pass
  
