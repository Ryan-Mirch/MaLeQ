extends RigidBody3D
@onready var CoxaJoint = $HingeJoint3D as HingeJoint3D
@onready var TibiaJoint = $Tibia/HingeJoint3D as HingeJoint3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_coxa_velocity(0)
	set_tibia_velocity(3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_coxa_velocity(vel: float) -> void:
	CoxaJoint.set_param(CoxaJoint.PARAM_MOTOR_TARGET_VELOCITY, vel)
	

func set_tibia_velocity(vel: float) -> void:
	TibiaJoint.set_param(TibiaJoint.PARAM_MOTOR_TARGET_VELOCITY, vel)
