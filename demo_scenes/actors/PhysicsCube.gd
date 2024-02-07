extends OQClass_GrabbableRigidBody

@onready var mesh_inst := $MeshInstance3D

var currently_grabbable = false

func _ready():
	mesh_inst.set_surface_override_material(0, StandardMaterial3D.new())

func _set_color(color):
	var mat : StandardMaterial3D = mesh_inst.get_surface_override_material(0)
	mat.albedo_color = color
	
func _set_grabbable_color():
	if currently_grabbable:
		_set_color(Color.YELLOW)
	else:
		_set_color(Color.WHITE)

func _on_PhysicsCube_grabbability_changed(body, grabbable, controller):
	currently_grabbable = grabbable
	if not is_grabbed:
		_set_grabbable_color()

func _on_PhysicsCube_grabbed(body, controller):
	if controller is XRController3D:
		if controller.controller_id == 1:# left
			_set_color(Color.LIGHT_GREEN)
		else:# right
			_set_color(Color.CORAL)

func _on_PhysicsCube_released(body, controller):
	_set_grabbable_color()
