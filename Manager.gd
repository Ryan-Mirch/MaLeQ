extends CanvasLayer

@onready var generationQuantitySpinBox = $"HBoxContainer/Generation Quantity" as SpinBox

const QUADRUPED_SCENE = preload("res://Quadruped.tscn")
const SURVIVORS_KEPT = 2

var activeQuadrupeds = []
var survivors = []

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
		quadrupedInstance.rotation.y = deg_to_rad(90)
		quadrupedInstance.name = "Maleq - " + str(i)
		activeQuadrupeds.append(quadrupedInstance)
		

func _on_end_generation_pressed() -> void:
	for q in activeQuadrupeds:
		q.freeze = true
		
	activeQuadrupeds.sort_custom(_sort_by_fitness)
	
	for q in activeQuadrupeds:
		print(q.name + ": " + str(q.calculate_fitness()))
	
	for q in activeQuadrupeds:		
		q = q as Quadruped
		q.fitnessLabel.text = str(snapped(q.calculate_fitness(),0.01))
		survivors.append(q)
		
		if survivors.size() >= SURVIVORS_KEPT:
			break
	
	for q in activeQuadrupeds:
		if !survivors.has(q):
			q.queue_free()
			
	activeQuadrupeds.clear()
	
func _sort_by_fitness(q1, q2) -> bool:
	return q1.calculate_fitness() > q2.calculate_fitness()
	
	

	
