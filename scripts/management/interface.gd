extends CanvasLayer
class_name Interface


onready var current_weapon: Label = $current_weapon
onready var ammo: Label = $ammo


func set_current_weapon(weapon: String) -> void:
  current_weapon.text = 'Current Weapon: ' + weapon


func set_ammo(current_ammo: int, max_ammo: int) -> void:
  ammo.text = 'Ammo: ' + str(current_ammo) + '/' + str(max_ammo)
  

func reload_game() -> void:
  var _reload = get_tree().change_scene("res://scenes/management/game_level.tscn")
