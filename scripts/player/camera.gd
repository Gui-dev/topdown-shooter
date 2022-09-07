extends Camera2D
class_name SoldierCamera


var shake_lifetime: float
var shake_strength: float


func _ready() -> void:
  randomize()
  

func shake(lifetime: float, strength: float) -> void:
  if shake_lifetime != 0:
    return

  shake_lifetime = lifetime
  shake_strength = strength
  
  while shake_lifetime > 0:
    offset = Vector2(
      rand_range(-shake_strength, shake_strength),
      rand_range(shake_strength, -shake_strength)  
    )
    
    shake_lifetime -= get_process_delta_time()
    yield(get_tree(), 'idle_frame')
    
  reset()
  

func reset() -> void:
  offset = Vector2.ZERO
  shake_lifetime = 0.0
  shake_strength = 0.0
