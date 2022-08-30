extends Node
class_name MoveState


var velocity: Vector2
export(int) var walk_speed
export(int) var crawl_speed
export(NodePath) onready var soldier = get_node(soldier) as KinematicBody2D


func move() -> void:
  if soldier.is_attacking:
    return
    
  velocity = get_direction() * move_state()
  soldier.is_crawling = crawling_state()
  soldier.move_and_slide(velocity)


func get_direction() -> Vector2:
  return Vector2(
    Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left'),
    Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up')
   ).normalized()


func move_state() -> int:  
  if Input.is_action_pressed('ui_select'):
    return crawl_speed
    
  return walk_speed


func crawling_state() -> bool:
  if Input.is_action_pressed('ui_select') and velocity != Vector2.ZERO:
    return true
    
  return false
  
