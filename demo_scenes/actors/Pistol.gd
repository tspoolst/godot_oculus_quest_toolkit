extends Node3D

@export var physicsOn = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_updatePhysicsOn()
	

func _updatePhysicsOn():
	var oldMode = $GrabbableFrameBody.mode
	var neededMode = null
	if physicsOn:
		neededMode = RigidBody3D.MODE_RIGID
	else:
		neededMode = RigidBody3D.FREEZE_MODE_KINEMATIC
	if oldMode != neededMode:
		$GrabbableFrameFlexiBody.mode = neededMode
		
