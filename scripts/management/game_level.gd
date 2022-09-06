extends Node2D
class_name GameLevel


const CELL_SIZE: int = 16
onready var assault: KinematicBody2D = $Assault
onready var terrain: Navigation2D = $terrain
onready var base_terrain: TileMap = $terrain/base_terrain
onready var layered_objects: YSort = $layered_objects
var avaliable_spawn_tiles_list: Array = []


func _ready() -> void:
  define_camera_limit()
  set_spawn_tiles()
  

func _process(_delta: float) -> void:
  if assault == null:
    return
    
  send_player()


func send_player() -> void:
  get_tree().call_group('enemy', 'get_player', assault, terrain)


func define_camera_limit() -> void:
  var soldier_camera: Camera2D = assault.get_node('camera')
  var used_rect_tile: Rect2 = base_terrain.get_used_rect()
  soldier_camera.limit_left = int(used_rect_tile.position.x)
  soldier_camera.limit_top = int(used_rect_tile.position.y)
  soldier_camera.limit_right = int(used_rect_tile.size.x * CELL_SIZE)
  soldier_camera.limit_bottom = int(used_rect_tile.size.y * CELL_SIZE)


func set_spawn_tiles() -> void:
  for tile in base_terrain.get_used_cells():
    find_edges(tile)
    
  layered_objects.avaliable_cells = avaliable_spawn_tiles_list
    

func find_edges(current_cell: Vector2) -> void:
  var used_rect: Rect2 = base_terrain.get_used_rect()
  var x_size: float = used_rect.size.x
  var y_size: float = used_rect.size.y
  var x_position: float = used_rect.position.x
  var y_position: float = used_rect.position.y
  
  if current_cell.x == x_size - 1 or current_cell.x == x_position:
    avaliable_spawn_tiles_list.append(current_cell)
    
  if current_cell.y == y_size -1 or current_cell.y == y_position:
    avaliable_spawn_tiles_list.append(current_cell)
