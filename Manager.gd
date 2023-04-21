extends CanvasLayer

@onready var generationQuantitySpinBox = %"Generation Quantity" as SpinBox
@onready var generationLabel = %"Generation Label" as Label
@onready var continueButton = %Continue as Button
@onready var autoCheckButton = %Auto as CheckButton
@onready var timeScaleLabel = %"Time Scale Label" as Label

const QUADRUPED_SCENE = preload("res://Quadruped.tscn")
const SURVIVORS_USED = 3
const MIN_VEL = -2.5
const MAX_VEL = 2.5
const ARRAY_LENGTH = 7
const GENERATION_TIME = 20

var currentQuadrupeds = []
var previousQuadrupeds = []

var generation = 1
var generationRunning = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func start_generation() -> void:
	if autoCheckButton.button_pressed:
		get_tree().create_timer(GENERATION_TIME).timeout.connect(end_generation)
	
	generationRunning = true
	continueButton.text = "End Generation " + str(generation)	
	
	if generation == 1:
		for i in generationQuantitySpinBox.value:
			var quadrupedInstance = QUADRUPED_SCENE.instantiate()
			quadrupedInstance.name = "Maleq - " + str(i)
			quadrupedInstance.randomize_data()
			currentQuadrupeds.append(quadrupedInstance)
			
	else:
		for i in SURVIVORS_USED:
			var quadrupedInstance = QUADRUPED_SCENE.instantiate()
			quadrupedInstance.data = previousQuadrupeds[i].data
			currentQuadrupeds.append(quadrupedInstance)
		
			
		var babies = []
		for i in generationQuantitySpinBox.value - SURVIVORS_USED:
			var newBaby = create_baby(previousQuadrupeds[randi_range(0,SURVIVORS_USED-1)], previousQuadrupeds[randi_range(0,SURVIVORS_USED-1)])
			mutate(newBaby,randf_range(0.1,0.2),randf_range(0.3,1))
			babies.append(newBaby)
			
		currentQuadrupeds.append_array(babies)
		
		for q in previousQuadrupeds:
			q.queue_free()
		previousQuadrupeds.clear()
		
	
	for q in currentQuadrupeds:	
		q.position = Vector3(0,0.65,0.3)
		q.rotation.y = deg_to_rad(90)		
		get_tree().root.add_child(q)
		q.running = true
	
	generationLabel.text = "Generation: " + str(generation)
		
		

func end_generation() -> void:
	if autoCheckButton.button_pressed:
		get_tree().create_timer(0.5).timeout.connect(start_generation)
	
	generation += 1
	generationRunning = false
	continueButton.text = "Start Generation " + str(generation)
	
	#Freeze everything
	for q in currentQuadrupeds:
		q.freeze = true
	
	for q in currentQuadrupeds:
		previousQuadrupeds.append(q)
		
	currentQuadrupeds.clear()
	
	
	#Sort based on fitness
	previousQuadrupeds.sort_custom(_sort_by_fitness)
	
	for q in previousQuadrupeds:
		q.visible = false
	
	for i in SURVIVORS_USED:
		previousQuadrupeds[i].visible = true
	
	#Print fitness levels
	for q in previousQuadrupeds:
		print(q.name + ": " + str(q.calculate_fitness()))
	

	
func _sort_by_fitness(q1, q2) -> bool:
	return q1.calculate_fitness() > q2.calculate_fitness()
	
	
func create_baby(q1: Quadruped, q2: Quadruped) -> Quadruped:
	var arrayLength = ARRAY_LENGTH
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
		for key in q1.data.keys():
			newData[key].append((q1.data[key][i] * q2.data[key][i])/2)
			
	
	var baby = QUADRUPED_SCENE.instantiate()
	baby.data = newData
	return baby
	
func mutate(q: Quadruped, frequency: float, strength: float = 1) -> void:
	var mutatedData = q.data
	
	for key in mutatedData.keys():
		for i in ARRAY_LENGTH:
			if(randf() > frequency):
				var mutateTarget = randf_range(MIN_VEL, MAX_VEL)
				mutatedData[key][i] = lerp(mutatedData[key][i], mutateTarget, randf_range(min(0.2,strength),strength))
	

func _on_continue_pressed() -> void:
	if generationRunning: end_generation()
	else: start_generation()
		


func _on_time_scale_slider_value_changed(value: float) -> void:
	Engine.set_time_scale(value)
	timeScaleLabel.text = "Time Scale: " + str(value)
