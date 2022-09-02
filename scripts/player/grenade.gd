extends BaseProjectile
class_name Grenade

onready var timer : Timer = $timer
onready var collision: CollisionShape2D = $collision


func _on_body_entered(_body: Node) -> void:
  return


func _on_animation_finished(_anim_name: String) -> void:
  collision.disabled = false
  timer.start(0.1)


func _on_timer_timeout() -> void:
  kill()
