extends TextureProgress
class_name HealthBar


onready var tween: Tween = $tween
var current_health: int


func init_bar(bar_max_value: int) -> void:
  max_value = bar_max_value
  value = bar_max_value
  current_health = bar_max_value


func update_value(new_value: int) -> void:
  update_bar(current_health, new_value)
  current_health = new_value
  

func update_bar(old_value: int, new_value: int) -> void:
  var _interpolate_value: bool = tween.interpolate_property(
    self,
    'value',
    old_value,
    new_value,
    .2  
  )  
  
  var _start = tween.start()
