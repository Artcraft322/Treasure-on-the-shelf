extends Node2D

var current_player:Node2D = null
var touching_switch = false
var player_touching_switch: Node2D = null
var number_of_allowed_players = 7


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Camera2D.global_position.y = -800
	get_tree().paused = true
	$textbubble1.hide()
	$textbubble2.hide()
	$textbubble3.hide()
	$Littleguysleft.hide()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var drop = Input.is_action_just_pressed("spawn_new")
	var rotate_right = Input.is_action_just_pressed("rotate_right")
	var rotate_left = Input.is_action_just_pressed("rotate_left")
	
	current_player.global_position = get_global_mouse_position()
	
	if rotate_right:
		current_player.rotate(deg_to_rad(45))
	elif rotate_left:
		current_player.rotate(deg_to_rad(-45))
		
	if drop:
		player_drop()
	
	if touching_switch:
		if player_touching_switch.framesdrop == 50:
			$Camera2D.global_position.x = 1600
			number_of_allowed_players = -2
	
	if number_of_allowed_players == -1:
		$Camera2D.global_position.x = -1600
		

func player_stack():
	var player
	var littletype
	if number_of_allowed_players == 1:
		littletype = 1
	else:
		littletype = randi_range(1,3)
	if littletype == 1:
		player = load("res://player.tscn")
	elif littletype == 2:
		player = load("res://fatguy.tscn")
	elif littletype == 3:
		player = load("res://armsguy.tscn")
	
	
	
	var new_player =  player.instantiate()
	current_player = new_player
	add_child(current_player)
	

func player_drop():
	number_of_allowed_players -= 1
	current_player.velocity.y = 400
	current_player.dropped = true 
	current_player = null
	player_stack()
	$Littleguysleft.text = "Little Guys left: " + str(number_of_allowed_players)
	


func _on_switch_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		touching_switch = true
		player_touching_switch = body
		if body.framesdrop == 50:
			print("you win")
		


func _on_switch_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		touching_switch = false
		player_touching_switch = null


func _on_start_pressed() -> void:
	$AudioStreamPlayer.play()
	$Camera2D.global_position.y = 0
	$textbubble1.show()
	await get_tree().create_timer(2).timeout
	$textbubble1.hide()
	$textbubble2.show()
	await  get_tree().create_timer(2).timeout
	$textbubble2.hide()
	$textbubble3.show()
	await get_tree().create_timer(2).timeout
	$textbubble3.hide()
	$speach_bubble_spr.hide()
	$cutsceneplayer.hide()
	get_tree().paused = false
	
	player_stack()
	$start.hide()
	$Littleguysleft.show()
	$Littleguysleft.text = "Little Guys left: " + str(number_of_allowed_players)


func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer.play()


func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
