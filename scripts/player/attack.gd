extends Node
class_name AttackState


const Grenade: PackedScene = preload('res://scenes/player/projectile/grenade.tscn')
var weapons_list: Array = [ 'fire', 'throw']
var weapon_index: int = 0
var grenade_amount: int = 5
var max_granade_amount: int = 5
var projectile_amount: int
export(String) var class_weapon
export(int) var projectile_max_amount
export(PackedScene) var fire_projectile
export(NodePath) onready var texture = get_node(texture) as Sprite
export(NodePath) onready var camera = get_node(camera) as Camera2D
export(NodePath) onready var soldier = get_node(soldier) as KinematicBody2D
export(NodePath) onready var projectile_spawner = get_node(projectile_spawner) as Position2D 
onready var weapons_dict: Dictionary = {
  'throw': 'Grenade',
  'fire': class_weapon  
}


func _ready() -> void:
  projectile_amount = projectile_max_amount


func attack() -> void:
  if not can_shoot(weapons_list[weapon_index]):
    return
    
  if Input.is_action_just_pressed('ui_attack') and not soldier.is_attacking:
    soldier.is_attacking = true
    update_ammo(weapons_list[weapon_index], 'decrease', 1)
    texture.action_behavior(weapons_list[weapon_index])


func spawn_projectile(type: String) -> void:
  var projectile_direction: Vector2 = (
    soldier.get_global_mouse_position() - soldier.global_position
  ).normalized()
  var projectile = null
  
  match type:
    'fire':
      projectile = fire_projectile.instance()
    'throw':
      projectile = Grenade.instance()
    
  get_tree().root.call_deferred('add_child', projectile)
  projectile.global_position = projectile_spawner.global_position
  # Conectar o Sinal de camera shake
  projectile.direction = projectile_direction
  


func can_shoot(type: String) -> bool:
  if type == 'fire' and projectile_amount > 0:
    return true
    
  if type == 'throw' and grenade_amount > 0:
    return true
    
  return false


func update_ammo(weapon_type: String, type: String, value: int) -> void:
  if weapon_type == 'throw' and type == 'increase':
    grenade_amount += value

  if weapon_type == 'throw' and type == 'decrease':
    grenade_amount -= value
    
  if weapon_type == 'fire' and type == 'increase':
    projectile_amount += value
    
  if weapon_type == 'fire' and type == 'decrease':
    projectile_amount -= value
    
  verify_ammo_amount(weapon_type)
  

func verify_ammo_amount(weapon_type: String) -> void:
  if weapon_type == 'throw' and grenade_amount > max_granade_amount:
    grenade_amount = max_granade_amount
    
  if weapon_type == 'fire' and projectile_amount > projectile_max_amount:
    projectile_amount = projectile_max_amount


func can_change_weapon_index(index: int) -> bool:
  if index == 4 and weapon_index == weapons_list.size() -1:
    return false
    
  if index == 5 and weapon_index == 0:
    return false
    
  return true

func _unhandled_input(event) -> void:
  if not event is InputEventMouseButton:
    return
    
  var event_as_number: int = event.button_index
  if event_as_number == 4 and can_change_weapon_index(4):
    weapon_index += 1
    
  if event_as_number == 5 and can_change_weapon_index(5):
    weapon_index -= 1
