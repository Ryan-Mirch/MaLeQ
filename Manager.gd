extends CanvasLayer

@onready var generationQuantitySpinBox = $"HBoxContainer/Generation Quantity" as SpinBox

const QUADRUPED_SCENE = preload("res://Quadruped.tscn")
const SURVIVORS_KEPT = 2

var activeQuadrupeds = []
var survivors = [] #stores the data array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_generation_pressed() -> void:	
	for i in generationQuantitySpinBox.value:
		var quadrupedInstance = QUADRUPED_SCENE.instantiate()
		get_tree().root.add_child(quadrupedInstance)
		quadrupedInstance.position = Vector3(0,0.5,0.3)
		quadrupedInstance.rotation.y = deg_to_rad(270)
		activeQuadrupeds.append(quadrupedInstance)
		

func _on_end_generation_pressed() -> void:
	for q in activeQuadrupeds:
		q.freeze = true
	
	for q in activeQuadrupeds:
		q.queue_free()
	activeQuadrupeds.clear()
	
func _calculate_quadruped_fitness(q: Quadruped) -> float:
	return 0
	
