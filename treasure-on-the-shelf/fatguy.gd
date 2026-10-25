extends CharacterBody2D

var dropped = false
var framesdrop = 0
var little_type: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_layer = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if dropped:
		if framesdrop < 50:
			framesdrop += 1
		collision_layer = 1
		velocity.y = 400
		
	else:
		collision_layer = 2
	move_and_slide()
