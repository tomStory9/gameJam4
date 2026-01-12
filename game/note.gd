extends Sprite2D
# Note Node
const SCREEN_BOTTOM := 600
var speed: float = 100.0
func _process(delta: float) -> void:
  global_position.y += speed * delta
 
  if global_position.y >= SCREEN_BOTTOM:
	queue_free()
