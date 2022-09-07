extends KinematicBody2D
class_name Enemy


onready var texture: Sprite = $texture
onready var collision: CollisionShape2D = $collision
onready var animation: AnimationPlayer = $animation
onready var monitoring_timer: Timer = $monitoring_timer
#var is_near: bool = false
var distance: float
var path: Array = []
var velocity: Vector2
var items_dict: Dictionary = {
  'MW Ammo': [
    [1, 40],
    preload('res://scenes/player/projectile/main_weapon_ammo.tscn')
   ],
  'Grenade Ammo': [
    [41, 60],
    preload('res://scenes/player/projectile/grenade_ammo.tscn')
   ],
  'Health': [
    [61, 80],
    preload('res://scenes/combat/health.tscn')
   ]  
}
export(float) var attack_cooldown
export(int) var damage
export(int) var move_speed
export(int) var distance_threshhold


func _physics_process(_delta: float) -> void:
  animate()
  if distance < distance_threshhold:
#    is_near = true
    return
    
#  is_near = false
  velocity = move_and_slide(velocity)
  verify_direction()

func verify_direction() -> void:
  if velocity.x > 0:
    texture.flip_h = false
    
  if velocity.x < 0:
    texture.flip_h = true
  
  
func animate() -> void:
  if velocity != Vector2.ZERO:
    animation.play('walk')
    return
    
  animation.stop()


func set_collision() -> void:
  change_monitoring_state(true)
  monitoring_timer.start(attack_cooldown)


func change_monitoring_state(state: bool) -> void:
  collision.set_deferred('disabled', state)


func get_player(player_reference: Soldier, navigation: Navigation2D) -> void:
  path = navigation.get_simple_path(global_position, player_reference.global_position, false)
  
  if path.size() == 0:
    return
    
  distance = global_position.distance_to(player_reference.global_position)
  velocity = global_position.direction_to(path[1]) * move_speed
  
  if global_position == path[0]:
    path.pop_front()


func spawn_item(item_to_spawn: PackedScene) -> void:
  var item = item_to_spawn.instance()
  item.global_position = global_position
  get_tree().root.call_deferred('add_child', item)


func get_item(item_key: String) -> void:
  var random_number: int = randi() % 100 + 1
  var drop_probability_list: Array = items_dict[item_key][0]
  var min_number: int = drop_probability_list[0]
  var max_number: int = drop_probability_list[1]
  
  if random_number >= min_number and random_number <= max_number:
    spawn_item(items_dict[item_key][1])
  

func roll_dice() -> void:
  for item in items_dict.keys():
    get_item(item)
    


func kill() -> void:
  roll_dice()
  queue_free()


func _on_monitoring_timer_timeout() -> void:
  change_monitoring_state(false)


func _on_notifier_screen_entered() -> void:
  visible = true


func _on_notifier_screen_exited() -> void:
  visible = false
