extends Sprite
class_name SoldierTexture


var last_direction_state: bool
var on_action: bool = false
var spawn_position: float = 6
export(NodePath) onready var parent = get_node(parent) as KinematicBody2D
export(NodePath) onready var animation = get_node(animation) as AnimationPlayer
export(NodePath) onready var projectile_spawner = get_node(projectile_spawner) as Position2D


func animate(velocity: Vector2) -> void:
  flip_h = set_orientation()
  
  if on_action:
    return
    
  move_behavior(velocity)


func set_orientation() -> bool:
  var mouse_global_position: Vector2 = get_global_mouse_position()
  
  if mouse_global_position.x > parent.global_position.x:
    projectile_spawner.position.x = spawn_position
    last_direction_state = false
    return false
    
  if mouse_global_position.x < parent.global_position.x:
    projectile_spawner.position.x = -spawn_position
    last_direction_state = true
    return true
    
  return last_direction_state


func action_behavior(type: String) -> void:
  on_action = true
  animation.play(type)


func move_behavior(velocity: Vector2) -> void:
  if velocity != Vector2.ZERO:
    animation.play(get_move_state())
    return
    
  animation.play('idle')


func get_move_state() -> String:
  if parent.is_crawling:
    return 'crawl'
    
  return 'walk'


func _on_animation_finished(anim_name: String) -> void:
  on_action = false
  
  if anim_name == 'fire' or anim_name == 'throw':
    parent.is_attacking = false
    
  match anim_name:
    'hit':
      parent.set_physics_process(true)
    'death':
      get_tree().call_group('interface', 'reload_game')
