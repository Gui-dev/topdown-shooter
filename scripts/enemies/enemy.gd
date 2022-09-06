extends KinematicBody2D
class_name Enemy


onready var texture: Sprite = $texture
onready var collision: CollisionShape2D = $collision
onready var monitoring_timer: Timer = $monitoring_timer
var distance: float
var path: Array = []
var velocity: Vector2
export(float) var attack_cooldown
export(int) var damage
export(int) var move_speed
export(int) var distance_threshhold


func _physics_process(_delta: float) -> void:
  if distance < distance_threshhold:
    return
    
  velocity = move_and_slide(velocity)
  verify_direction()
  animate()


func verify_direction() -> void:
  if velocity.x > 0:
    texture.flip_h = false
    
  if velocity.x < 0:
    texture.flip_h = true
  
  
func animate() -> void:
  pass


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


func kill() -> void:
  queue_free()


func _on_monitoring_timer_timeout() -> void:
  change_monitoring_state(false)


func _on_notifier_screen_entered() -> void:
  visible = true


func _on_notifier_screen_exited() -> void:
  visible = false
