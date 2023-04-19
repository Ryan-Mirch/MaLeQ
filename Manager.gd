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
	#Freeze everything
	for q in activeQuadrupeds:
		q.freeze = true
	
	#Sort based on fitness
	activeQuadrupeds.sort_custom(_sort_by_fitness)
	
	#Print fitness levels
	for q in activeQuadrupeds:
		print(q.name + ": " + str(q.calculate_fitness()))
	
	#Keeping survivors
	for q in activeQuadrupeds:		
		q = q as Quadruped
		q.fitnessLabel.text = str(snapped(q.calculate_fitness(),0.01))
		survivors.append(q)
		
		if survivors.size() >= SURVIVORS_KEPT:
			break
	
	#Destroying non-survivors
	for q in activeQuadrupeds:
		if !survivors.has(q):
			q.queue_free()
			
	activeQuadrupeds.clear()
	
	create_baby(survivors[0], survivors[1])
	
	
func _sort_by_fitness(q1, q2) -> bool:
	return q1.calculate_fitness() > q2.calculate_fitness()
	
	
func create_baby(q1: Quadruped, q2: Quadruped) -> Quadruped:
	var arrayLength = q1.ARRAY_LENGTH
	var splicePoint = randi_range(arrayLength*0.25, arrayLength*0.75)
	var newData = {
	"Leg1Femur"=[],
	"Leg2Femur"=[], 
	"Leg3Femur"=[], 
	"Leg4Femur"=[], 
	"Leg1Tibia"=[],
	"Leg2Tibia"=[],
	"Leg3Tibia"=[],
	"Leg4Tibia"=[]
	}
	
	for i in arrayLength:
		if i < splicePoint:
			for key in q1.data.keys():
				newData[key].append(q1.data[key][i])
		else:
			for key in q2.data.keys():
				newData[key].append(q2.data[key][i])
				
	print("Splice Point: " + str(splicePoint))
	print(q1.data["Leg1Femur"])
	print(q2.data["Leg1Femur"])
	print(newData["Leg1Femur"])
	
	var baby = QUADRUPED_SCENE.instantiate()
	baby.data = newData
	return baby
	

	
