extends Area2D
class_name Health


var heal: int


func _ready() -> void:
  randomize()
  heal = randi() % 5 + 1


func _on_health_area_entered(area: Area2D) -> void:
  if area is Ammo or area is BaseProjectile:
    return
    
  area.update_health(heal, 'increase')
  queue_free()
