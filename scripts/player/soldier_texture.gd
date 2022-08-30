extends Sprite
class_name SoldierTexture


var last_direction_state: bool
export(NodePath) onready var parent = get_node(parent) as KinematicBody2D
export(NodePath) onready var animation = get_node(animation) as AnimationPlayer


func animate(velocity: Vector2) -> void:
  flip_h = set_orientation()
  move_behavior(velocity)


func set_orientation() -> bool:
  var mouse_global_position: Vector2 = get_global_mouse_position()
  
  if mouse_global_position.x > parent.global_position.x:
    last_direction_state = false
    return false
    
  if mouse_global_position.x < parent.global_position.x:
    last_direction_state = true
    return true
    
  return last_direction_state


func move_behavior(velocity: Vector2) -> void:
  if velocity != Vector2.ZERO:
    animation.play(get_move_state())
    return
    
  animation.play('idle')


func get_move_state() -> String:
  if parent.is_crawling:
    return 'crawl'
    
  return 'walk'
