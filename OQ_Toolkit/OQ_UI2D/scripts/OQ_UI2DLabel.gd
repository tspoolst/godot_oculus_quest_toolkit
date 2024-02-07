@tool
extends Node3D

@export var text := "I am a Label\nWith a new line"
@export var margin := 16;
@export var billboard := false;
@export var depth_test := true;

enum ResizeModes {AUTO_RESIZE, FIXED}
@export var resize_mode := ResizeModes.AUTO_RESIZE

@export var font_size_multiplier := 1.0
@export var font_color := Color(1,1,1,1);
@export var background_color := Color(0,0,0,1);
#export var line_to_parent = false;

@export var transparent := false: set = set_transparent
func set_transparent(value: bool):
	transparent = value
	update_transparency()


@onready var ui_label : Label = $SubViewport/ColorRect/CenterContainer/Label
@onready var ui_container : CenterContainer = $SubViewport/ColorRect/CenterContainer
@onready var ui_color_rect : ColorRect = $SubViewport/ColorRect
@onready var ui_viewport : SubViewport = $SubViewport
@onready var mesh_instance : MeshInstance3D = $MeshInstance3D
var ui_mesh : QuadMesh = null;

var mesh_material = null;

func _ready():
	ui_mesh = mesh_instance.mesh;
	set_label_text(text);
	
	mesh_material = mesh_instance.material_override
	mesh_material.albedo_texture = ui_viewport.get_texture()
	
	if (billboard):
		mesh_material.params_billboard_mode = StandardMaterial3D.BILLBOARD_FIXED_Y;
	mesh_material.flags_no_depth_test = !depth_test;
	
	# only enable transparency when necessary as it is significantly slower than non-transparent rendering
	update_transparency()
	
	ui_label.add_theme_color_override("font_color", font_color)
	ui_color_rect.color = background_color
	
	#if (line_to_parent):
		#var p = get_parent();
		#$LineMesh.visible = true;
		#var center = (global_transform.origin + p.global_transform.origin) * 0.5;
		#$LineMesh.global_transform.origin = center;
		#$LineMesh.look_at_from_position()


func update_transparency():
	if mesh_material != null:
		mesh_material.flags_transparent = transparent;


func resize_auto():
	var size = ui_label.get_minimum_size();
	var res = Vector2(size.x + margin * 2, size.y + margin * 2)
	
	ui_container.set_size(res)
	ui_viewport.set_size(res)
	ui_color_rect.set_size(res)

	#var aspect = res.x / res.y

	ui_mesh.size.x = font_size_multiplier * res.x * vr.UI_PIXELS_TO_METER
	ui_mesh.size.y = font_size_multiplier * res.y * vr.UI_PIXELS_TO_METER


func resize_fixed():
	# resize container and viewport while parent and mesh stay fixed

	var parent_width = scale.x
	var parent_height = scale.y
	
	var new_size = Vector2(parent_width * 1024 / font_size_multiplier, parent_height * 1024 / font_size_multiplier)
	
	ui_viewport.set_size(new_size)
	ui_color_rect.set_size(new_size)
	ui_container.set_size(new_size)

	#if new_size.x < ui_container.get_size().x or new_size.y < ui_container.get_size().y:
	#	print("Your labels text is too large and therefore might look weird. Consider decreasing the font_size_multiplier.")

func get_label_text():
	if (!ui_label): return "";
	return ui_label.text;


func set_label_text(t: String):
	if (!ui_label): return;
	ui_label.set_text(t);
	
	match resize_mode:
		ResizeModes.AUTO_RESIZE:
			resize_auto();
		ResizeModes.FIXED:
			resize_fixed();
	if !Engine.is_editor_hint():
		$update_once.update_once($SubViewport)
			
func _process(_dt):
	if Engine.is_editor_hint():
		set_label_text(text);
			
