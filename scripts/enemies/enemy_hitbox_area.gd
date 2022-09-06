extends HitboxArea
class_name EnemyHitBox


const DeathEffect: PackedScene = preload('res://scenes/effects/death_effect.tscn') 


func update_health(damage:int, _type: String) -> void:
  health -= damage
  health_bar.update_value(health)
  
  if health <= 0:
    spawn_effect()
    get_parent().kill()


func spawn_effect() -> void:
  var death_effect = DeathEffect.instance()
  death_effect.global_position = global_position
  get_tree().root.call_deferred('add_child', death_effect)


func _on_hitbox_area_entered(area: Area2D) -> void:
  if area.name == 'hitbox_area':
    return

  area.kill()
  update_health(area.damage, '')


func _on_hitbox_area_body_entered(_body: Node) -> void:
  pass
